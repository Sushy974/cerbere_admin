import 'package:cerbere/cerbere.dart';

/// Usecase pour récupérer tous les rôles
class RecupereRolesUsecase {
  RecupereRolesUsecase({
    required CerbereRoleRepository roleRepository,
  }) : _roleRepository = roleRepository;

  final CerbereRoleRepository _roleRepository;

  Future<List<CerbereRole>> execute() async {
    return _roleRepository.getAllRoles();
  }
}
