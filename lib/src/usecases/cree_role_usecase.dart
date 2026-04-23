import 'package:cerbere/cerbere.dart';

/// Usecase pour créer un rôle
class CreeRoleUsecase {
  /// Crée le use case avec le repository de rôles Cerbère.
  CreeRoleUsecase({
    required CerbereRoleRepository roleRepository,
  }) : _roleRepository = roleRepository;

  final CerbereRoleRepository _roleRepository;

  /// Exécute la création du rôle décrit par [command].
  Future<void> execute(CreeRoleCommand command) async {
    await _roleRepository.createRole(command.role);
  }
}

/// Commande pour créer un rôle
class CreeRoleCommand {
  /// Crée la commande à partir du [role] à persister.
  CreeRoleCommand({
    required this.role,
  });

  /// Rôle Cerbère à créer.
  final CerbereRole role;
}
