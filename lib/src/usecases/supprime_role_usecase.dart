import 'package:cerbere/cerbere.dart';

/// Usecase pour supprimer un rôle
class SupprimeRoleUsecase {
  /// Crée le use case avec le repository de rôles Cerbère.
  SupprimeRoleUsecase({
    required CerbereRoleRepository roleRepository,
  }) : _roleRepository = roleRepository;

  final CerbereRoleRepository _roleRepository;

  /// Exécute la suppression du rôle désigné par [command].
  Future<void> execute(SupprimeRoleCommand command) async {
    await _roleRepository.deleteRole(command.roleUid);
  }
}

/// Commande pour supprimer un rôle
class SupprimeRoleCommand {
  /// Crée la commande à partir de l'UID du rôle à supprimer.
  SupprimeRoleCommand({
    required this.roleUid,
  });

  /// UID du rôle Cerbère à supprimer.
  final String roleUid;
}
