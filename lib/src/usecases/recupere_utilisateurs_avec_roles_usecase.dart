import 'package:cerbere/cerbere.dart';
import 'package:dart_firebase_admin/auth.dart' as admin_auth;
import '../models/cerbere_utilisateur_item.dart';
import '../repositories/cerbere_utilisateur_admin_repository.dart';
import 'recupere_roles_usecase.dart';

/// Usecase pour récupérer les utilisateurs Firebase Auth avec leurs rôles.
/// Les utilisateurs anonymes sont exclus de la liste.
class RecupereUtilisateursAvecRolesUsecase {
  RecupereUtilisateursAvecRolesUsecase({
    required CerbereUtilisateurAdminRepository utilisateurRepository,
    required RecupereRolesUsecase recupereRolesUsecase,
  })  : _utilisateurRepository = utilisateurRepository,
        _recupereRolesUsecase = recupereRolesUsecase;

  final CerbereUtilisateurAdminRepository _utilisateurRepository;
  final RecupereRolesUsecase _recupereRolesUsecase;

  static bool _isAnonymous(admin_auth.UserRecord userRecord) {
    final providers = userRecord.providerData;
    if (providers.isEmpty) return true;
    if (providers.length == 1 &&
        providers.first.providerId == 'anonymous') {
      return true;
    }
    return false;
  }

  Future<RecupereUtilisateursAvecRolesResult> execute() async {
    // Récupère les utilisateurs Firebase Auth via Admin SDK (hors anonymes)
    final allUsers = await _utilisateurRepository.getAllFirebaseUsers();
    final firebaseUsers =
        allUsers.where((u) => !_isAnonymous(u)).toList();

    // Récupère les rôles
    final roles = await _recupereRolesUsecase.execute();

    // Récupère les associations utilisateur-rôle
    final utilisateursAssociations =
        await _utilisateurRepository.getAllUtilisateurs();

    // Crée la liste des utilisateurs avec leurs rôles
    final utilisateursItems = firebaseUsers.map((userRecord) {
      final association = utilisateursAssociations.firstWhere(
        (a) => a.utilisateurUid == userRecord.uid,
        orElse: () => const CerbereUtilisateur(
          utilisateurUid: '',
          roleUid: '',
        ),
      );

      if (association.utilisateurUid.isEmpty || association.roleUid.isEmpty) {
        return CerbereUtilisateurItem(
          uid: userRecord.uid,
          email: userRecord.email ?? '',
          displayName: userRecord.displayName,
          roleUid: null,
          role: null,
          isAdmin: association.isAdmin,
        );
      }

      final role = roles.firstWhere(
        (r) => r.uid == association.roleUid,
        orElse: () => throw StateError('Rôle non trouvé'),
      );

      return CerbereUtilisateurItem(
        uid: userRecord.uid,
        email: userRecord.email ?? '',
        displayName: userRecord.displayName,
        roleUid: association.roleUid,
        role: role,
        isAdmin: association.isAdmin,
      );
    }).toList();

    utilisateursItems.sort(
      (a, b) => a.email.toLowerCase().compareTo(b.email.toLowerCase()),
    );

    return RecupereUtilisateursAvecRolesResult(
      utilisateurs: utilisateursItems,
      roles: roles,
    );
  }
}

/// Résultat de la récupération des utilisateurs avec leurs rôles
class RecupereUtilisateursAvecRolesResult {
  RecupereUtilisateursAvecRolesResult({
    required this.utilisateurs,
    required this.roles,
  });

  final List<CerbereUtilisateurItem> utilisateurs;
  final List<CerbereRole> roles;
}
