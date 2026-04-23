import 'package:cerbere/cerbere.dart';
import '../repositories/cerbere_utilisateur_admin_repository.dart';

/// Usecase pour récupérer le rôle attribué à un utilisateur.
/// Retourne null si aucun rôle n'est attribué.
class RecupereRoleUtilisateurUsecase {
  /// Crée le use case avec les repositories utilisateur admin et rôles.
  RecupereRoleUtilisateurUsecase({
    required CerbereUtilisateurAdminRepository utilisateurRepository,
    required CerbereRoleRepository roleRepository,
  })  : _utilisateurRepository = utilisateurRepository,
        _roleRepository = roleRepository;

  final CerbereUtilisateurAdminRepository _utilisateurRepository;
  final CerbereRoleRepository _roleRepository;

  /// Retourne le [CerbereRole] assigné à [utilisateurUid], ou `null`
  /// si l'utilisateur n'a pas d'association ou pas de rôle.
  Future<CerbereRole?> execute(String utilisateurUid) async {
    final utilisateur =
        await _utilisateurRepository.getUtilisateurByUid(utilisateurUid);
    if (utilisateur == null || utilisateur.roleUid.isEmpty) return null;

    return _roleRepository.getRoleByUid(utilisateur.roleUid);
  }
}
