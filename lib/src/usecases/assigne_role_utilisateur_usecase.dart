import '../repositories/cerbere_utilisateur_admin_repository.dart';

/// Usecase pour assigner un rôle à un utilisateur
class AssigneRoleUtilisateurUsecase {
  /// Crée le use case avec le repository utilisateur admin.
  AssigneRoleUtilisateurUsecase({
    required CerbereUtilisateurAdminRepository utilisateurRepository,
  }) : _utilisateurRepository = utilisateurRepository;

  final CerbereUtilisateurAdminRepository _utilisateurRepository;

  /// Exécute l'assignation du rôle décrit par [command].
  Future<void> execute(AssigneRoleUtilisateurCommand command) async {
    await _utilisateurRepository.assignRoleToUser(
      command.utilisateurUid,
      command.roleUid,
    );
  }
}

/// Commande pour assigner un rôle à un utilisateur
class AssigneRoleUtilisateurCommand {
  /// Crée la commande avec l'UID utilisateur et l'UID du rôle à assigner.
  AssigneRoleUtilisateurCommand({
    required this.utilisateurUid,
    required this.roleUid,
  });

  /// UID Firebase Auth de l'utilisateur cible.
  final String utilisateurUid;

  /// UID du rôle Cerbère à assigner.
  final String roleUid;
}
