import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:cerbere/cerbere.dart';
import '../repositories/cerbere_utilisateur_admin_repository.dart';

/// Widget d'initialisation Cerbere Admin
///
/// À utiliser dans une application d'administration pour gérer les utilisateurs, rôles et droits.
/// Nécessite Firebase Admin SDK pour récupérer la liste des utilisateurs.
///
/// Exemple:
/// ```dart
/// void main() {
///   final adminApp = FirebaseAdminApp.initializeApp(
///     'your-project-id',
///     Credential.fromServiceAccountParams(...),
///   );
///
///   runApp(
///     CerbereAdminInitWidget(
///       firebaseAuth: FirebaseAuth.instance,
///       firestore: FirebaseFirestore.instance,
///       firebaseAdminApp: adminApp,
///       droits: [
///         CerbereDroit(
///           cle: 'can_edit_users',
///           nom: 'Éditer les utilisateurs',
///           description: 'Permet d\'éditer les utilisateurs',
///         ),
///         CerbereDroit(
///           cle: 'can_delete_users',
///           nom: 'Supprimer les utilisateurs',
///           description: 'Permet de supprimer les utilisateurs',
///         ),
///       ],
///       child: MyAdminApp(),
///     ),
///   );
/// }
/// ```
class CerbereAdminInitWidget extends StatelessWidget {
  /// Creates the admin init widget with Firebase Auth, Firestore and Admin SDK.
  ///
  /// {@macro cerbere_admin_init_widget}
  const CerbereAdminInitWidget({
    required this.child,
    required this.firebaseAuth,
    required this.firestore,
    required this.firebaseAdminApp,
    required this.droits,
    this.langue = CerbereLangue.en,
    super.key,
  });

  /// Widget enfant (généralement votre App Admin)
  final Widget child;

  /// Instance Firebase Auth
  final FirebaseAuth firebaseAuth;

  /// Instance Firestore
  final FirebaseFirestore firestore;

  /// Instance Firebase Admin App (requis pour récupérer la liste des utilisateurs)
  final FirebaseAdminApp firebaseAdminApp;

  /// Liste des droits disponibles dans l'application
  final List<CerbereDroit> droits;

  /// Langue de l'interface (par défaut français)
  final CerbereLangue langue;

  @override
  Widget build(BuildContext context) {
    // Enregistrer la langue dans le registry
    CerbereLangueRegistry.register(langue);

    // Enregistrer la liste des droits dans le registry
    CerbereDroitsRegistry.register(droits);

    // Création des repositories de base (depuis cerbere)
    final roleRepository = FirestoreCerbereRoleRepository(
      firestore: firestore,
    );

    // Repository étendu avec support Admin SDK
    final utilisateurRepository = CerbereUtilisateurAdminRepository(
      firestore: firestore,
      firebaseAdminApp: firebaseAdminApp,
      firebaseAuth: firebaseAuth,
    );

    // Création du service
    final service = CerbereService(
      firebaseAuth: firebaseAuth,
      roleRepository: roleRepository,
      utilisateurRepository: utilisateurRepository,
    );

    // Enveloppe l'app avec les providers nécessaires
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CerbereRoleRepository>.value(
          value: roleRepository,
        ),
        RepositoryProvider<CerbereUtilisateurRepository>.value(
          value: utilisateurRepository,
        ),
        RepositoryProvider<CerbereUtilisateurAdminRepository>.value(
          value: utilisateurRepository,
        ),
        RepositoryProvider<CerbereService>.value(
          value: service,
        ),
      ],
      child: child,
    );
  }
}
