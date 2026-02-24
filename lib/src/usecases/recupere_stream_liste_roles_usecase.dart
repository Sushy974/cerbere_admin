import 'package:cerbere/cerbere.dart';

/// Usecase pour récupérer un stream de la liste des rôles
class RecupereStreamListeRolesUsecase {
  RecupereStreamListeRolesUsecase({
    required CerbereRoleRepository roleRepository,
  }) : _roleRepository = roleRepository;

  final CerbereRoleRepository _roleRepository;

  Stream<List<CerbereRole>> execute() {
    return _roleRepository.listenRoles();
  }
}
