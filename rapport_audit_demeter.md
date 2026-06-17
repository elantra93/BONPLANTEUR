# RAPPORT D'AUDIT DEMETER1 — LECTURE SEULE
**Date : 09/06/2026 — Branche courante — Répertoire : `/root/DEMETER1`**

> Périmètre respecté : aucun fichier modifié. Source de vérité = FlutterFlow ; ce repo est une sauvegarde.

---

## QUESTION 1 — Collections Firestore

### Constat
16 collections référencées dans le code. Tableau complet :

| Collection (nom exact dans le code) | Fichier(s) source | Occurrences |
|---|---|---|
| `USERS` | `schema/users_record.dart:89`, `firebase/firestore.rules:4`, `backend.dart` (via UsersRecord.collection) | 3+ |
| `exploitations` | `schema/exploitations_record.dart:71`, `custom_functions.dart:33`, `firestore.rules:11` | 3+ |
| `activites` | `schema/activites_record.dart:149`, `custom_functions.dart:45,64`, `firestore.rules:18` | 4+ |
| `stocks` | `schema/stocks_record.dart:70`, `firestore.rules:25` | 2 |
| `consommation_stock` | `schema/consommation_stock_record.dart:83`, `firestore.rules:32` | 2 |
| `depenses` | `schema/depenses_record.dart:125`, `firestore.rules:39` | 2 |
| `recoltes` | `schema/recoltes_record.dart:52`, `firestore.rules:46` | 2 |
| `notifications` | `schema/notifications_record.dart:52`, `firestore.rules:53` | 2 |
| `collaborateurs` | `schema/collaborateurs_record.dart:82`, `custom_functions.dart:39`, `firestore.rules:60` | 3 |
| `Speculation` | `schema/speculation_record.dart:40`, `firestore.rules:67` | 2 |
| `Parcelles` | `schema/parcelles_record.dart:125`, `firestore.rules:74` | 2 |
| `Indicateurs` | `schema/indicateurs_record.dart:110`, `firestore.rules:81` | 2 |
| `Materiels` | `schema/materiels_record.dart:89`, `firestore.rules:88` | 2 |
| `membres_exploitation` | `schema/membres_exploitation_record.dart:58`, `firestore.rules:95` | 2 |
| `invitations` | `schema/invitations_record.dart:64`, `firestore.rules:102` | 2 |
| `revenus` | `schema/revenus_record.dart:95`, `firestore.rules:109` | 2 |
| `parcelles` *(minuscule)* | `flutter_flow/custom_functions.dart:27` | 1 |

### Doublons détectés

**`Parcelles` (majuscule) vs `parcelles` (minuscule) → DOUBLON ACTIF**
- `schema/parcelles_record.dart:125` → `collection('Parcelles')` — utilisé par tout le code FlutterFlow généré (requêtes, streams)
- `flutter_flow/custom_functions.dart:27` → `collection('parcelles')` — fonction `getDocRefFromID()`

Le code utilise **les deux formes** simultanément. `getDocRefFromID()` pointe vers une collection inexistante si la vraie collection Firestore est `Parcelles`.

