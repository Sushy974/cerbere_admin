# Heracles Admin

Package Dart/Flutter pour la gestion administrative des rôles et droits avec Firebase Admin SDK.

## Description

Heracles Admin est un package qui étend `heracles` avec des fonctionnalités d'administration nécessitant Firebase Admin SDK. Il fournit :

- Des pages d'administration pour gérer les utilisateurs, rôles et droits
- Un repository étendu pour récupérer la liste des utilisateurs Firebase Auth

**Note** : Ce package dépend de `heracles` et nécessite Firebase Admin SDK.

## Installation

Ajoutez `heracles_admin` à votre `pubspec.yaml` :

```yaml
dependencies:
  heracles_admin:
    path: ../packages/heracles_admin
```

## Initialisation

Dans votre `main.dart` d'application d'administration, enveloppez votre application avec `HeraclesAdminInitWidget` :

```dart
import 'package:heracles_admin/heracles_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation Firebase
  await Firebase.initializeApp(...);
  
  // Initialisation Firebase Admin SDK (requis)
  final adminApp = FirebaseAdminApp.initializeApp(
    'your-project-id',
    Credential.fromServiceAccountParams(
      email: 'your-service-account@project.iam.gserviceaccount.com',
      clientId: 'your-client-id',
      privateKey: 'your-private-key',
    ),
  );
  
  // Définir la liste des droits disponibles dans votre application
  final droits = [
    'can_edit_users',
    'can_delete_users',
    'can_view_reports',
    // Ajoutez tous vos droits ici
  ];
  
  runApp(
    HeraclesAdminInitWidget(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      firebaseAdminApp: adminApp, // Requis
      droits: droits, // Liste des droits disponibles
      child: MyAdminApp(),
    ),
  );
}
```

## Utilisation

### Page de gestion des utilisateurs

```dart
import 'package:heracles_admin/heracles_admin.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const HeraclesUtilisateursPage(),
  ),
);
```

La page récupère automatiquement la liste des utilisateurs Firebase Auth via Firebase Admin SDK.

### Page de gestion des rôles

```dart
import 'package:heracles_admin/heracles_admin.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const HeraclesRolesPage(),
  ),
);
```

## Repository étendu

Le package fournit `HeraclesUtilisateurAdminRepository` qui étend `HeraclesUtilisateurRepository` avec la méthode `getAllFirebaseUsers()` pour récupérer la liste des utilisateurs Firebase Auth.

## Séparation des packages

- **heracles** : Package de base pour gérer les permissions dans une app normale (sans Firebase Admin SDK)
- **heracles_admin** : Package pour la gestion administrative (nécessite Firebase Admin SDK)

Cette séparation permet d'utiliser `heracles` dans des applications normales sans dépendre de Firebase Admin SDK, et d'utiliser `heracles_admin` uniquement dans les applications d'administration.

## Licence

Ce package est fourni tel quel, sans garantie.
