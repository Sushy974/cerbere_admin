import '../repositories/cerbere_utilisateur_admin_repository.dart';

/// Usecase pour supprimer le rôle d'un utilisateur
class SupprimeRoleUtilisateurUsecase {
  /// Crée le use case avec le repository utilisateur admin.
  SupprimeRoleUtilisateurUsecase({
    required CerbereUtilisateurAdminRepository utilisateurRepository,
  }) : _utilisateurRepository = utilisateurRepository;

  final CerbereUtilisateurAdminRepository _utilisateurRepository;

  /// Retire le rôle associé à l'utilisateur désigné par [command].
  Future<void> execute(SupprimeRoleUtilisateurCommand command) async {
    await _utilisateurRepository.removeRoleFromUser(command.utilisateurUid);
  }
}

/// Commande pour supprimer le rôle d'un utilisateur
class SupprimeRoleUtilisateurCommand {
  /// Crée la commande à partir de l'UID Firebase Auth de l'utilisateur.
  SupprimeRoleUtilisateurCommand({
    required this.utilisateurUid,
  });

  /// UID Firebase Auth de l'utilisateur dont on retire le rôle.
  final String utilisateurUid;
}