**`consommation_stock` vs `consommations_stock`** : seule la forme `consommation_stock` est présente dans le code. Pas de doublon actif dans le code (mais risque en console si l'humain a créé `consommations_stock` manuellement).

**`USERS` vs `users`** : seule `USERS` est dans le schéma. Pas de référence à `users` (minuscule) dans le code généré. Risque : si la console Firebase a une collection `users` avec des données, elles sont invisibles depuis le code.

**`Speculation` racine vs sous-collection** : seule la collection racine `Speculation` est dans le schéma. Pas de doublon actif dans le code.

- **Niveau de confiance :** CERTAIN pour les doublons de casse trouvés
- **Répondable depuis le code seul :** OUI pour le code / NON pour savoir si la console contient des données dans les deux noms
- **Action recommandée :** Corriger `getDocRefFromID()` dans `custom_functions.dart:27` — remplacer `'parcelles'` par `'Parcelles'`. Vérifier en console Firebase quelles collections existent réellement.

---

## QUESTION 2 — Collection de profils utilisateur

### Constat
La collection `USERS` est **l'unique** collection utilisée pour le profil utilisateur connecté.

**Preuves :**
- `backend/backend.dart:777` → `maybeCreateUser()` écrit dans `UsersRecord.collection` (= `USERS`) après login
- `backend/backend.dart:801` → `updateUserDocument()` met à jour `UsersRecord`
- `parameters/profil_page/profil_page_widget.dart:181-202` → `AuthUserStreamWidget` + `currentUserDisplayName` → lit depuis `UsersRecord` (stream sur `USERS/{uid}`)
- `auth/firebase_auth/auth_util.dart` → gère `currentUserDocument` qui est un `UsersRecord`

**Collections non utilisées pour le profil :**
- `collaborateurs` → employés terrain (pas les utilisateurs connectés)
- `membres_exploitation` → table de jointure user↔exploitation (rôle par exploitation), pas les données de profil
- `users` (minuscule) → absent du code

**Plusieurs collections selon les écrans ?** Non. Un seul point de lecture du profil via `AuthUserStreamWidget` (stream de `USERS/{uid}`).

- **Niveau de confiance :** CERTAIN
- **Répondable depuis le code seul :** OUI
- **Action recommandée :** Confirmer en console Firebase que la collection `USERS` est bien la seule utilisée et qu'il n'y a pas de doublon `users` avec des données.

---

## QUESTION 3 — Flux d'invitation / onboarding

### Constat

**Écrans d'authentification présents dans le code :**

| Ordre | Écran | Route | Action Firebase | Écriture Firestore |
|---|---|---|---|---|
| 1 | `Login1Widget` | `/login1` | `signInWithEmail()` (email+password) | aucune directe (maybeCreateUser en callback) |
| 2 | `CreateAccount1Widget` | `/createAccount1` | `createAccountWithEmail()` (email+password) | **Écrit dans `USERS`** via `maybeCreateUser()` |
| 3 | `LoginPhonePageWidget` | `/loginPhonePage` | `beginPhoneAuth()` → OTP SMS | aucune |
| 4 | `OTPVerificationPageWidget` | `/otpVerificationPage` | Vérifie OTP → connexion | **Écrit dans `USERS`** si nouvel utilisateur |
| 5 | `MotdePasseOublieEmailWidget` | `/motdePasseOublieEmail` | `sendPasswordResetEmail()` | aucune |

**Accès Firestore AVANT authentification :**

Aucun accès Firestore explicite avant auth n'est visible dans le code des écrans de login. La collection `invitations` n'est **pas lue dans les écrans d'authentification** du code généré. Il n'existe pas d'écran de saisie de code d'invitation dans le repo.

**Règles actuelles pour `invitations` :**
```
allow create: if true;  // sans auth
allow read: if true;    // sans auth
allow write: if false;  // update bloqué
allow delete: if false;
```

### Conclusion : Exiger `isAuth()` sur `invitations` risque-t-il de casser l'inscription ?

**NON — dans l'état actuel du code** (mais INCERTAIN pour l'intention finale).

