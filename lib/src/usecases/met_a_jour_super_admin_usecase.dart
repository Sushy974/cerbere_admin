import '../repositories/cerbere_utilisateur_admin_repository.dart';

/// Use case pour mettre à jour le statut super admin (isAdmin) d'un utilisateur.
class MetAJourSuperAdminUsecase {
  /// Crée le use case avec le repository utilisateur admin.
  MetAJourSuperAdminUsecase({
    required CerbereUtilisateurAdminRepository utilisateurRepository,
  }) : _utilisateurRepository = utilisateurRepository;

  final CerbereUtilisateurAdminRepository _utilisateurRepository;

  /// Met à jour le flag super admin de l'utilisateur [utilisateurUid].
  Future<void> execute(String utilisateurUid, bool isAdmin) async {
    await _utilisateurRepository.setAdmin(utilisateurUid, isAdmin);
  }
}
