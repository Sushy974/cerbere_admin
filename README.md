# Cerbère Admin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

<p align="center">
  <img src="https://github.com/Sushy974/cerbere_admin/raw/main/assets/images/cerbere_admin.png" alt="Cerbère Admin" width="400" />
</p>

Package Flutter complémentaire de [**cerbere**](https://github.com/Sushy974/cerbere) pour la gestion **administrative** des rôles et droits avec **Firebase Admin SDK**.

- **cerbere** : rôles et autorisations dans une app classique (sans Admin SDK).
- **cerbere_admin** : back-office admin (utilisateurs, rôles, droits) avec liste des utilisateurs Firebase Auth via Admin SDK.

---

## Fonctionnalités

- **Pages d’administration** : gestion des utilisateurs (et de leurs rôles), gestion des rôles et droits.
- **Repository étendu** : `CerbereUtilisateurAdminRepository` avec `getAllFirebaseUsers()` (Firebase Admin SDK).
- **Widget d’initialisation** : `CerbereAdminInitWidget` pour brancher Auth, Firestore, Admin SDK et liste des droits.
- **Thème et layout** : thème et layout dédiés pour une app admin cohérente.

**Prérequis** : ce package dépend de **cerbere** et nécessite **Firebase Admin SDK** (via `dart_firebase_admin`).

---

## Installation

### Depuis pub.dev (quand le package sera publié)

Ajoutez dans votre `pubspec.yaml` :

```yaml
dependencies:
  cerbere_admin: ^0.1.0
```

Puis :

```bash
flutter pub get
```

### En développement local (monorepo / path)

Si vous travaillez avec des clones locaux de `cerbere` et `dart_firebase_admin` :

```yaml
dependencies:
  cerbere_admin:
    path: ../cerbere_admin
```

Assurez-vous que `cerbere` et `dart_firebase_admin` sont résolus (par exemple via `path` ou `dependency_overrides`).

---

## Configuration Firebase

- **Firebase** (Auth, Firestore) configuré côté client comme d’habitude.
- **Firebase Admin SDK** : initialisez une app Admin (compte de service) pour pouvoir lister les utilisateurs Auth. Utilisez le package [dart_firebase_admin](https://github.com/Sushy974/dart_firebase_admin) (ou équivalent).

---

## Initialisation

Dans le `main.dart` de votre **application d’administration**, enveloppez l’app avec `CerbereAdminInitWidget` :

```dart
import 'package:cerbere_admin/cerbere_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:cerbere/cerbere.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(...);

  final adminApp = FirebaseAdminApp.initializeApp(
    'your-project-id',
    Credential.fromServiceAccountParams(
      email: 'your-service-account@project.iam.gserviceaccount.com',
      clientId: 'your-client-id',
      privateKey: 'your-private-key',
    ),
  );

  final droits = [
    CerbereDroit(
      cle: 'can_edit_users',
      nom: 'Éditer les utilisateurs',
      description: 'Permet d\'éditer les utilisateurs',
    ),
    CerbereDroit(
      cle: 'can_delete_users',
      nom: 'Supprimer les utilisateurs',
      description: 'Permet de supprimer les utilisateurs',
    ),
    CerbereDroit(
      cle: 'can_view_reports',
      nom: 'Voir les rapports',
      description: 'Accès aux rapports',
    ),
  ];

  runApp(
    CerbereAdminInitWidget(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      firebaseAdminApp: adminApp,
      droits: droits,
      langue: CerbereLangue.fr, // optionnel, défaut: CerbereLangue.en
      child: MyAdminApp(),
    ),
  );
}
```

---

## Utilisation

### Page de gestion des utilisateurs

Affiche la liste des utilisateurs (Firebase Auth via Admin SDK) et permet d’assigner ou retirer des rôles :

```dart
import 'package:cerbere_admin/cerbere_admin.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const CerbereUtilisateursPage(),
  ),
);

// Avec option d’affichage de la colonne "nom"
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const CerbereUtilisateursPage(colonneNom: true),
  ),
);
```

Helpers de navigation :

```dart
Navigator.of(context).push(CerbereUtilisateursPage.route());
// ou
Navigator.of(context).push(CerbereUtilisateursPage.page());
```

### Page de gestion des rôles

Gestion des rôles et de leurs droits (création, édition, suppression) :

```dart
import 'package:cerbere_admin/cerbere_admin.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const CerbereRolesPage(),
  ),
);

// Ou
Navigator.of(context).push(CerbereRolesPage.route());
```

### Repository étendu

`CerbereUtilisateurAdminRepository` étend `CerbereUtilisateurRepository` et ajoute :

- **`getAllFirebaseUsers()`** : récupère la liste des utilisateurs Firebase Auth via Firebase Admin SDK.

Il est enregistré par `CerbereAdminInitWidget` ; vous pouvez le récupérer avec :

```dart
final repo = context.read<CerbereUtilisateurAdminRepository>();
final firebaseUsers = await repo.getAllFirebaseUsers();
```

---

## API exportée

Le package exporte (via `package:cerbere_admin/cerbere_admin.dart`) :

| Export | Description |
|--------|-------------|
| `CerbereAdminInitWidget` | Widget d’initialisation (Auth, Firestore, Admin SDK, droits). |
| `CerbereUtilisateurAdminRepository` | Repository utilisateur avec support Admin SDK. |
| `CerbereUtilisateursPage` | Page de gestion des utilisateurs et de leurs rôles. |
| `CerbereRolesPage` | Page de gestion des rôles et droits. |

---

## Structure recommandée des packages

- **cerbere** : package de base (rôles, droits, permissions) pour une app classique, sans dépendance à Firebase Admin SDK.
- **cerbere_admin** : package pour l’app d’administration uniquement (utilisateurs, rôles, droits), avec Firebase Admin SDK.

Cela permet d’utiliser **cerbere** dans vos applications métier sans charger l’Admin SDK, et **cerbere_admin** uniquement dans l’application d’administration.

---

## Dépendances

- **cerbere** : rôles et autorisations.
- **dart_firebase_admin** : Firebase Admin SDK pour Dart.
- **flutter_bloc**, **equatable**, **uuid**.

---

## Tests

```bash
flutter test
```

---

## Publication sur pub.dev

1. **Publier d’abord** les packages **cerbere** et **dart_firebase_admin** sur pub.dev (s’ils ne le sont pas déjà).

2. Dans `pubspec.yaml` de **cerbere_admin** :
   - Remplacer les dépendances `path` par des contraintes de version, par exemple :
     ```yaml
     dependencies:
       cerbere: ^0.1.0
       dart_firebase_admin: ^0.1.0
     ```
   - Retirer ou commenter `publish_to: none` pour autoriser la publication sur pub.dev.
   - Décommenter et adapter les métadonnées (homepage, repository, issue_tracker, documentation, topics).

3. Vérifier la description (courte, en anglais recommandé pour pub.dev) et le `CHANGELOG.md`.

4. Dry-run puis publication :
   ```bash
   dart pub publish --dry-run
   dart pub publish
   ```

---

## Contribution

Les contributions sont les bienvenues. Ouvrez une issue ou une pull request sur le [dépôt GitHub](https://github.com/Sushy974/cerbere_admin).

---

## Licence

Ce projet est sous licence **MIT**. Voir le fichier [LICENSE](LICENSE) pour les détails.