**Justification :** Le code actuel ne lit jamais `invitations` avant que l'utilisateur soit connecté. L'onboarding actuel passe directement par email/password ou OTP sans vérifier un code d'invitation. Si le flux d'invitation est implémenté plus tard (saisie d'un code → vérification dans `invitations` → création de compte), alors oui, `isAuth()` casserait ce flux car la vérification du code doit précéder la création de compte. Il faudra alors autoriser `read` sur `invitations` pour les non-authentifiés, ou faire la vérification via une Cloud Function.

- **Niveau de confiance :** PROBABLE (le flux d'invitation complet n'est pas implémenté dans le code)
- **Répondable depuis le code seul :** PARTIEL
- **Action recommandée :** Ne pas ajouter `isAuth()` sur `invitations` tant que le flux d'invitation n'est pas conçu. Quand il sera implémenté, prévoir une Cloud Function pour la vérification du code (pas d'accès client direct sans auth).

---

## QUESTION 4 — Champ frontière tenant

### Constat
Aucune entité n'utilise un champ `tenant_id`. Le lien à l'exploitation se fait via des `DocumentReference`. Les noms de champ sont **inconsistants** entre collections.

| Entité (collection) | Champ présent | Nom exact du champ Firestore |
|---|---|---|
| `Parcelles` | OUI | `ref_exploitation` (DocumentReference) |
| `depenses` | OUI | `exploitation_ref` (DocumentReference) |
| `activites` | OUI | `exploitation_ref` (DocumentReference) |
| `stocks` | OUI | `exploitation_ref` (DocumentReference) |
| `collaborateurs` (employés) | OUI | `exploitationid` (DocumentReference) |
| `membres_exploitation` | OUI | `exploitation_ref` (DocumentReference) |
| `invitations` | OUI | `exploitation_ref` (DocumentReference) |
| `consommation_stock` | NON direct | lié via `stock_ref` → stocks → `exploitation_ref` |
| `recoltes` | NON direct | lié via `parcelle_ref` → Parcelles → `ref_exploitation` |
| `notifications` | NON | pas de champ exploitation |
| `revenus` | NON visible | non présent dans le schéma lu |

**3 noms différents pour le même concept :** `ref_exploitation`, `exploitation_ref`, `exploitationid`.

- **Niveau de confiance :** CERTAIN pour les entités lues / INCERTAIN pour les schémas non explorés (campagnes, ventes)
- **Répondable depuis le code seul :** OUI pour les entités présentes
- **Action recommandée :** Décider d'un nom canonique unique (`exploitation_ref` est le plus fréquent) et l'utiliser pour toutes les nouvelles collections. Ne pas migrer les données existantes sans accord de l'humain.

---

## QUESTION 5 — Authentification

### Provider Firebase Auth utilisé

**DEUX providers coexistent dans le code :**

1. **Email/Password** → `auth/firebase_auth/email_auth.dart` → `emailSignInFunc()` / `emailCreateAccountFunc()` → utilisé dans `Login1Widget` et `CreateAccount1Widget`
2. **Phone OTP (SMS)** → `authManager.beginPhoneAuth()` → utilisé dans `LoginPhonePageWidget` + `OTPVerificationPageWidget`

`auth/firebase_auth/` contient aussi des fichiers pour Google Auth, Apple Auth, GitHub Auth, Anonymous Auth — mais aucun écran actif ne les utilise.

### Logique de dérivation email ← téléphone

**ABSENTE du code.** La fonction `phoneToEmail` n'existe ni dans `lib/flutter_flow/custom_functions.dart` ni ailleurs dans le repo.

**Incohérence entre le code et CLAUDE.md :**

| | CLAUDE.md (décision) | Code actuel |
|---|---|---|
| Méthode | Téléphone + mot de passe → email dérivé → Firebase Auth email/password | Deux écrans distincts : email brut OU OTP SMS |
| OTP SMS | Hors périmètre MVP | Implémenté dans `LoginPhonePageWidget` |
| `phoneToEmail` | À créer | **Absente** |

### Champ `roles` dans le modèle utilisateur

**OUI.** `users_record.dart:49-52` :
```dart
List<String>? _roles;
List<String> get roles => _roles ?? const [];
```
Le champ `roles` existe comme `List<String>` dans la collection `USERS`.

- **Niveau de confiance :** CERTAIN
- **Répondable depuis le code seul :** OUI
- **Action recommandée :** Créer la custom function `phoneToEmail` dans `lib/flutter_flow/custom_functions.dart`. Modifier ensuite dans FlutterFlow les écrans Login1 et CreateAccount1 pour prendre un numéro de téléphone en entrée et appeler `phoneToEmail()` avant de passer à Firebase Auth.

---

## QUESTION 6 — Règles Firebase committées

### Fichiers présents

| Fichier | Présent |
|---|---|
| `firebase/firestore.rules` | ✅ |
| `firebase/storage.rules` | ✅ |
| `firebase/firebase.json` | ✅ |
| `firebase/firestore.indexes.json` | ✅ |
| `.firebaserc` | ❌ absent |

### Résumé `firestore.rules`

| Collection | create | read | write (update) | delete | Diagnostic |
|---|---|---|---|---|---|
| `USERS` | auth.uid == doc | auth.uid == doc | auth.uid == doc | auth.uid == doc | ✅ Correct |
| `exploitations` | **`true`** | **`true`** | `false` | `false` | ⚠️ Create sans auth, **update impossible** |
| `activites` | **`true`** | **`true`** | `false` | `false` | ⚠️ Create sans auth, **update impossible** |
| `stocks` | **`true`** | **`true`** | `false` | `false` | ⚠️ idem |
| `consommation_stock` | **`true`** | **`true`** | `false` | `false` | ⚠️ idem |
| `depenses` | **`true`** | **`true`** | `false` | `false` | ⚠️ idem — **validation dépense impossible !** |
| `recoltes` | **`true`** | **`true`** | `false` | `false` | ⚠️ idem |
| `notifications` | **`true`** | **`true`** | `false` | `false` | ⚠️ idem |
| `collaborateurs` | **`true`** | **`true`** | `false` | `false` | ⚠️ idem |
| `Speculation` | **`true`** | **`true`** | `false` | `false` | ⚠️ idem |
| `Parcelles` | **`true`** | **`true`** | `false` | `false` | ⚠️ idem |
| `Indicateurs` | **`true`** | **`true`** | `false` | `false` | ⚠️ idem |
| `Materiels` | **`true`** | **`true`** | `false` | `false` | ⚠️ idem |
| `membres_exploitation` | **`true`** | **`true`** | `false` | `false` | ⚠️ idem |
| `invitations` | **`true`** | **`true`** | `false` | `false` | ⚠️ idem |
| `revenus` | **`true`** | **`true`** | **`true`** | **`true`** | 🔴 **TOUT PERMIS sans auth** |

**Problèmes critiques :**

1. `allow write: if false` sur 14 collections → les mises à jour (update) de documents sont **bloquées**. Seul `create` est autorisé. La validation d'une dépense, la mise à jour d'une activité, la modification d'une parcelle sont toutes impossibles.
2. `revenus` : `allow read/write/create/delete: if true` → n'importe qui sans compte peut lire, écrire et supprimer toutes les données de revenus.
3. `create: if true` sur toutes les collections → n'importe qui sans compte peut créer des documents.

### Résumé `storage.rules`

```
match /{allPaths=**} { allow read, write: if false; }   // BLOQUE TOUT
match /users/{userId}/{allPaths=**} {
  allow read: if true;                                   // lecture publique
  allow write: if request.auth.uid == userId;            // écriture authentifiée
}
```

**Conséquence critique :** Les uploads vers `collaborateurs/photos/` (fait par `ajouter_collaborateur_page`) et vers d'autres chemins non-`/users/...` échoueront en production. Seul le chemin `/users/{userId}/...` est autorisé.

- **Niveau de confiance :** CERTAIN
- **Répondable depuis le code seul :** OUI
- **Action recommandée :** Corriger les règles en console Firebase (hors périmètre Claude Code). Voir punch-list.

---

## QUESTION 7 — Images

### Écrans gérant des photos/images

| Écran | Photos gérées | URL stockée dans | Mécanisme | Problème |
|---|---|---|---|---|
| `Imagepicker1Widget` (composant) | Justificatifs multi-images | `_model.uploadedFileUrls_uploadDataJustif` (list) | `selectMedia` + `uploadData` (FF natif) | aucun identifié |
| `ajouter_depense_page` | Justificatifs (`_justifUrls`) | Champ `Justif_depense` (List\<String\>) dans `depenses` | `ImageService` (import ligne 3) | Chemin storage à vérifier |
| `ajouter_collaborateur_page` | Photo identité + Photo travailleur | Champs `photoidcard` et `photoworker` dans `collaborateurs` | `storagePath: 'collaborateurs/photos'` | **BLOQUÉ par storage.rules** (chemin hors `/users/`) |
| `ActivitesRecord` | Photos illustration | Champ `photoillustration` (List\<String\>) dans `activites` | Champ défini, aucun upload trouvé dans le widget | Fonctionnalité incomplète |

### Custom action/function liée aux images dans lib/custom_code/

**Le répertoire `lib/custom_code/` n'existe pas.**

En dehors de ce répertoire :
- `lib/services/image_service.dart` → `ImageService.pickAndUpload()` → service complet (pick, compress, upload, snackbar feedback) → **HORS périmètre CLAUDE.md** (fichier dans `lib/services/`, interdit)

- **Niveau de confiance :** CERTAIN
- **Répondable depuis le code seul :** OUI
- **Action recommandée :** Corriger `storage.rules` pour autoriser `collaborateurs/photos/...` et autres chemins utilisés. Créer une custom action dans `lib/custom_code/actions/` (quand demandé) pour remplacer/compléter `ImageService`.

---

## QUESTION 8 — Contenu de lib/custom_code/

### Constat

**`lib/custom_code/` n'existe pas** dans ce repo.

### Fonctions présentes dans `lib/flutter_flow/custom_functions.dart`

| Fonction | Signature | Description | Problème |
|---|---|---|---|
| `formatDecimal` | `double? formatDecimal(String?)` | Remplace virgule→point et parse en double | aucun |
| `getDocRefFromID` | `DocumentReference? getDocRefFromID(String?)` | Ref vers `collection('parcelles')` | **DOUBLON actif** : minuscule vs `Parcelles` |
| `getExploitationRef` | `DocumentReference? getExploitationRef(String?)` | Ref vers `exploitations/{id}` | aucun |
| `getWorkerRefFromID` | `DocumentReference? getWorkerRefFromID(String?)` | Ref vers `collaborateurs/{id}` | aucun |
| `getActiviteRefFromTxt` | `DocumentReference? getActiviteRefFromTxt(String?)` | Ref vers `activites/{id}` | aucun |
| `generateInvitationCode` | `String? generateInvitationCode()` | Génère code `DEM-XXXXXX` (sécurisé) | aucun |
| `stringListToActiviteRefList` | `List<DocumentReference>? stringListToActiviteRefList(List<String>?)` | Convertit liste d'IDs en refs activités | aucun |

### Services hors périmètre présents dans lib/services/ (interdit par CLAUDE.md)

| Fichier | Classe | Description |
|---|---|---|
| `image_service.dart` | `ImageService` | Pick + compress + upload Firebase Storage |
| `rbac_service.dart` | `RbacService` | Singleton RBAC — hasRole, hasAnyRole, canPerform, validateRoleCombination |
| `connectivity_service.dart` | — | Non analysé en détail |
| `error_handler.dart` | — | Non analysé en détail |
| `offline_service.dart` | — | Accès Firestore générique |

### lib/models/role.dart (interdit par CLAUDE.md)

Contient : `Role` enum (8 rôles), `RoleParsing` extension, `incompatibleRoles` map, matrice complète de permissions, `hasRoleConflict()`, `permissionsForRoles()`.

### Analyse fonctions à créer

| Fonction demandée | Statut |
|---|---|
| `phoneToEmail` | **ABSENTE** — ni dans `custom_functions.dart` ni ailleurs |
| `hasAnyRole` | Présente dans `rbac_service.dart` (mais hors `custom_code/`) |
| `validateRoleCombination` | Présente dans `rbac_service.dart` (mais hors `custom_code/`) |
| `canPerform` | Présente dans `rbac_service.dart` (mais hors `custom_code/`) |

Les 3 dernières sont implémentées mais dans `lib/services/`. Si FlutterFlow doit les appeler, elles devront être réécrites comme custom functions dans `lib/custom_code/functions/` avec des signatures simples (String/List en entrée/sortie).

- **Niveau de confiance :** CERTAIN
- **Répondable depuis le code seul :** OUI
- **Action recommandée :** Créer `lib/custom_code/` et les custom functions manquantes. Priorité absolue : `phoneToEmail`.

---

## SYNTHÈSE FINALE

---

### A) À VÉRIFIER EN CONSOLE FIREBASE

1. **Collections existantes** → Firestore Console → onglet "Data" : lister toutes les collections racine. Vérifier si `users` (minuscule), `Parcelles` ET `parcelles`, `consommations_stock`, `USERS`, `Speculation` existent toutes ou seulement certaines. Copier la liste exacte des noms.

2. **Données dans `revenus`** → Firestore Console → collection `revenus` : vérifier si cette collection contient des données réelles. Elle est actuellement entièrement ouverte (write + delete sans auth).

3. **Providers Firebase Auth activés** → Firebase Console → Authentication → Sign-in method : vérifier quels providers sont activés (Email/Password, Phone, Google, etc.). Confirmer si Phone OTP est activé ou non.

4. **Règles Firestore déployées vs fichier commité** → Firebase Console → Firestore → Rules : comparer les règles actives en production avec `firebase/firestore.rules`. Le fichier commité peut ne pas être déployé.

5. **Règles Storage déployées** → Firebase Console → Storage → Rules : même vérification. Confirmer si les uploads vers `collaborateurs/photos/` fonctionnent ou non en production.

6. **Données utilisateurs** → Firestore → collection `USERS` : vérifier le format du champ `roles` (array de strings) et `typeCompte` (legacy) sur quelques documents. Confirmer si des documents ont `roles` non vide.

7. **Chemins Firebase Storage utilisés** → Firebase Console → Storage : lister les dossiers existants. Vérifier si des fichiers existent sous `collaborateurs/photos/` ou sous d'autres chemins non-`users/`.

---

### B) ACTIONS À RÉALISER (punch-list priorisée)

#### 🔴 BLOQUANT

1. **[FIREBASE]** Corriger `firestore.rules` : changer `allow write: if false` en `allow update: if request.auth != null` pour les collections actives. Sans ça, aucune mise à jour de document n'est possible (validation dépense, changement statut activité, etc.).

2. **[FIREBASE]** Corriger `firestore.rules` : remplacer `allow create: if true` par `allow create: if request.auth != null` pour toutes les collections sauf `invitations` (à décider selon le flux d'onboarding). Actuellement n'importe qui sans compte peut créer des documents.

3. **[FIREBASE]** Corriger `firestore.rules` : `revenus` a `allow read/write/create/delete: if true` — restreindre immédiatement.

4. **[FIREBASE]** Corriger `storage.rules` : ajouter les chemins manquants (ex. `collaborateurs/{allPaths=**}`, `depenses/{allPaths=**}`, `activites/{allPaths=**}`) avec `allow write: if request.auth != null`. Sans ça, les uploads photos collaborateurs et dépenses échouent silencieusement.

5. **[CLAUDE CODE]** Créer `lib/custom_code/functions/phone_to_email.dart` — fonction `phoneToEmail(String phone) → String email`. Normalisation stricte : supprimer espaces, préfixer `225` si absent, ajouter `@demeter-app.com`. Cas de test obligatoires (voir CLAUDE.md §5).

#### ⚠️ IMPORTANT

6. **[FLUTTERFLOW]** Arbitrer le doublon `Parcelles` vs `parcelles` : décider du nom canonique (probablement `Parcelles` avec majuscule, cohérent avec le schéma et les règles) puis corriger dans FlutterFlow l'action qui utilise `getDocRefFromID()`.

7. **[CLAUDE CODE]** Corriger `flutter_flow/custom_functions.dart:27` : `collection('parcelles')` → `collection('Parcelles')` pour aligner avec `parcelles_record.dart`.

8. **[FLUTTERFLOW]** Modifier les écrans `Login1` et `CreateAccount1` : remplacer le champ "Email" par un champ "Numéro de téléphone" + appel à `phoneToEmail()` avant `signInWithEmail` / `createAccountWithEmail`. Sinon la décision CLAUDE.md §5 reste sans effet.

9. **[FIREBASE]** Arbitrer USERS/users : vérifier en console si les deux collections existent. Décider du nom unique (conserver `USERS` car c'est ce que le code utilise).

10. **[FLUTTERFLOW / CLAUDE CODE]** Créer les custom functions `hasAnyRole(List<String> userRoles, List<String> requiredRoles) → bool` et `canPerform(List<String> userRoles, String action, String resource) → bool` dans `lib/custom_code/functions/` pour que FlutterFlow puisse les appeler depuis les conditions de visibilité.

#### ℹ️ NICE-TO-HAVE

11. **[FLUTTERFLOW]** Harmoniser les noms de champs tenant : `ref_exploitation` (Parcelles) / `exploitation_ref` (Activites, Depenses, Stocks) / `exploitationid` (Collaborateurs) → uniformiser en `exploitation_ref` dans les nouvelles collections. Ne pas migrer les données existantes sans accord.

12. **[FIREBASE]** Créer un `.firebaserc` pour lier le projet Firebase — il n'existe pas dans le repo, ce qui rend les déploiements `firebase deploy` impossibles depuis ce repo sans configuration manuelle.

13. **[CLAUDE CODE]** Évaluer si `lib/models/`, `lib/services/`, `lib/widgets/` (créés hors périmètre CLAUDE.md) sont référencés par des écrans FlutterFlow générés — si oui, ils doivent rester ; si non, ils risquent d'être supprimés par un prochain push FlutterFlow. À confirmer avec l'humain.
