import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/auth.dart' as admin_auth;
import 'package:cerbere/cerbere.dart';

/// Repository étendu pour l'administration avec support Firebase Admin SDK
class CerbereUtilisateurAdminRepository
    implements CerbereUtilisateurRepository {
  /// Creates the admin repository with Firestore and Firebase Admin app.
  ///
  /// {@macro cerbere_utilisateur_admin_repository}
  CerbereUtilisateurAdminRepository({
    required FirebaseFirestore firestore,
    required this.firebaseAdminApp,
    FirebaseAuth? firebaseAuth,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  /// The Firebase Admin app instance used to list Auth users.
  final FirebaseAdminApp firebaseAdminApp;
  static const String _collection = '_cerbere_utilisateur';

  @override
  Future<List<CerbereUtilisateur>> getAllUtilisateurs() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs
          .map(
            (doc) => CerbereUtilisateur.fromFirestore({
              'utilisateurUid': doc.id,
              ...doc.data(),
            }),
          )
          .toList();
    } catch (e) {
      throw CerbereException(
        'Erreur lors de la récupération des utilisateurs: ${e.toString()}',
      );
    }
  }

  @override
  Stream<List<CerbereUtilisateur>> listenUtilisateurs() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => CerbereUtilisateur.fromFirestore({
              'utilisateurUid': doc.id,
              ...doc.data(),
            }),
          )
          .toList();
    });
  }

  @override
  Future<CerbereUtilisateur?> getUtilisateurByUid(
    String utilisateurUid,
  ) async {
    try {
      final doc = await _firestore
          .collection(_collection)
          .doc(utilisateurUid)
          .get();
      if (!doc.exists) return null;
      return CerbereUtilisateur.fromFirestore({
        'utilisateurUid': doc.id,
        ...doc.data()!,
      });
    } catch (e) {
      throw CerbereException(
        'Erreur lors de la récupération de l\'utilisateur: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> assignRoleToUser(
    String utilisateurUid,
    String roleUid,
  ) async {
    try {
      final docRef = _firestore.collection(_collection).doc(utilisateurUid);
      final doc = await docRef.get();
      final data = doc.data();
      await docRef.set({
        'utilisateurUid': utilisateurUid,
        'roleUid': roleUid,
        'isAdmin': data?['isAdmin'] as bool? ?? false,
      });
    } catch (e) {
      throw CerbereException(
        'Erreur lors de l\'assignation du rôle: ${e.toString()}',
      );
    }
  }

  /// Met à jour le flag super admin (isAdmin) pour un utilisateur.
  Future<void> setAdmin(String utilisateurUid, bool isAdmin) async {
    try {
      final docRef = _firestore.collection(_collection).doc(utilisateurUid);
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({'isAdmin': isAdmin});
      } else {
        await docRef.set({
          'utilisateurUid': utilisateurUid,
          'roleUid': '',
          'isAdmin': isAdmin,
        });
      }
    } catch (e) {
      throw CerbereException(
        'Erreur lors de la mise à jour du statut super admin: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> removeRoleFromUser(String utilisateurUid) async {
    try {
      await _firestore.collection(_collection).doc(utilisateurUid).delete();
    } catch (e) {
      throw CerbereException(
        'Erreur lors de la suppression du rôle de l\'utilisateur: ${e.toString()}',
      );
    }
  }

  /// Récupère la liste de tous les utilisateurs Firebase Auth
  /// Nécessite Firebase Admin SDK
  Future<List<admin_auth.UserRecord>> getAllFirebaseUsers() async {
    try {
      final auth = admin_auth.Auth(firebaseAdminApp);
      final allUsers = <admin_auth.UserRecord>[];
      String? pageToken;

      do {
        final result = await auth.listUsers(
          maxResults: 1000,
          pageToken: pageToken,
        );
        allUsers.addAll(result.users);
        pageToken = result.pageToken;
      } while (pageToken != null);

      return allUsers;
    } catch (e) {
      throw CerbereException(
        'Erreur lors de la récupération des utilisateurs Firebase Auth: ${e.toString()}',
      );
    }
  }

  /// Returns whether the user has the super admin flag.
  @override
  Future<bool> isAdmin(String utilisateurUid) async {
    return _firestore
        .collection(_collection)
        .doc(utilisateurUid)
        .get()
        .then((value) => value.data()?['isAdmin'] as bool? ?? false);
  }
}
