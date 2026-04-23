# Changelog

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0+6] - 2026-04-23

### Ajouté

- `RecupereRoleUtilisateurUsecase` pour récupérer le rôle `CerbereRole` attribué à un utilisateur.
- Dartdoc complétée sur les use cases, commandes, et modèles publics (`CerbereUtilisateurItem`, repository admin, widget d'initialisation).

### Modifié

- `CerbereAdminInitWidget` : enregistrement de la langue via `CerbereLangueRegistry` en plus des droits ; langue configurable via le paramètre `langue` (par défaut `CerbereLangue.en`).
- `CerbereUtilisateurAdminRepository` : simplification des messages d'erreur et alignement sur l'interface `CerbereUtilisateurRepository`.
- Pages `CerbereUtilisateursPage` / `CerbereRolesPage` et vues associées : refonte UI alignée sur `CerbereTheme` et utilisation des traductions via `CerbereLangueVariable`.

### Dépendances

- `cerbere` mis à jour à `^0.2.0`.

## [0.1.0+4] - 2025-02-24

### Corrigé

- README : lien vers cerbere redirige vers pub.dev au lieu de GitHub.

## [0.1.0+3] - 2025-02-24

### Ajouté

- Exemple d'utilisation dans `example/`.

### Corrigé

- Documentation dartdoc pour les symboles publics manquants (constructeurs, `firebaseAdminApp`, `isAdmin`).
- Dépréciation : `activeColor` remplacé par `activeThumbColor` sur le `Switch`.

## [0.1.0+2] - 2025-02-24

### Corrigé

- Image du README : utilisation de l'URL GitHub pour affichage correct sur pub.dev.

## [0.1.0+1] - 2025-02-24

### Ajouté

- Package initial **cerbere_admin**, complément de [cerbere](https://github.com/Sushy974/cerbere).
- Widget d'initialisation `CerbereAdminInitWidget` pour les applications d'administration (Firebase Auth, Firestore, Firebase Admin SDK, liste des droits).
- Page de gestion des utilisateurs et de leurs rôles : `CerbereUtilisateursPage`.
- Page de gestion des rôles et droits : `CerbereRolesPage` (avec formulaire de création/édition).
- Repository étendu `CerbereUtilisateurAdminRepository` avec `getAllFirebaseUsers()` (via Firebase Admin SDK).
- Thème et layout dédiés (`CerbereTheme`, `CerbereLayout`).
- Use cases : création/suppression/modification de rôles, assignation/suppression de rôles utilisateur, mise à jour super admin, récupération utilisateurs avec rôles.

### Dépendances

- `cerbere` (rôles et autorisations côté client).
- `dart_firebase_admin` (Firebase Admin SDK pour Dart).
- `flutter_bloc`, `equatable`, `uuid`.

[Unreleased]: https://github.com/Sushy974/cerbere_admin/compare/v0.2.0+6...HEAD
[0.2.0+6]: https://github.com/Sushy974/cerbere_admin/compare/v0.1.0+4...v0.2.0+6
[0.1.0+4]: https://github.com/Sushy974/cerbere_admin/compare/v0.1.0+3...v0.1.0+4
[0.1.0+3]: https://github.com/Sushy974/cerbere_admin/compare/v0.1.0+2...v0.1.0+3
[0.1.0+2]: https://github.com/Sushy974/cerbere_admin/compare/v0.1.0+1...v0.1.0+2
[0.1.0+1]: https://github.com/Sushy974/cerbere_admin/releases/tag/v0.1.0
