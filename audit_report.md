# Audit Report — DEMETER V1.1
**Date:** 2026-06-09 | **Branche:** `flutterflow` | **Fichiers analysés:** ~120 fichiers Dart, ~20 000 lignes

---

## 1. Structure du projet

```
lib/
├── auth/                        # Wrappers Firebase Auth
├── authentification/            # Écrans login, création compte, OTP
├── backend/
│   ├── firebase/                # Config Firebase
│   ├── firebase_storage/        # Helper upload
│   └── schema/                  # 14 modèles Firestore (records)
├── champs/
│   ├── activites/               # CRUD activités (4 écrans)
│   ├── exploitations/           # Gestion exploitations (4 écrans)
│   └── parcelles/               # Gestion parcelles (4 écrans)
├── components/                  # Widgets partagés (imagepicker, commentaires…)
├── flutter_flow/                # Utilitaires & thème FlutterFlow
├── home/                        # Dashboard
├── parameters/                  # Profil, notifications
├── personnel/                   # RH / équipe
└── tresor/                      # Finances (dépenses, matériel, récoltes, stocks)
```

**Stack confirmée:**
- Firebase (Firestore + Auth + Storage)
- `go_router 12.x` pour la navigation
- `provider 6.x` pour l'état global (`FFAppState`)
- Pattern FlutterFlow : un fichier `_model.dart` + `_widget.dart` par écran
- Dépendances utiles déjà présentes : `image_picker`, `firebase_storage`, `sqflite`, `cached_network_image`

---

## 2. Collections Firestore identifiées

| Collection | Champs clés | Statut |
|---|---|---|
| `USERS` | `roles: List<String>`, `is_active`, `phone_number` | ✅ `roles` au pluriel |
| `exploitations` | `nom`, `localisation`, `superficie` | ⚠️ pas de `tenant_id` |
| `Parcelles` | `exploitation_ref`, `type_sol`, `superficie` | ⚠️ majuscule incohérente |
| `activites` | `statut`, `approvedby`, `RejectedBy`, `photoillustration` | ⚠️ nommage mixte FR/EN |
| `depenses` | `statut`, `valide_par`, `Justif_depense`, `justificatif_url` | ⚠️ champs doublons |
| `membres_exploitation` | `user_ref`, `exploitation_ref`, `role: String` | ❌ `role` singulier (ancien modèle) |
| `collaborateurs` | référencé dans custom_functions | ⚠️ schema non trouvé |
| `stocks`, `recoltes`, `revenus`, `materiels` | présents | OK |

---

## 3. Problèmes P0 — CRITIQUES

### 🔴 P0.1 — Gestion des images cassée

**Localisation:** `lib/components/imagepicker1_widget.dart`, `lib/backend/firebase_storage/storage.dart`

**Problèmes:**
1. **Caméra non fonctionnelle** — L'icône affiche `Icons.camera_alt_outlined` mais le code utilise `MediaSource.photoGallery` uniquement. La caméra n'est jamais déclenchée.
2. **Pas de compression** — Les images sont uploadées telles quelles (aucun appel à compress/resize).
3. **Gestion d'erreurs absente** — En cas d'échec upload, le message affiché est `'Failed to upload data'` (anglais, aucun détail).
4. **Double stockage incohérent dans `DepensesRecord`** — Deux champs coexistent : `justificatif_url: String` (champ unique) et `Justif_depense: List<String>` (liste). Lequel est canonique ? Risque de données orphelines.
5. **Aucune prévisualisation** — Après upload, l'URL est stockée mais aucun widget ne l'affiche dans le même composant.
6. **`Imagepicker1Widget` non paramétrable** — Pas de callback, pas de `onUploaded(String url)`. Impossible à réutiliser proprement.

**Fichiers concernés:**
- `lib/components/imagepicker1_widget.dart` (L85–140)
- `lib/backend/firebase_storage/storage.dart`
- `lib/tresor/depenses/ajouter_depense_page/ajouter_depense_page_widget.dart`

---

### 🔴 P0.2 — Design system incomplet

