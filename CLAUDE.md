# CLAUDE.md — Contexte projet DEMETER (à lire avant toute intervention)

> Ce fichier décrit le contexte de l'application et **les règles strictes** de
> ton intervention en tant que Claude Code. Il complète le PRD v3.0
> (`DEMETER_PRD_v3_MVP_FlutterFlow_09062026.md`), qui reste la référence canonique.
> En cas de doute, **demande avant d'agir** : ne reconstruis jamais l'architecture.

---

## 1. Ce qu'est DEMETER

Plateforme SaaS de gestion d'exploitation agricole (mobile-first). Elle couvre :
suivi agronomique, RH, contrôle des coûts, recommandations agricoles, comptabilité
et archivage de factures.

- **Frontend / environnement de dev** : **FlutterFlow** (éditeur visuel).
- **Backend** : **Firebase** déjà connecté — Firestore (base), Firebase Auth, Firebase Storage.
- **Repo** : https://github.com/elantra93/DEMETER1 (sauvegarde uniquement).

## 2. Décision stratégique en vigueur (MVP)

- On **reste dans FlutterFlow**. Pas de bascule en code Flutter écrit à la main.
- **Mono-tenant** : un seul tenant pour le MVP (isolation multi-tenant reportée).
- **Android d'abord**, iOS plus tard. Pas de store pour le premier test.
- Objectif : un MVP **potable et testable** par les 8 rôles, vite.

## 3. ⚠️ Périmètre STRICT de ton intervention (Claude Code)

FlutterFlow **régénère son code et écrase la branche `flutterflow` à chaque push**.
Tu ne peux donc PAS coder par-dessus le code généré.

**Tu interviens UNIQUEMENT dans `lib/custom_code/`** — la seule zone que FlutterFlow
n'écrase pas tant qu'on n'y touche pas depuis l'éditeur.

**Autorisé :**
- Écrire des **custom functions** Dart isolées (entrées/sorties simples : `String`,
  `List<String>`, `bool`). Pas d'accès à la base ni à l'auth.
- Écrire, **seulement si demandé explicitement**, une **custom action** d'upload image
  vers Firebase Storage (seul cas où l'accès à un service externe est permis).
- Lire le repo en mode diagnostic (grep, inventaire) **sans rien modifier**.

**Interdit :**
- Créer `lib/models/`, `lib/services/`, `lib/providers/`, un state management custom,
  une API REST, ou toute architecture parallèle.
- Modifier le code généré par FlutterFlow hors de `lib/custom_code/`.
- Toucher aux règles Firestore/Storage (ça se fait dans la console Firebase, par l'humain).
- Traiter « GitHub comme source unique de vérité ». La source de vérité est FlutterFlow.

## 4. Rôles (codes canoniques)

Le champ `roles` du profil utilisateur est un **array de chaînes**. Codes officiels :

| Rôle | Code |
|---|---|
| Admin | `ADMIN` |
| Chef exploitation | `CHEF_EXPLOITATION` |
| Chef parcelle | `CHEF_PARCELLE` |
| Technicien | `TECHNICIEN` |
| Ouvrier | `OUVRIER` |
| Comptable | `COMPTABLE` |
| Signataire dépenses | `SIGNATAIRE_DEPENSES` |
| Lecteur | `LECTEUR` |

**Permissions cumulatives** : un utilisateur peut cumuler plusieurs rôles ; les
permissions sont l'**union logique** de celles de ses rôles.

**Combinaisons INTERDITES** (à rejeter) :

| Combinaison interdite |
|---|
| `OUVRIER` + `ADMIN` |
| `OUVRIER` + `CHEF_EXPLOITATION` |
| `OUVRIER` + `SIGNATAIRE_DEPENSES` |
| `LECTEUR` + `COMPTABLE` |
| `LECTEUR` + `ADMIN` |

Responsabilités (pour construire la matrice de permissions) :
- **ADMIN** : tout (système, utilisateurs, config, tous modules).
- **CHEF_EXPLOITATION** : supervision complète, validation activités, vision financière complète.
- **CHEF_PARCELLE** : gestion parcelles, planification activités, suivi agronomique, RH de son équipe.
- **TECHNICIEN** : exécution/suivi activités, saisie données terrain, lecture recommandations.
- **OUVRIER** : exécution des tâches assignées, saisie basique (heures, quantités).
- **COMPTABLE** : saisie dépenses, attachement factures, consultation (pas de validation).
- **SIGNATAIRE_DEPENSES** : validation/rejet des dépenses saisies par le comptable.
- **LECTEUR** : lecture seule (rapports, tableaux de bord).

## 5. Authentification (décision prise)

Méthode : **email dérivé du téléphone**. L'utilisateur saisit téléphone + mot de passe ;
Firebase Auth utilise en coulisses un email fabriqué à partir du numéro.

- **Piège critique** : la normalisation du numéro doit être **strictement identique**
  à l'inscription et à la connexion, sinon deux emails différents → login impossible.
- Indicatif Côte d'Ivoire : `225`. Domaine fixe (ne jamais changer) : `@demeter-app.com`.
- OTP SMS **hors périmètre MVP**.

## 6. Modèle de données (résumé)

Entités principales : Users, Exploitations, Parcelles, Spéculations, Campagnes,
Parcours recommandé/réalisé, Activités, Employés, Intrants, Stock, Récoltes, Ventes,
Dépenses, Factures. Hiérarchie via `superieur_id`.

> ⚠️ **Chaos de nommage Firestore non encore arbitré** : doublons `USERS`/`users`,
> `Parcelles`/`parcelles`, `consommation_stock`/`consommations_stock`, `Speculation`
> racine vs sous-collection. **Ne figer aucun schéma** avant que l'humain ait confirmé
> les collections réellement utilisées (Phase 0 du plan d'action).

## 7. Conventions pour tes custom functions

- Fichiers dans `lib/custom_code/functions/` (et `lib/custom_code/actions/` pour la
  custom action image).
- Une fonction = une responsabilité. Pas d'effets de bord.
- Entrées/sorties simples et typées. Pas de `dynamic` quand on peut l'éviter.
- Code défensif sur les entrées nulles/vides (renvoyer un défaut sûr, pas d'exception non gérée).
- Commentaires en français, concis, expliquant le « pourquoi ».
- Fournis, pour chaque fonction, **3 à 5 cas de test manuels** (entrée → sortie attendue)
  dans le commentaire d'en-tête, puisque les tests automatisés sont reportés.
