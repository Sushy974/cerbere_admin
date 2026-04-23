import 'package:cerbere/cerbere.dart';

/// Usecase pour modifier un rôle
class ModifieRoleUsecase {
  /// Crée le use case avec le repository de rôles Cerbère.
  ModifieRoleUsecase({
    required CerbereRoleRepository roleRepository,
  }) : _roleRepository = roleRepository;

  final CerbereRoleRepository _roleRepository;

  /// Exécute la mise à jour du rôle décrit par [command].
  Future<void> execute(ModifieRoleCommand command) async {
    await _roleRepository.updateRole(command.role);
  }
}

/// Commande pour modifier un rôle
class ModifieRoleCommand {
  /// Crée la commande à partir du [role] contenant les valeurs mises à jour.
  ModifieRoleCommand({
    required this.role,
  });

  /// Rôle Cerbère portant les valeurs à persister.
  final CerbereRole role;
}
