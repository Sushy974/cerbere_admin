import 'package:cerbere/cerbere.dart';

/// Usecase pour modifier un rôle
class ModifieRoleUsecase {
  ModifieRoleUsecase({
    required CerbereRoleRepository roleRepository,
  }) : _roleRepository = roleRepository;

  final CerbereRoleRepository _roleRepository;

  Future<void> execute(ModifieRoleCommand command) async {
    await _roleRepository.updateRole(command.role);
  }
}

/// Commande pour modifier un rôle
class ModifieRoleCommand {
  ModifieRoleCommand({
    required this.role,
  });

  final CerbereRole role;
}