**Localisation:** `lib/flutter_flow/flutter_flow_theme.dart`

**Ce qui existe (bon point de départ):**
- `FlutterFlowTheme` avec `LightModeTheme` / `DarkModeTheme`
- `FFDesignTokens` avec `FFSpacing`, `FFRadius`, `FFShadows`
- Typographie cohérente : Inter + Inter Tight

**Problèmes:**
1. **Couleurs par défaut FlutterFlow** — `primary = 0xFF4B39EF` (violet). DEMETER est une app agricole → couleurs vertes/terres attendues.
2. **Dark mode identique au light** — `DarkModeTheme.primary` = même violet `0xFF4B39EF` que le light mode. Le dark mode n'a pas été personnalisé.
3. **Pas de composants réutilisables** — Aucun `CustomButton`, `CustomCard`, `CustomTextField`. Chaque écran redéfinit ses boutons inline.
4. **Nommage inconsistant des couleurs** — `tertiary = 0xFFEE8B60` (orange) utilisé comme couleur de bouton dans `imagepicker1_widget.dart` sans sémantique claire.
5. **`useMaterial3: false`** dans `main.dart` — Non standard pour une nouvelle app en 2024+.

**Fichiers concernés:**
- `lib/flutter_flow/flutter_flow_theme.dart` (L151–170 : couleurs à redéfinir)
- `lib/main.dart` (L128–133)

---

### 🔴 P0.3 — Système d'habilitations absent

**Localisation:** `lib/flutter_flow/nav/nav.dart`, `lib/backend/schema/`

**Ce qui existe:**
- `UsersRecord.roles: List<String>` ✅ (le champ Firestore est correct)
- `MembresExploitationRecord.habilitation_depenses` et `habilitation_recoltes` (booléens)
- `FFRoute` avec un champ `requireAuth`

**Problèmes critiques:**
1. **`requireAuth = false` sur TOUTES les routes** — Aucune route dans `nav.dart` n'est protégée. Un utilisateur non connecté peut accéder à n'importe quel écran.
2. **Zéro contrôle de rôle dans les écrans** — Aucun screen ne vérifie `currentUserDocument?.roles` avant d'afficher des actions.
3. **`membres_exploitation.role` est un String singulier** — Incohérent avec `USERS.roles` (liste). Le système de membership n'est pas aligné avec le PRD multi-rôles.
4. **Pas de `tenant_id`** — AUCUNE collection Firestore n'a de champ `tenant_id`. Isolation multi-tenant absente. Un utilisateur connecté peut potentiellement lire des données d'autres tenants selon les règles Firestore Security Rules.
5. **Pas de `RequirePermission` widget** — Aucun guard de permission dans l'arbre de widgets.
6. **Helpers RBAC absents** — `hasAnyRole()`, `canPerform()`, `validateRoleCombination()` n'existent pas.

