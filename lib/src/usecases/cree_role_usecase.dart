import 'package:cerbere/cerbere.dart';

/// Usecase pour créer un rôle
class CreeRoleUsecase {
  CreeRoleUsecase({
    required CerbereRoleRepository roleRepository,
  }) : _roleRepository = roleRepository;

  final CerbereRoleRepository _roleRepository;

  Future<void> execute(CreeRoleCommand command) async {
    await _roleRepository.createRole(command.role);
  }
}

/// Commande pour créer un rôle
class CreeRoleCommand {
  CreeRoleCommand({
    required this.role,
  });

  final CerbereRole role;
}
