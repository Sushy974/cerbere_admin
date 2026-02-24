import '../repositories/cerbere_utilisateur_admin_repository.dart';

/// Usecase pour assigner un rôle à un utilisateur
class AssigneRoleUtilisateurUsecase {
  AssigneRoleUtilisateurUsecase({
    required CerbereUtilisateurAdminRepository utilisateurRepository,
  }) : _utilisateurRepository = utilisateurRepository;

  final CerbereUtilisateurAdminRepository _utilisateurRepository;

  Future<void> execute(AssigneRoleUtilisateurCommand command) async {
    await _utilisateurRepository.assignRoleToUser(
      command.utilisateurUid,
      command.roleUid,
    );
  }
}

/// Commande pour assigner un rôle à un utilisateur
class AssigneRoleUtilisateurCommand {
  AssigneRoleUtilisateurCommand({
    required this.utilisateurUid,
    required this.roleUid,
  });

  final String utilisateurUid;
  final String roleUid;
}
