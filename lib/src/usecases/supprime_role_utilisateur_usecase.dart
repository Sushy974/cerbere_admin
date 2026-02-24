import '../repositories/cerbere_utilisateur_admin_repository.dart';

/// Usecase pour supprimer le rôle d'un utilisateur
class SupprimeRoleUtilisateurUsecase {
  SupprimeRoleUtilisateurUsecase({
    required CerbereUtilisateurAdminRepository utilisateurRepository,
  }) : _utilisateurRepository = utilisateurRepository;

  final CerbereUtilisateurAdminRepository _utilisateurRepository;

  Future<void> execute(SupprimeRoleUtilisateurCommand command) async {
    await _utilisateurRepository.removeRoleFromUser(command.utilisateurUid);
  }
}

/// Commande pour supprimer le rôle d'un utilisateur
class SupprimeRoleUtilisateurCommand {
  SupprimeRoleUtilisateurCommand({
    required this.utilisateurUid,
  });

  final String utilisateurUid;
}
