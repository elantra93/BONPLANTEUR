# DEMETER

**DEMETER** est une application Flutter de gestion d'exploitation agricole conçue pour le marché ivoirien (Côte d'Ivoire). Le nom rend hommage à Déméter, déesse grecque de l'agriculture, des moissons et de la fertilité.

> « Le logiciel métier bâti pour nos champs »

L'application est servie en production sur **bonplanteur.net** (build Flutter Web) et distribuée en parallèle sous forme d'**APK Android** pour un usage terrain. Elle s'appuie sur **Firebase** (Authentification, Firestore, Storage, Cloud Functions) comme backend.

Le projet cible trois profils d'utilisateurs :

- **Entrepreneur** — propriétaire de l'exploitation, accès complet, valide les activités et les dépenses.
- **Chef d'équipe** — encadre le travail sur le terrain, prend les photos, soumet les dépenses, fait avancer les activités.
- **Ouvrier** — exécute les activités, consulte son planning et ses revenus.

La gestion des accès repose sur un système de rôles (RBAC) à 8 rôles combinables : `ADMIN`, `CHEF_EXPLOITATION`, `CHEF_PARCELLE`, `TECHNICIEN`, `OUVRIER`, `COMPTABLE`, `SIGNATAIRE_DEPENSES`, `LECTEUR`.

## Fonctionnalités principales

D'après le code présent dans `lib/` :

- **Authentification** par numéro de téléphone (connexion, vérification par code OTP, création de compte, mot de passe oublié), via Firebase Auth.
- **Tableau de bord** (`home/dashboard_page`) synthétisant l'activité de l'exploitation.
- **Gestion des exploitations** : liste, ajout, détail, modification (`champs/exploitations`).
- **Gestion des parcelles** : liste, ajout, détail, modification (`champs/parcelles`).
- **Gestion des activités agricoles** : liste, ajout, détail et suivi (`champs/activites`), avec workflow de statut (planifiée / faite / vérifiée / rejetée).
- **Trésor** (module financier) :
  - **Dépenses** : liste, ajout, détail, saisie rapide via bottom sheet (`tresor/depenses`).
  - **Stocks** : suivi des stocks et enregistrement des consommations (`tresor/stocks`).
  - **Matériel** : inventaire du matériel agricole — liste, ajout, détail, modification (`tresor/materiel`).
  - **Récoltes** : suivi des récoltes (`tresor/recolte`).
- **Personnel (RH)** : liste de l'équipe et ajout de collaborateurs (`personnel`).
- **Notifications** et **profil utilisateur** (`parameters`).
- **Contrôle d'accès par rôles (RBAC)** : matrice de permissions par rôle, gestion des combinaisons de rôles incompatibles (`models/role.dart`, `services/rbac_service.dart`).
- **Mode hors-ligne** : file d'attente locale (SQLite) des écritures Firestore en attente et cache de lecture, avec synchronisation automatique au retour du réseau (`services/offline_service.dart`, `services/connectivity_service.dart`), et bannière d'état hors-ligne dans l'interface.
- **Gestion des photos** liées aux activités, avec compression d'image (`services/image_service.dart`).
- **Cloud Functions Firebase** : nettoyage des données utilisateur à la suppression d'un compte (`firebase/functions`).

## Stack technique

- **Flutter** (Dart), cible Android + Web (build unique).
- **Firebase** : `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_performance`, Cloud Functions.
- **Provider** pour la gestion d'état.
- **go_router** pour la navigation.
- **table_calendar** pour les vues calendrier.
- **google_fonts** pour la typographie.
- **image_picker** / compression d'image pour la capture de photos terrain.
- **sqflite** pour la persistance locale (mode hors-ligne).
- **shared_preferences** pour l'état persisté de l'application.
- Base de code initialement générée avec **FlutterFlow**, puis enrichie manuellement (RBAC, services hors-ligne, gestion d'erreurs, tests).

## Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (canal stable, Dart ≥ 3.0.0 <4.0.0, cf. `pubspec.yaml`).
- Un projet **Firebase** configuré (Authentication, Firestore, Storage) et les fichiers de configuration correspondants :
  - `android/app/google-services.json` pour Android,
  - `ios/Runner/GoogleService-Info.plist` pour iOS (si applicable),
  - configuration Web générée via `flutterfire configure` pour la cible Web.
- [Firebase CLI](https://firebase.google.com/docs/cli) si vous devez déployer les règles Firestore/Storage ou les Cloud Functions.
- Android Studio / Xcode selon la plateforme cible pour la compilation mobile.

## Installation et lancement

```bash
# Cloner le dépôt
git clone https://github.com/elantra93/DEMETERCLAUDE.git
cd DEMETERCLAUDE

# Installer les dépendances Dart/Flutter
flutter pub get

# Lancer l'application (choisir un appareil/émulateur connecté)
flutter run

# Lancer spécifiquement sur le Web
flutter run -d chrome
```

### Builds de production

```bash
# Build Android (APK)
flutter build apk --release

# Build Web (servi ensuite via nginx, par ex. sur bonplanteur.net)
flutter build web --release
```

### Tests

```bash
flutter test
```

Des tests unitaires sont présents dans `test/` (rôles/RBAC, service hors-ligne, validateurs).

## Structure du projet

```
lib/
├── auth/                 # Intégration Firebase Auth (provider utilisateur, utilitaires)
├── authentification/     # Écrans : connexion, création de compte, OTP, mot de passe oublié
├── backend/
│   ├── firebase/         # Configuration Firebase
│   ├── firebase_storage/ # Accès au stockage Firebase
│   └── schema/           # Modèles de données Firestore (*_record.dart)
├── champs/
│   ├── activites/        # Liste, ajout, détail des activités
│   ├── exploitations/    # Liste, ajout, détail, modification des exploitations
│   └── parcelles/        # Liste, ajout, détail, modification des parcelles
├── components/           # Composants d'interface réutilisables
├── flutter_flow/         # Thème, navigation, utilitaires générés par FlutterFlow
├── home/
│   └── dashboard_page/   # Tableau de bord
├── models/               # Modèles applicatifs (ex. role.dart)
├── parameters/           # Profil utilisateur, notifications
├── personnel/            # Gestion de l'équipe (collaborateurs)
├── services/             # RBAC, connectivité, mode hors-ligne, images, gestion d'erreurs
├── tresor/
│   ├── depenses/         # Dépenses
│   ├── materiel/         # Matériel agricole
│   ├── recolte/          # Récoltes
│   ├── stocks/           # Stocks et consommations
│   └── tresor/           # Vue d'ensemble financière
├── utils/                # Fonctions utilitaires
├── widgets/               # Widgets partagés (ex. bannière hors-ligne)
├── app_state.dart        # État global de l'application
├── index.dart            # Export des pages / routage
└── main.dart             # Point d'entrée de l'application

firebase/
├── firestore.rules       # Règles de sécurité Firestore
├── firestore.indexes.json
├── storage.rules         # Règles de sécurité Storage
└── functions/            # Cloud Functions

test/                     # Tests unitaires (modèles, services, utilitaires)
```

## Licence

Projet propriétaire (`publish_to: none` dans `pubspec.yaml`). Tous droits réservés. Aucune licence open source n'est associée à ce dépôt à ce jour.
