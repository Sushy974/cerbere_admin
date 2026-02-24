import 'package:cerbere/cerbere.dart';

/// Usecase pour supprimer un rôle
class SupprimeRoleUsecase {
  SupprimeRoleUsecase({
    required CerbereRoleRepository roleRepository,
  }) : _roleRepository = roleRepository;

  final CerbereRoleRepository _roleRepository;

  Future<void> execute(SupprimeRoleCommand command) async {
    await _roleRepository.deleteRole(command.roleUid);
  }
}

/// Commande pour supprimer un rôle
class SupprimeRoleCommand {
  SupprimeRoleCommand({
    required this.roleUid,
  });

  final String roleUid;
}
