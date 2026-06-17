# Analyse Complète — DEMETER V1.1

> **Projet :** DEMETER — SaaS de gestion d'exploitation agricole
> **Repo :** https://github.com/elantra93/DEMETER1
> **Date d'analyse :** 2026-06-17
> **Branche analysée :** `flutterflow` / `main`
> **Analyste :** Claude Code (claude-sonnet-4-6)

---

## 1. Description générale de l'application

DEMETER est une application mobile **SaaS de gestion d'exploitation agricole**, conçue pour le marché ivoirien (Côte d'Ivoire). Elle cible des acteurs agricoles de terrain (chefs d'exploitation, techniciens, ouvriers, comptables) et leur permet de piloter leur activité depuis un smartphone Android.

### Proposition de valeur

| Module | Fonction |
|--------|----------|
| **Exploitations & Parcelles** | Gérer les terres, leurs cultures (spéculations), leurs surfaces et leur statut |
| **Activités agronomiques** | Planifier, affecter, valider et suivre les tâches de terrain |
| **Personnel (RH)** | Enregistrer les collaborateurs, leurs contrats et salaires |
| **Trésor** | Saisir les dépenses, les faire valider, archiver les justificatifs |
| **Stocks** | Suivre les intrants (engrais, pesticides…), les consommations et les seuils d'alerte |
| **Récoltes** | Enregistrer les lots récoltés par parcelle |
| **Matériel** | Inventorier les équipements agricoles, leur valeur et leur état |
| **Notifications** | Alertes internes sur les actions à valider ou les stocks bas |

### Contexte technique

- **Frontend** : Flutter (généré par FlutterFlow, éditeur no-code visuel)
- **Backend** : Firebase (Firestore + Auth + Storage)
- **Cible initiale** : Android only (MVP)
- **Authentification** : email dérivé du numéro de téléphone ivoirien (`225XXXXXXXX@demeter-app.com`) + mot de passe
- **Gestion des rôles** : 8 rôles définis (`ADMIN`, `CHEF_EXPLOITATION`, `CHEF_PARCELLE`, `TECHNICIEN`, `OUVRIER`, `COMPTABLE`, `SIGNATAIRE_DEPENSES`, `LECTEUR`)

---

## 2. Stack technique

| Composant | Technologie | Version |
|-----------|------------|---------|
| Framework UI | Flutter (FlutterFlow) | SDK ≥ 3.0 |
| Base de données | Cloud Firestore | `cloud_firestore 5.6.9` |
| Authentification | Firebase Auth | `firebase_auth 5.6.0` |
| Stockage fichiers | Firebase Storage | `firebase_storage 12.4.7` |
| Navigation | go_router | `12.1.3` |
| État global | Provider | `6.1.5` |
| Cache images | cached_network_image | `3.4.1` |
| Offline (non utilisé) | sqflite | `2.3.3+1` |
| Calendrier | table_calendar | `3.2.0` |
| Géolocalisation | flutter_google_places | git fork |
| Auth Apple/Google | sign_in_with_apple, google_sign_in | présents |

---

## 3. Structure du projet

```
lib/
├── auth/                        # Wrappers Firebase Auth (6 fichiers)
│   └── firebase_auth/           # Email, Google, Apple, Anonymous, GitHub, OTP
├── authentification/            # 4 écrans d'accès
│   ├── create_account1/         # Inscription
│   ├── login1/                  # Connexion email
│   ├── login_phone_page/        # Connexion téléphone
│   ├── motde_passe_oublie_email/ # Mot de passe oublié
│   └── o_t_p_verification_page/ # Vérification OTP
├── backend/
│   ├── firebase/                # Configuration Firebase
│   ├── firebase_storage/        # Helper upload
│   └── schema/                  # 14 modèles Firestore
├── champs/
│   ├── activites/               # 4 écrans activités
│   ├── exploitations/           # 4 écrans exploitations
│   └── parcelles/               # 4 écrans parcelles
├── components/                  # 10 widgets partagés
├── flutter_flow/                # Utilitaires FlutterFlow (thème, nav, util)
├── home/                        # Dashboard
├── models/                      # role.dart (enum RBAC)
├── parameters/                  # Profil, notifications
│   └── unused/                  # 2 écrans morts (non utilisés)
├── personnel/                   # RH / équipe
├── services/                    # 5 services (RBAC, offline, image, error, connectivity)
├── tresor/
│   ├── depenses/                # 4 écrans dépenses
│   ├── materiel/                # 4 écrans matériel
│   ├── recolte/                 # 1 écran récoltes
│   ├── stocks/                  # 2 écrans stocks
│   └── tresor/                  # Tableau de bord trésor
├── utils/                       # validators.dart
└── widgets/                     # Widgets personnalisés (offline_banner, require_permission…)
```

---

## 4. Inventaire des pages et formulaires

### 4.1 Module Authentification

| Page | Fichier | Formulaire / Champs |
|------|---------|---------------------|
| **Inscription** | `authentification/create_account1/` | Nom, téléphone, mot de passe |
| **Connexion email** | `authentification/login1/` | Email, mot de passe |
| **Connexion téléphone** | `authentification/login_phone_page/` | Numéro de téléphone (masqué `225XXXXXXXXX`) |
| **OTP Vérification** | `authentification/o_t_p_verification_page/` | Code à 6 chiffres (param: `phonenumber`) |
| **Mot de passe oublié** | `authentification/motde_passe_oublie_email/` | Adresse email |

### 4.2 Module Home

| Page | Fichier | Contenu |
|------|---------|---------|
| **Dashboard** | `home/dashboard_page/` | Vue synthétique (KPIs, raccourcis) |

### 4.3 Module Exploitations

| Page | Fichier | Formulaire / Champs |
|------|---------|---------------------|
| **Mes exploitations** | `champs/exploitations/mes_exploitations/` | Liste des exploitations de l'utilisateur |
| **Détail exploitation** | `champs/exploitations/detail_exploitation_page/` | Affichage complet (name, localite, gps, surfaces) |
| **Ajouter exploitation** | `champs/exploitations/ajouter_exploitation_page/` | Nom, localité, coordonnées GPS, surface totale, superficie exploitée, notes |
| **Modifier exploitation** | `champs/exploitations/modifier_exploitation/` | Mêmes champs, param: `exploitationid` |

### 4.4 Module Parcelles

| Page | Fichier | Formulaire / Champs |
|------|---------|---------------------|
| **Liste parcelles** | `champs/parcelles/liste_parcelles/` | Liste filtrée par exploitation, param: `exploitationid` |
| **Détail parcelle** | `champs/parcelles/detail_parcelle_page/` | Toutes infos parcelle + métriques (rendement, budget, dépenses) |
| **Ajouter parcelle** | `champs/parcelles/ajouter_parcelle_page/` | Nom, superficie, spéculation, type (plein ciel / hors-sol), date semis, date récolte prévue, budget, rendement attendu, référence collaborateur responsable |
| **Modifier parcelle** | `champs/parcelles/modifier_parcelle/` | Mêmes champs, params: `exploitationId` + `parcelleID` |

### 4.5 Module Activités

| Page | Fichier | Formulaire / Champs |
|------|---------|---------------------|
| **Dashboard activités** | `champs/activites/activitydashboard/` | Vue calendrier + KPIs statuts |
| **Liste activités** | `champs/activites/liste_activites_page/` | Liste avec filtres par statut |
| **Ajouter activité** | `champs/activites/ajouter_activite_page/` | Libellé, type, description, exploitation, parcelle, date prévue, responsable (inCharge), travailleurs (NomsDesTravailleurs), photos illustration |
| **Détail activité** | `champs/activites/detail_activite_page/` | Affichage complet + zone commentaires + actions valider/rejeter, param: `activiteref` |

### 4.6 Module Personnel (RH)

| Page | Fichier | Formulaire / Champs |
|------|---------|---------------------|
| **Liste équipe** | `personnel/liste_team/` | Liste collaborateurs de l'exploitation, param: `exploitationid` |
| **Ajouter collaborateur** | `personnel/ajouter_collaborateur_page/` | Nom, prénoms, date de naissance, date début, salaire mensuel, contact, photo CNI, photo collaborateur, référence exploitation |

### 4.7 Module Trésor

#### Sous-module Dépenses

| Page | Fichier | Formulaire / Champs |
|------|---------|---------------------|
| **Trésor (hub)** | `tresor/tresor/` | Tableau de bord financier (dépenses, revenus, récoltes) |
| **Liste dépenses** | `tresor/depenses/liste_depenses/` | Liste avec filtres |
| **Ajouter dépense** | `tresor/depenses/ajouter_depense_page/` | Libellé, montant, catégorie, date, exploitation, parcelle, commentaire, justificatif (image), activités concernées |
| **Détail dépense** | `tresor/depenses/details_depense/` | Affichage + statut validation (approuver / rejeter), param: `depenseid` (Document) |
| **Saisie rapide dépense** | `tresor/depenses/bottom_sheet_depense_rapid/` | BottomSheet : saisie rapide (montant, catégorie, exploitation) |

#### Sous-module Stocks

| Page | Fichier | Formulaire / Champs |
|------|---------|---------------------|
| **Stocks** | `tresor/stocks/stocks_page/` | Liste des intrants par exploitation, param: `exploitationid` |
| **Ajouter consommation** | `tresor/stocks/ajouter_consommation_stock_page/` | Référence stock, quantité consommée, param: `exploitationid` |

#### Sous-module Récoltes

| Page | Fichier | Formulaire / Champs |
|------|---------|---------------------|
| **Récoltes** | `tresor/recolte/recoltes_page/` | Liste des lots récoltés, params: `exploitationId` + `parcelleid` |

#### Sous-module Matériel

| Page | Fichier | Formulaire / Champs |
|------|---------|---------------------|
| **Liste matériel** | `tresor/materiel/liste_materiel/` | Inventaire des équipements |
| **Détail matériel** | `tresor/materiel/detail_materiel/` | Fiche complète, param: `referenceMateriel` |
| **Ajouter matériel** | `tresor/materiel/ajouter_materiel/` | Nom, type, date acquisition, valeur achat, durée de vie, valeur vénale, quantité, exploitation, photos, statut actif |
| **Modifier matériel** | `tresor/materiel/modifier_materiel/` | Mêmes champs, param: `materielid` |

### 4.8 Module Paramètres

| Page | Fichier | Contenu |
|------|---------|---------|
| **Profil** | `parameters/profil_page/` | Infos utilisateur, rôles, gestion du compte |
| **Notifications** | `parameters/notifications_page/` | Centre de notifications Firebase |

### 4.9 Composants partagés

| Composant | Fichier | Rôle |
|-----------|---------|------|
| `Imagepicker1Widget` | `components/imagepicker1_widget.dart` | Upload image vers Firebase Storage |
| `CommentairesWidget` | `components/commentaires_widget.dart` | Zone de commentaires (activités) |
| `DatePickerTexfieldWidget` | `components/date_picker_texfield_widget.dart` | Champ date avec sélecteur |
| `SelecteurExploitationWidget` | `components/selecteur_exploitation_widget.dart` | Dropdown exploitation |
| `SelectExploitationDepenseWidget` | `components/select_exploitation_depense_widget.dart` | Sélecteur exploitation pour dépenses |
| `SelectExploitationRecolteWidget` | `components/select_exploitation_recolte_widget.dart` | Sélecteur exploitation pour récoltes |
| `ActionSelectParcelleWidget` | `components/action_select_parcelle_widget.dart` | Sélecteur parcelle |
| `StatutActiviteCodeCouleurWidget` | `components/statut_activite_code_couleur_widget.dart` | Badge statut coloré |
| `BottomSheetToWidget` | `components/bottom_sheet_to_widget.dart` | BottomSheet générique |
| `ConfirmationCreationParcelleWidget` | `components/confirmation_creation_parcelle_widget.dart` | Confirmation après création parcelle |

---

## 5. Modèle de données Firestore

### 5.1 Collections et champs principaux

#### `USERS` (utilisateurs connectés)
| Champ | Type | Description |
|-------|------|-------------|
| `email` | String | Email dérivé du téléphone |
| `display_name` | String | Nom affiché |
| `photo_url` | String | URL photo de profil |
| `uid` | String | Firebase Auth UID |
| `phone_number` | String | Numéro de téléphone brut |
| `roles` | List\<String\> | Rôles RBAC (ex. `["CHEF_EXPLOITATION","COMPTABLE"]`) |
| `is_active` | bool | Compte actif/suspendu |
| `Profil` | String | Description du profil |
| `type_compte` | String | Ancien champ rôle (rétrocompatibilité) |
| `created_time` | Timestamp | Date création |
| `last_login` | Timestamp | Dernière connexion |

#### `exploitations`
| Champ | Type | Description |
|-------|------|-------------|
| `name` | String | Nom de l'exploitation |
| `owner_ref` | DocumentReference → USERS | Propriétaire |
| `gps` | LatLng | Coordonnées GPS |
| `surface_totale` | double | Surface totale (ha) |
| `superficieExploite` | double | Surface effectivement exploitée |
| `localite` | String | Localité / village |
| `notes` | String | Notes libres |
| `created_time` | Timestamp | Date création |

#### `Parcelles` _(majuscule — incohérence nommage)_
| Champ | Type | Description |
|-------|------|-------------|
| `nomparcelle` | String | Nom de la parcelle |
| `superficieparcelle` | double | Superficie (ha) |
| `speculationparcelle` | String | Culture en cours (ex. "Cacao") |
| `PleinCiel` | bool | Type plein air |
| `HorsSol` | bool | Type hors-sol |
| `DateCreation` | Timestamp | Date création |
| `DateSemis` | Timestamp | Date du semis |
| `DateRecolte` | Timestamp | Date de récolte prévue |
| `DateModification` | Timestamp | Dernière modification |
| `DepensesParcelle` | double | Total dépenses imputées |
| `RendementAttendu` | double | Rendement cible |
| `RendementRealise` | double | Rendement effectif |
| `BudgetParcelle` | int | Budget alloué |
| `RevenuParcelle` | double | Revenu réalisé |
| `ParcelleActive` | bool | Parcelle en activité |
| `ref_exploitation` | DocumentReference → exploitations | Exploitation parente |
| `collaborateur_ref` | DocumentReference → collaborateurs | Chef de parcelle |

#### `activites`
| Champ | Type | Description |
|-------|------|-------------|
| `libelle_activite` | String | Titre de l'activité |
| `type` | String | Type (Labour, Semis, Traitement…) |
| `description` | String | Description détaillée |
| `statut` | String | `brouillon / planifie / en_cours / termine / valide / rejete` |
| `date_prevue` | Timestamp | Date planifiée |
| `date_execution` | Timestamp | Date de réalisation effective |
| `date_creation` | Timestamp | Date de création |
| `exploitation_ref` | DocumentReference → exploitations | Exploitation concernée |
| `parcelle_ref` | DocumentReference → Parcelles | Parcelle concernée |
| `created_by` | DocumentReference → USERS | Créateur |
| `inCharge` | DocumentReference → USERS | Responsable |
| `approvedby` | DocumentReference → USERS | Validateur |
| `approvedDate` | Timestamp | Date de validation |
| `RejectedBy` | DocumentReference → USERS | Rejeteur |
| `rejectedDate` | Timestamp | Date de rejet |
| `listecommentaire` | List\<String\> | Commentaires |
| `redacteurcommentaire` | List\<String\> | Auteurs des commentaires |
| `photoillustration` | List\<String\> | URLs photos illustratives |
| `NomsDesTravailleurs` | List\<String\> | Noms des travailleurs affectés |
| `NomExploitation` | String | Dénormalisation : nom exploitation |
| `NomParcelle` | String | Dénormalisation : nom parcelle |

#### `depenses`
| Champ | Type | Description |
|-------|------|-------------|
| `libelleDepense` | String | Libellé |
| `montant` | double | Montant (FCFA) |
| `categorie` | String | Catégorie de dépense |
| `date` | Timestamp | Date de la dépense |
| `statut` | String | `en_attente / approuve / rejete` |
| `exploitation_ref` | DocumentReference → exploitations | Exploitation |
| `parcelle_ref` | DocumentReference → Parcelles | Parcelle (optionnel) |
| `valide_par` | DocumentReference → USERS | Validateur |
| `Validateur` | String | Dénormalisation : nom validateur |
| `affectee_a` | String | Affectation libre |
| `LibelleParcelle` | String | Dénormalisation : nom parcelle |
| `CommentaireDepense` | String | Commentaire |
| `justificatif_url` | String | URL unique justificatif _(doublon)_ |
| `Justif_depense` | List\<String\> | Liste URLs justificatifs _(doublon)_ |
| `autorisation` | String | Code d'autorisation |
| `activitesconcern` | List\<DocumentReference\> | Activités liées |

#### `collaborateurs` (employés de terrain)
| Champ | Type | Description |
|-------|------|-------------|
| `workerId` | String | ID métier |
| `nom` | String | Nom de famille |
| `prenoms` | String | Prénoms |
| `datedenaissance` | Timestamp | Date de naissance |
| `datededebut` | Timestamp | Date d'embauche |
| `salairemensuel` | int | Salaire mensuel (FCFA) |
| `contact` | String | Téléphone |
| `photoidcard` | String | URL photo CNI |
| `photoworker` | String | URL photo employé |
| `exploitationid` | DocumentReference → exploitations | Exploitation |

#### `stocks`
| Champ | Type | Description |
|-------|------|-------------|
| `produit` | String | Nom du produit |
| `categorie` | String | Catégorie (engrais, pesticide…) |
| `quantite` | double | Quantité disponible |
| `unite` | String | Unité (kg, L, sac…) |
| `seuil_alerte` | double | Seuil déclenchant une alerte |
| `Cout_unitaire` | double | Coût à l'unité |
| `Cout_total` | int | Coût total stock |
| `exploitation_ref` | DocumentReference → exploitations | Exploitation |

#### `consommation_stock`
_(schéma déduit — pas de fichier record direct trouvé dans le code analysé)_
Lié à `stocks` et `activites` via les références exploitation.

#### `recoltes`
| Champ | Type | Description |
|-------|------|-------------|
| `quantite` | double | Quantité récoltée |
| `unite` | String | Unité |
| `date_recolte` | Timestamp | Date de récolte |
| `lot_recolte` | String | Numéro/libellé de lot |
| `parcelle_ref` | DocumentReference → Parcelles | Parcelle source |

#### `Materiels` _(majuscule)_
| Champ | Type | Description |
|-------|------|-------------|
| `NomMateriel` | String | Nom de l'équipement |
| `Type` | String | Catégorie (tracteur, pompe…) |
| `DateAcquisition` | Timestamp | Date d'acquisition |
| `ValeurAchat` | int | Prix d'achat |
| `DureeDeVie` | int | Durée de vie estimée (ans) |
| `ValeurVenale` | int | Valeur actuelle estimée |
| `Quantity` | int | Quantité |
| `Active` | bool | En service ou non |
| `PhotosMateriel` | List\<String\> | URLs photos |
| `ExploitationId` | DocumentReference → exploitations | Exploitation |
| `Exploitation` | String | Dénormalisation : nom exploitation |

#### `membres_exploitation` (table de jointure User ↔ Exploitation)
| Champ | Type | Description |
|-------|------|-------------|
| `user_ref` | DocumentReference → USERS | Utilisateur membre |
| `exploitation_ref` | DocumentReference → exploitations | Exploitation |
| `role` | String | Rôle dans cette exploitation _(String singulier — incohérent avec USERS.roles)_ |
| `habilitation_depenses` | bool | Peut saisir des dépenses |
| `habilitation_recoltes` | bool | Peut saisir des récoltes |
| `date_ajout` | Timestamp | Date d'adhésion |

#### `invitations`
| Champ | Type | Description |
|-------|------|-------------|
| `telephone` | String | Téléphone invité |
| `exploitation_ref` | DocumentReference → exploitations | Exploitation concernée |
| `code_invitation` | String | Code format `DEM-XXXXXX` |
| `statut` | String | `en_attente / acceptee / expiree` |
| `invited_by` | DocumentReference → USERS | Invitant |
| `date_envoi` | Timestamp | Date d'envoi |
| `date_expiration` | Timestamp | Date d'expiration |

#### `notifications`
| Champ | Type | Description |
|-------|------|-------------|
| _(schéma non extrait)_ | — | Alertes système et métier |

#### `revenus`
| Champ | Type | Description |
|-------|------|-------------|
| _(schéma non extrait)_ | — | Revenus et ventes |

---

## 6. Diagramme des relations

```
USERS (1) ─────────────────────────────────── owner_ref ──► exploitations (N)
  │                                                              │
  │  (via membres_exploitation)                                  │
  └──────── user_ref ──► membres_exploitation ◄── exploitation_ref ┘
                              │
                              └── role (String) : CHEF_PARCELLE, OUVRIER…

exploitations (1) ──── ref_exploitation ──► Parcelles (N)
exploitations (1) ──── exploitation_ref ──► activites (N)
exploitations (1) ──── exploitation_ref ──► depenses (N)
exploitations (1) ──── exploitation_ref ──► stocks (N)
exploitations (1) ──── exploitationid ─────► collaborateurs (N)
exploitations (1) ──── ExploitationId ──────► Materiels (N)
exploitations (1) ──── exploitation_ref ──► invitations (N)

Parcelles (1) ──── parcelle_ref ──────────► activites (N)
Parcelles (1) ──── parcelle_ref ──────────► depenses (N)
Parcelles (1) ──── parcelle_ref ──────────► recoltes (N)
Parcelles (1) ──── collaborateur_ref ──────► collaborateurs (1)

activites ◄──── activitesconcern (List<Ref>) ──── depenses

USERS ──── created_by / inCharge / approvedby / RejectedBy ──► activites
USERS ──── valide_par ──────────────────────────────────────► depenses
USERS ──── invited_by ──────────────────────────────────────► invitations
```

---

## 7. Parcours client par rôle

### 7.1 Administrateur (`ADMIN`)

```
Inscription / Connexion
  └─► Dashboard
        ├─► Créer Exploitation → Ajouter Parcelles → Configurer Stocks
        ├─► Gérer utilisateurs → Inviter collaborateurs (code DEM-XXXXXX)
        ├─► Superviser toutes les activités (valider / rejeter)
        ├─► Approuver toutes les dépenses
        └─► Consulter rapports & KPIs
```

### 7.2 Chef d'exploitation (`CHEF_EXPLOITATION`)

```
Connexion
  └─► Dashboard (vue complète exploitation)
        ├─► Exploitations → Parcelles → Ajouter/Modifier
        ├─► Activités → Planifier → Affecter techniciens
        │       └─► Valider activités terminées
        ├─► Trésor → Dépenses → Valider/Rejeter dépenses du comptable
        └─► Personnel → Voir équipe → Ajouter collaborateurs
```

### 7.3 Chef de parcelle (`CHEF_PARCELLE`)

```
Connexion
  └─► Dashboard (vue parcelles sous sa responsabilité)
        ├─► Parcelles → Détail → Modifier (budget, rendement)
        ├─► Activités → Créer → Affecter techniciens
        │       └─► Valider activités de son équipe
        └─► Personnel → Son équipe uniquement
```

### 7.4 Technicien (`TECHNICIEN`)

```
Connexion
  └─► Activités → Liste (filtrée : activités dont il est responsable)
        ├─► Détail activité → Ajouter commentaire → Uploader photo
        └─► Saisir date d'exécution → Changer statut → "Terminé"
```

### 7.5 Ouvrier (`OUVRIER`)

```
Connexion
  └─► Activités → Liste (tâches assignées)
        └─► Saisir avancement basique (commentaire, photos)
```

### 7.6 Comptable (`COMPTABLE`)

```
Connexion
  └─► Trésor
        ├─► Dépenses → Ajouter dépense → Joindre justificatif
        └─► Liste dépenses (lecture + saisie, pas de validation)
```

### 7.7 Signataire des dépenses (`SIGNATAIRE_DEPENSES`)

```
Connexion
  └─► Trésor → Dépenses en attente
        └─► Détail dépense → Valider ou Rejeter (avec commentaire)
```

### 7.8 Lecteur (`LECTEUR`)

```
Connexion
  └─► Dashboard → Toutes pages en lecture seule
        └─► Aucune action de création/modification
```

---

## 8. Forces de l'application

### Architecture et fondations

| Force | Détail |
|-------|--------|
| **Schéma RBAC correct à la source** | `USERS.roles: List<String>` bien défini — prêt pour les 8 rôles |
| **Navigation complète** | `go_router` configuré, 30+ routes nommées, paramètres typés |
| **Modèle de données complet** | 14 collections couvrant toute la chaîne agricole (de la parcelle à la vente) |
| **Workflow de validation** | Champs `approvedby`/`RejectedBy`/`statut` sur activités ET dépenses — circuit de validation structuré |
| **Système d'invitation** | `generateInvitationCode()` + collection `invitations` avec code `DEM-XXXXXX`, date d'expiration |
| **Design tokens** | `FFSpacing`, `FFRadius`, `FFShadows` dans `flutter_flow_theme.dart` — base réutilisable |
| **Dépendances utiles présentes** | `sqflite`, `image_picker`, `cached_network_image`, `firebase_storage` déjà dans pubspec |
| **Service RBAC structuré** | `RbacService` + `role.dart` enum écrits et fonctionnels (même si non branchés sur les écrans) |
| **Dénormalisation maîtrisée** | `NomExploitation`, `NomParcelle` sur `activites` évitent les jointures coûteuses |
| **Gestion multi-images** | `photoillustration: List<String>` sur activités, `PhotosMateriel: List<String>` sur matériel |

### Fonctionnalités métier

| Force | Détail |
|-------|--------|
| **Couverture fonctionnelle** | Toute la chaîne de valeur est couverte : foncier → agronomie → RH → finance → logistique |
| **Traçabilité complète** | Chaque action clé (création, validation, rejet) est horodatée et attribuée à un utilisateur |
| **Spéculations agricoles** | Champ `speculationparcelle` couplé à la collection `Speculation` pour les cultures ivoiriennes |
| **Gestion de la trésorerie** | Module trésor couvrant dépenses, récoltes, revenus, stocks et matériel |
| **Saisie rapide dépense** | `BottomSheetDepenseRapid` pour une saisie terrain accélérée |
| **Commentaires collaboratifs** | `CommentairesWidget` réutilisable sur les activités |

---

## 9. Faiblesses et risques

### Sécurité (CRITIQUE — à corriger avant tout déploiement)

| Problème | Gravité | Localisation |
|----------|---------|-------------|
| **Toutes les routes sont non protégées** — `requireAuth` est absent sur la majorité des routes : tout utilisateur non connecté peut accéder à n'importe quel écran | 🔴 CRITIQUE | `lib/flutter_flow/nav/nav.dart` |
| **Zéro contrôle de rôle dans les écrans** — Le `RbacService` existe mais n'est jamais appelé dans les pages pour masquer/bloquer des actions | 🔴 CRITIQUE | Tous les fichiers `*_widget.dart` |
| **Règles Firestore trop permissives** — `allow create: if true` sur TOUTES les collections sauf `USERS`. N'importe qui peut écrire | 🔴 CRITIQUE | `firebase/firestore.rules` |
| **Pas d'isolation des données** — Aucun champ `tenant_id` ou `owner_uid` dans les collections. Un utilisateur peut potentiellement lire les données d'une autre exploitation | 🔴 CRITIQUE | Tous les schémas |
| **`membres_exploitation.role` est un String singulier** — Incohérent avec `USERS.roles` (liste). Le système de membership n'est pas aligné avec le PRD multi-rôles | 🔴 CRITIQUE | `backend/schema/membres_exploitation_record.dart:30` |

### Données et modèle (MAJEUR)

| Problème | Gravité | Localisation |
|----------|---------|-------------|
| **Chaos de nommage Firestore** — Mélange de conventions : `USERS` (majuscules), `exploitations` (minuscules), `Parcelles` (PascalCase), `Materiels` (PascalCase), champs FR (`nomparcelle`) et EN (`approvedby`, `RejectedBy`) | 🟠 MAJEUR | Tous les schemas |
| **Double stockage justificatif dépenses** — `justificatif_url: String` ET `Justif_depense: List<String>` coexistent. Lequel est la source de vérité ? | 🟠 MAJEUR | `depenses_record.dart` |
| **`getDocRefFromID` pointe vers `parcelles` (minuscule)** — La collection s'appelle `Parcelles` (majuscule) : les références seront invalides | 🟠 MAJEUR | `flutter_flow/custom_functions.dart:27` |
| **Champ `consommation_stock` / `consommations_stock`** — Nom de collection non arbitré, risque de doublons en production | 🟠 MAJEUR | CLAUDE.md (note) |
| **`Speculation` en collection racine ET en champ String** — Double représentation incohérente | 🟠 MAJEUR | `parcelles_record.dart:speculationparcelle` |

### Expérience utilisateur (MAJEUR)

| Problème | Gravité | Localisation |
|----------|---------|-------------|
| **Couleurs par défaut FlutterFlow** — `primary = 0xFF4B39EF` (violet) inadapté à une app agricole. Aucun vert, aucune couleur terre | 🟠 MAJEUR | `flutter_flow_theme.dart:151-170` |
| **Messages d'erreur en anglais** — `'Uploading file...'`, `'Failed to upload data'`, `'Success!'` dans une app 100% française | 🟠 MAJEUR | `components/imagepicker1_widget.dart` |
| **Dark mode non personnalisé** — `DarkModeTheme.primary` identique au light mode | 🟡 MODÉRÉ | `flutter_flow_theme.dart` |
| **Pas de pagination** — StreamBuilders directs sur les listes. Dès 100+ documents, l'app ralentira | 🟠 MAJEUR | Toutes les pages liste |

### Fonctionnalités manquantes (MAJEUR)

| Problème | Gravité | Localisation |
|----------|---------|-------------|
| **Mode offline absent** — `sqflite` importé mais jamais utilisé. En Côte d'Ivoire, la connectivité terrain est intermittente | 🟠 MAJEUR | `lib/services/offline_service.dart` (vide) |
| **Caméra non fonctionnelle** — L'icône montre `Icons.camera_alt_outlined` mais le code utilise uniquement `MediaSource.photoGallery` | 🟠 MAJEUR | `components/imagepicker1_widget.dart:85-140` |
| **Pas de compression d'images** — Upload brut vers Firebase Storage (risque de quota et lenteur réseau) | 🟠 MAJEUR | `backend/firebase_storage/storage.dart` |
| **Validation formulaires quasi-absente** — Montants négatifs possibles, téléphones mal formatés acceptés | 🟠 MAJEUR | `ajouter_depense_page_widget.dart`, `login_phone_page_widget.dart` |

### Dette technique (MODÉRÉ)

| Problème | Gravité | Localisation |
|----------|---------|-------------|
| **Dossier `parameters/unused/`** — 2 écrans morts (`select_exploitation_activities_details`, `select_exploitation_new_activity`) | 🟡 MODÉRÉ | `lib/parameters/unused/` |
| **Couverture de tests = 0%** — Un seul smoke test vide | 🟡 MODÉRÉ | `test/widget_test.dart` |
| **`useMaterial3: false`** — Non standard pour 2024+ | 🟡 MODÉRÉ | `lib/main.dart:128` |
| **`_safeInit` avale les exceptions silencieusement** | 🟡 MODÉRÉ | `lib/app_state.dart` |
| **Pas de widgets réutilisables** — Chaque écran recrée ses boutons et ses champs inline | 🟡 MODÉRÉ | Tous les `*_widget.dart` |
| **`dropdown_button2` et `flutter_google_places` depuis des forks git** — Risque de stabilité et de mise à jour | 🟡 MODÉRÉ | `pubspec.yaml` |

---

## 10. Tableau de priorisation

| Priorité | Problème | Effort estimé | Impact |
|----------|----------|---------------|--------|
| 🔴 P0.1 | Sécuriser routes (`requireAuth = true`) | 1h | Bloquant déploiement |
| 🔴 P0.2 | Règles Firestore Security Rules | 2h | Bloquant déploiement |
| 🔴 P0.3 | Brancher RBAC dans les écrans (`RbacService`) | 3j | Bloquant fonctionnel |
| 🔴 P0.4 | Ajouter `tenant_id` / `owner_uid` sur les collections clés | 2j | Isolation données |
| 🟠 P1.1 | Corriger `getDocRefFromID` → `Parcelles` (majuscule) | 30min | Bug silencieux |
| 🟠 P1.2 | Arbitrer nommage collections Firestore (figer le schéma) | 1j | Cohérence data |
| 🟠 P1.3 | Refactorer `Imagepicker1Widget` (caméra + compression + callback) | 1j | UX terrain |
| 🟠 P1.4 | Internationaliser les messages d'erreur (français) | 2h | UX |
| 🟠 P1.5 | Redéfinir palette couleurs agricoles dans le thème | 4h | Branding |
| 🟠 P1.6 | Implémenter mode offline (sqflite + sync queue) | 1 semaine | Utilisabilité terrain |
| 🟡 P2.1 | Pagination des listes | 2j | Performance |
| 🟡 P2.2 | Validation complète des formulaires | 3j | Qualité données |
| 🟡 P2.3 | Supprimer les écrans morts (`unused/`) | 30min | Propreté |
| 🟡 P2.4 | Tests unitaires sur la logique métier RBAC | 2j | Fiabilité |

---

## 11. Résumé exécutif

DEMETER V1.1 est un **squelette fonctionnel avancé** : la navigation est complète, les 14 modèles Firestore couvrent toute la chaîne agricole, le circuit de validation (activités et dépenses) est structuré dans les données, et le service RBAC est écrit mais non branché.

**Ce qui bloque le déploiement :** Les 4 problèmes de sécurité (routes non protégées, règles Firestore open, RBAC non appliqué, pas d'isolation des données) sont des risques réels qui doivent être traités avant toute mise entre les mains d'utilisateurs réels.

**Ce qui est solide :** La stack Firebase + FlutterFlow + go_router est bien choisie pour le contexte (équipe mobile-first, marché ivoirien, rapidité de développement). Le schéma `USERS.roles: List<String>` et le service `RbacService` fournissent une base correcte pour l'RBAC.

**Estimation pour atteindre le MVP testable :** 4 à 5 semaines de travail ciblé, en commençant par les P0.

---

*Document généré par analyse statique du code source (branche `flutterflow` / `main`) — ne reflète pas les éventuelles modifications postérieures à la date d'analyse.*
