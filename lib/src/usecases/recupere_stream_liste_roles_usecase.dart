import 'package:cerbere/cerbere.dart';

/// Usecase pour récupérer un stream de la liste des rôles
class RecupereStreamListeRolesUsecase {
  /// Crée le use case avec le repository de rôles Cerbère.
  RecupereStreamListeRolesUsecase({
    required CerbereRoleRepository roleRepository,
  }) : _roleRepository = roleRepository;

  final CerbereRoleRepository _roleRepository;

  /// Retourne un flux qui émet la liste des rôles à chaque modification.
  Stream<List<CerbereRole>> execute() {
    return _roleRepository.listenRoles();
  }
}
