# CLAUDE.md — DEMETER

> Fichier de contexte canonique pour la construction de l'application.
> **À lire en entier au début de chaque session.** Ne jamais s'écarter des règles marquées 🔒.

---

## 1. Le projet

**DEMETER** — SaaS de gestion d'exploitation agricole pour le marché ivoirien (Côte d'Ivoire).
Nom en hommage à **Déméter**, déesse grecque de l'agriculture, des moissons et de la fertilité.
Tagline officiel : **« Le logiciel métier bâti pour nos champs »**.

Reconstruction **from-scratch** d'une ancienne app FlutterFlow (`github.com/elantra93/DEMETER1`).
On ne reprend ni le code ni le style FlutterFlow. On réutilise le **même projet Firebase**
(Firestore + Auth + Storage, partagé avec la prod) et le **modèle de données existant**, enrichi (voir §4).

- Nouveau dépôt : `github.com/elantra93/DEMETERCLAUDE`
- Cibles : **APK Android** (terrain) + **Flutter Web** (bureau), code unique.
- Hébergement : **VPS Hostinger** (nginx sert le build web + certbot SSL).

### Stack (figée)
Flutter (Dart) · Material 3 · Riverpod · go_router · freezed + json_serializable · Firebase
(core/firestore/auth/storage) · table_calendar · google_fonts (Poppins + Inter) · Drift (offline) ·
image_picker + flutter_image_compress · Cloud Functions (admin privilégié).

