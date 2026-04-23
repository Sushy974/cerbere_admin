import 'package:equatable/equatable.dart';
import 'package:cerbere/cerbere.dart';

/// Item représentant un utilisateur avec son rôle
class CerbereUtilisateurItem extends Equatable {
  /// Crée un item à partir des données Firebase Auth et du rôle Cerbère
  /// éventuellement associé.
  const CerbereUtilisateurItem({
    required this.uid,
    required this.email,
    required this.displayName,
    this.roleUid,
    this.role,
    this.isAdmin = false,
  });

  /// UID Firebase Auth de l'utilisateur.
  final String uid;

  /// Email de l'utilisateur.
  final String email;

  /// Nom affiché de l'utilisateur (peut être `null`).
  final String? displayName;

  /// UID du rôle assigné, ou `null` si aucun rôle.
  final String? roleUid;

  /// Rôle Cerbère complet (résolu depuis [roleUid]), ou `null`.
  final CerbereRole? role;

  /// Super admin : tous les droits sans rôle.
  final bool isAdmin;

  @override
  List<Object?> get props => [uid, email, displayName, roleUid, role, isAdmin];
}
