import 'package:equatable/equatable.dart';
import 'package:cerbere/cerbere.dart';

/// Item représentant un utilisateur avec son rôle
class CerbereUtilisateurItem extends Equatable {
  const CerbereUtilisateurItem({
    required this.uid,
    required this.email,
    required this.displayName,
    this.roleUid,
    this.role,
    this.isAdmin = false,
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? roleUid;
  final CerbereRole? role;

  /// Super admin : tous les droits sans rôle.
  final bool isAdmin;

  @override
  List<Object?> get props => [uid, email, displayName, roleUid, role, isAdmin];
}