### Les 3 personas (utilisateurs quotidiens)
| Persona | Description | Rôles RBAC |
|---------|-------------|-----------|
| **Entrepreneur** (patron) | Propriétaire. Possède les exploitations, voit **tout**, valide. | `ADMIN` + `CHEF_EXPLOITATION` |
| **Chef d'équipe** | Sur le terrain, supervise les travaux, prend les photos, soumet les dépenses, met les activités en « Fait ». Rattaché à **un seul** entrepreneur. | `CHEF_PARCELLE` |
| **Ouvrier** | Exécute les activités. Voit ses tâches (s'il est connecté) et ses revenus. | `OUVRIER` |

Hiérarchie via `superieur_id` : un entrepreneur a plusieurs chefs ; un chef a plusieurs ouvriers ;
un chef est rattaché à un seul entrepreneur. Les rôles `TECHNICIEN`, `COMPTABLE`,
`SIGNATAIRE_DEPENSES`, `LECTEUR` restent disponibles pour des cas plus fins.

---

## 2. 🔒 Non-négociables d'architecture

1. **Noms de collections centralisés** dans `lib/core/constants/firestore_collections.dart`.
   Aucune chaîne de collection ailleurs. La casse héritée (`Parcelles`, `Materiels`) est conservée.
2. **`exploitation_ref` = champ tenant canonique.** Chaque requête métier filtre dessus.
3. **Règles Firestore : `create, read, update` explicites — JAMAIS `write`** (qui inclut `delete`).
4. **Soft delete uniquement, via `is_active`.** Aucun hard delete. Les listes filtrent `is_active == true`.
5. **`phoneToEmail` répliqué à l'identique de DEMETER1** : `225` + 10 chiffres + `@demeter-app.com`.
6. **RBAC réellement branché dans l'UI.** `USERS.roles` est une **liste**. 8 rôles, combinaisons
   autorisées/interdites (ex. interdit `OUVRIER`+`ADMIN`).
7. **Toutes les routes protégées** (auth + rôle) via `go_router redirect`.
8. **Reset mot de passe** : impossible avec emails synthétiques → Cloud Function admin (MVP).
9. **Développement sur Firebase Emulator Suite**, jamais sur la prod partagée.

---

## 3. Système de design

### 3.1 Principe : SIMPLICITÉ + dashboard épuré 🔒
Utilisateurs de terrain peu coutumiers du numérique, plein soleil, téléphones modestes, réseau intermittent.
- **Une action principale par écran.** Cibles ≥ 48 dp. Fort contraste. Libellés en français simple, zéro jargon/anglais.
- Divulgation progressive, états vides soignés, squelettes, bannière hors-ligne.

**Structure du dashboard (à respecter) :**
1. **Sélecteur d'exploitation** tout en haut (liste déroulante qui recharge le contenu de la page).
2. **4 tuiles-indicateurs** (grille 2×2) en haut de l'écran, chacune ouvre sa page :
   - **Consommation du budget** — icône **sac d'argent « FCFA »**, jauge % (vert → or → rouge). → page Trésor.
     *Visible uniquement par l'entrepreneur et le chef d'équipe (pas l'ouvrier).*
   - **Planning** — → calendrier (bouton « + » pour planifier une activité).
   - **Alertes** — icône avec compteur. → dépenses non validées, recommandations, tâches en retard, tâches rejetées.
   - **Suivi des stocks** — icône avec compteur d'incidents (stocks bas, matériel/produits bientôt manquants au vu du planning).
3. **Liste des 5 activités les plus récentes** sous les tuiles, avec statut : Fait / Vérifié / Rejeté / En retard
   (couleur + icône + libellé).
4. **Barre de navigation basse — 3 onglets**, grosses icônes minimalistes, **titre masqué** sauf sur l'onglet
   actif (et pendant la navigation dans ce menu) : **Accueil** (maison) · **Exploitations** (moulin) · **Trésor** (sac « FCFA »).

**Dashboard par persona :**
- **Entrepreneur** : les 4 tuiles. Trésor = toutes les données chiffrées (budget, dépenses, **revenus/ventes**, reste).
- **Chef d'équipe** : les 4 tuiles. Trésor = consommation budgétaire de **ses** parcelles, **sans les revenus**.
- **Ouvrier** : **Planning + « Mes revenus » uniquement** (pas de tuile budget). Trésor = ses revenus
  (journées/salaire à recevoir).

### 3.2 Palette de marque (extraite des logos)
| Token | Hex | Usage |
|-------|-----|-------|
| `primary` Vert Demeter | `#265C2F` | actions, nav active, validations |
| `secondary` Brun terre | `#502E15` | titres, en-têtes |
| `accent` **Or maïs** | `#C68A1F` | jauge budget, badges (parcimonieux) |
| espresso | `#24160E` | surfaces sombres / mode sombre |
| surface crème | `#FAF8F4` | fonds clairs |
| texte | `#1F140C` / `#6B5E52` | principal / secondaire |

**Statuts** (toujours couleur + icône + libellé) : Brouillon `#9E9385` · Planifié `#C68A1F` ·
En cours `#2F6FB0` · Fait/Terminé `#6BAE3A` · Vérifié/Validé `#265C2F` · Rejeté `#B23A2E` · Échéance `#C0392B`.

### 3.3 Typographie & formes
**Poppins** (titres/marque, validé) + **Inter** (corps, formulaires, montants en chiffres tabulaires `tnum`).
Base 8 pt · rayons 8/12/999 · élévation discrète · icônes Material Symbols Rounded.

### 3.4 Logos
`logo_brun` (clair, primaire) · `logo_vert` (clair, variante) · `logo_espresso` (sombre/splash) ·
`logo_hero_ble` (hero login/onboarding). Ne pas recoloriser ni déformer.

---

## 4. Modèle de données

Collections héritées (centralisées dans le fichier de constantes) : `USERS`, `exploitations`,
`Parcelles`, `activites`, `depenses`, `collaborateurs`, `stocks`, `consommation_stock`, `recoltes`,
`Materiels`, `membres_exploitation`, `invitations`, `notifications`, `revenus`.

**🆕 Nouvelle collection : `campagnes`** (n'existe pas dans DEMETER1, à créer).

### Entités clés
- **Exploitation** — `exploitation_ref` (tenant), nom, localisation, `is_active`.
- **Parcelle** — identité **physique uniquement** : `superficie_ha`, localisation, `exploitation_ref`, `is_active`.
  🔁 **La culture/rendement/dates ne sont PLUS sur la parcelle** (elles changent chaque campagne). Les champs
  culture hérités de DEMETER1 deviennent dépréciés (lecture seule, rétrocompat) ; la culture canonique vit sur la **Campagne**.
- **🆕 Campagne** (`campagnes`) — colonne vertébrale, agronomique **et** économique :
  `exploitation_ref`, `parcelle_refs` (liste — couvre 1+ parcelles), `culture`, `rendement_attendu_ha`,
  `date_debut`, `date_fin`, `prix_vente_cible`, `revenu_attendu` (calculé), `budget` (optionnel),
  `statut`, `is_active`.
- **Activité** (`activites`) — `campagne_ref` (l'activité **impacte** la campagne), `parcelle_refs`,
  `type`, `date_prevue`, `date_execution`, `statut`, `ouvriers` (refs collaborateurs), `photos` (liste),
  `ressources_consommees` (liste), `main_oeuvre_externe` (optionnel), workflow (auteur/dates de validation).
- **Ouvrier** = fiche **`collaborateurs`**, avec `user_id` **optionnel** (présent seulement si connecté).
- **Stock** / **consommation_stock** — une consommation décrémente le stock de l'exploitation.
- **Dépense** (`depenses`) — `type` : **directe** (rattachée activité/parcelle) | **générale** (frais généraux ventilés),
  montant FCFA, `statut` d'approbation, `Justif_depense` (liste — source de vérité ; `justificatif_url` déprécié).
- **Récolte** (`recoltes`) / **Revenu/Vente** (`revenus`) — pour le réalisé et les ventes.

---

## 5. 🔒 Règles métier (logique)

### Cycle de vie d'une activité
`Planifiée` → `Fait` → (`Vérifié` | `Rejeté`).
- Passage en **« Fait »** par le **chef d'équipe** (ou l'ouvrier) : **requiert obligatoirement** ≥ 1 **photo**
  prise par le chef, **+** la saisie des **ressources consommées** (engrais, semences, carburant…), **+**
  éventuellement la **main d'œuvre externe** et son coût. Le « Fait » du chef vaut déjà contrôle terrain.
- Passage **« Fait » → « Vérifié »** (ou « Rejeté ») : **par le patron (entrepreneur) SEUL.** C'est la
  vérification finale ; il consulte les photos. Le chef d'équipe ne vérifie pas.
- **En retard** = `date_prevue` dépassée et activité non faite.

### Moteur financier (alimente le dashboard)
- `revenu_attendu` = `rendement_attendu_ha` × **superficie totale de la campagne** × `prix_vente_cible`.
  → le `prix_vente_cible` est saisi **au lancement** de la campagne.
- `budget` : facultatif. **Si non renseigné → estimé à 70 % du `revenu_attendu`.** (Recommandation automatique
  prévue dans une version améliorée.)
- **Frais généraux** (dépense `générale` : salaires, impôts, transport, carburant général…) →
  **ventilés au prorata de la superficie** des parcelles/exploitations bénéficiaires.
  `part_parcelle = montant × (superficie_parcelle / Σ superficies bénéficiaires)`.
- `taux_consommation_budget` = total dépenses / budget (par campagne et par parcelle).

### Approbation
- **Seules les sorties d'argent** (achat neuf, main d'œuvre externe) sont **soumises par le chef** et
  **approuvées/rejetées par le patron**.
- La **consommation d'un stock déjà en magasin** est un **simple mouvement enregistré** (pas d'approbation) ;
  elle décrémente le stock.

---

## 6. Modules de l'application
1. **Auth** (téléphone synthétique). 2. **Dashboard** (§3.1, par persona). 3. **Exploitations & Parcelles**.
4. **🆕 Campagnes** (lancement, culture, prix cible, budget/estimation, rattachement parcelles).
5. **Activités** (workflow + photos + ressources + main d'œuvre). 6. **📅 Calendrier** (§7).
7. **Trésor** (dépenses directes/générales + ventilation, ventes/revenus, stocks, récoltes ; vues role-gated).
8. **Personnel (RH)** (collaborateurs, invitations). 9. **Alertes / Notifications**.

---

## 7. 📅 Module Calendrier
Vue des tâches **prévues**, **réalisées** et des **échéances**. **Aucune nouvelle collection** : vue au-dessus
de `activites` (`date_prevue` = prévu, `date_execution` = réalisé) + échéances (retards + `campagnes.date_fin` /
récoltes prévues). `table_calendar`, vues mois/semaine, marqueurs colorés par statut, bouton « + » pour
planifier. 🔒 Filtré par `exploitation_ref` **et** par RBAC (périmètre du rôle).

---

## 8. Déploiement (VPS Hostinger)
Web : `flutter build web --release` → nginx (statique, gzip/brotli, HTTP/2, fallback SPA → `index.html`) + certbot.
APK : `flutter build apk --release` (distribution directe / WhatsApp / hébergé sur le VPS).
Firebase : domaine du VPS dans Auth → Authorized domains ; règles Storage durcies.
Admin privilégié (reset MDP, invitations) : Cloud Functions. Claude/sessions sur le VPS : toujours dans `tmux`/`screen`.

---

## 9. Méthode 🔒
Progression **phase par phase** avec **gate de validation** avant la suivante. Émulateur pour tout test.
Voir **`PROMPTS_CLAUDE_CODE.md`**.
