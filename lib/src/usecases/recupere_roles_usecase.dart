import 'package:cerbere/cerbere.dart';

/// Usecase pour récupérer tous les rôles
class RecupereRolesUsecase {
  /// Crée le use case avec le repository de rôles Cerbère.
  RecupereRolesUsecase({
    required CerbereRoleRepository roleRepository,
  }) : _roleRepository = roleRepository;

  final CerbereRoleRepository _roleRepository;

  /// Retourne la liste complète des rôles enregistrés.
  Future<List<CerbereRole>> execute() async {
    return _roleRepository.getAllRoles();
  }
}