**Fichiers concernés:**
- `lib/flutter_flow/nav/nav.dart` (L525–534 : `requireAuth = false` partout)
- `lib/backend/schema/membres_exploitation_record.dart` (L30 : `role: String`)
- `lib/app_state.dart` (aucune info de rôle dans l'état global)

---

### 🔴 P0.4 — Offline mode absent

**Localisation:** aucune implémentation trouvée

**Ce qui existe:**
- `sqflite: 2.3.3+1` déjà dans `pubspec.yaml` ✅
- `shared_preferences` utilisé pour 2 champs (`CurrentExploitationId`, `ParcelleId`)

**Problèmes:**
1. Tout le chargement de données est en streaming Firestore direct — pas de cache local.
2. Pas de détection de connectivité.
3. Pas de queue de synchronisation pour les actions offline.
4. `sqflite` importé mais jamais utilisé.

---

## 4. Problèmes P1 — MAJEURS

### Validation des formulaires
- Validation quasi-absente sur la plupart des écrans.
- Champ téléphone dans login_phone_page : masque appliqué (`mask_text_input_formatter`) mais aucune validation de longueur/format avant soumission.
- Montants dans dépenses : pas de validation (valeur négative possible).

### Gestion d'erreurs
- Messages d'erreur en anglais (`'Uploading file...'`, `'Failed to upload data'`, `'Success!'`) dans une app entièrement française.
- Pas de service centralisé d'erreurs.
- `_safeInit` dans `app_state.dart` avale silencieusement toutes les exceptions.

### Nommage incohérent (dette technique)
- Mélange FR/EN dans les champs Firestore : `NomExploitation`, `RejectedBy`, `approvedby`, `LibelleParcelle`, `Validateur`, `CommentaireDepense`
- Collections avec majuscules inconsistantes : `Parcelles` vs `activites` vs `USERS`
- Un dossier `parameters/unused/` avec 2 écrans morts

### Tests
- Un seul fichier de test : `test/widget_test.dart` (smoke test vide).
- Couverture : **0%** sur la logique métier.

### Performance
- Pas de pagination sur les listes (StreamBuilders directs).
- Pas de lazy loading images (`cached_network_image` importé mais usage non vérifié).

---

## 5. Ce qui fonctionne bien

| Élément | Détail |
|---|---|
| Schéma `USERS.roles` | `List<String>` correctement défini — prêt pour multi-rôles |
| Design tokens | `FFSpacing`, `FFRadius`, `FFShadows` existent dans `flutter_flow_theme.dart` |
| Navigation | `go_router` correctement configuré, toutes les routes nommées |
| Firebase Auth | Phone + OTP wiring fonctionnel |
| `generateInvitationCode()` | Utilitaire invitation collaborateur déjà prêt |
| `sqflite` | Dépendance offline déjà présente |
| Workflow activités | `approvedby` / `RejectedBy` / `statut` sur `ActivitesRecord` — structure de validation présente |
| Workflow dépenses | `valide_par`, `statut`, `autorisation` sur `DepensesRecord` — structure présente |

---

## 6. Priorités d'implémentation recommandées

| Priorité | Tâche | Fichiers cibles |
|---|---|---|
| **P0.1** | Refactorer `Imagepicker1Widget` → `ImageUploadWidget` paramétrable + caméra + compression | `lib/components/`, `lib/services/image_service.dart` (à créer) |
| **P0.2** | Redéfinir couleurs agricoles dans `FlutterFlowTheme` + créer widgets réutilisables | `lib/flutter_flow/flutter_flow_theme.dart`, `lib/widgets/components/` (à créer) |
| **P0.3a** | Ajouter `requireAuth = true` sur toutes les routes protégées | `lib/flutter_flow/nav/nav.dart` |
| **P0.3b** | Créer `lib/models/role.dart` (enum) + méthodes RBAC sur `UsersRecord` | `lib/models/role.dart` (à créer) |
| **P0.3c** | Ajouter `tenant_id` à toutes les collections + filtres | `lib/backend/schema/*.dart` |
| **P0.3d** | Créer `RequirePermission` widget | `lib/widgets/require_permission.dart` (à créer) |
| **P0.4** | Implémenter `OfflineService` avec Hive/sqflite | `lib/services/offline_service.dart` (à créer) |
| **P1** | Centraliser validation + messages d'erreur en français | `lib/utils/validators.dart` (à créer) |

---

## 7. Résumé exécutif

Le projet DEMETER V1.1 est un **squelette fonctionnel** avec la navigation, les modèles Firestore et l'authentification de base en place. Cependant, les 4 blocages critiques (images, design, RBAC, offline) sont tous absents ou cassés.

Le point le plus urgent est **P0.3 (sécurité)** : toutes les routes sont non protégées et il n'y a aucune isolation des données entre tenants. Ce problème doit être traité avant tout déploiement.

L'infrastructure pour avancer est bonne : les dépendances nécessaires sont dans `pubspec.yaml`, le schéma `roles` est correct dans Firestore, et les design tokens FlutterFlow constituent une base réutilisable.

**Estimation de l'effort restant pour atteindre le MVP :** 4–5 semaines (conforme au PRD v2.1).
