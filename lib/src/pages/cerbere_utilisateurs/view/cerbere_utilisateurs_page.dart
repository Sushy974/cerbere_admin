import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cerbere/cerbere.dart';
import 'package:cerbere_admin/src/pages/cerbere_utilisateurs/bloc/cerbere_utilisateurs_bloc.dart';
import 'package:cerbere_admin/src/repositories/cerbere_utilisateur_admin_repository.dart';
import 'package:cerbere_admin/src/theme/cerbere_theme.dart';
import 'package:cerbere_admin/src/usecases/assigne_role_utilisateur_usecase.dart';
import 'package:cerbere_admin/src/usecases/met_a_jour_super_admin_usecase.dart';
import 'package:cerbere_admin/src/usecases/recupere_roles_usecase.dart';
import 'package:cerbere_admin/src/usecases/recupere_utilisateurs_avec_roles_usecase.dart';
import 'package:cerbere_admin/src/usecases/supprime_role_utilisateur_usecase.dart';
import 'cerbere_utilisateurs_view.dart';

/// Page de gestion des utilisateurs et leurs rôles
class CerbereUtilisateursPage extends StatelessWidget {
  /// {@macro cerbere_utilisateurs_page}
  const CerbereUtilisateursPage({
    super.key,
    this.colonneNom = false,
  });

  /// Affiche ou non la colonne nom (par défaut false)
  final bool colonneNom;

  static Page<dynamic> page() => const MaterialPage<dynamic>(
    child: CerbereUtilisateursPage(),
  );

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const CerbereUtilisateursPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final utilisateurRepository = context
        .read<CerbereUtilisateurAdminRepository>();
    final roleRepository = context.read<CerbereRoleRepository>();

    return Theme(
      data: CerbereTheme.theme,
      child: BlocProvider(
        create: (context) => CerbereUtilisateursBloc(
          recupereUtilisateursAvecRolesUsecase:
              RecupereUtilisateursAvecRolesUsecase(
                utilisateurRepository: utilisateurRepository,
                recupereRolesUsecase: RecupereRolesUsecase(
                  roleRepository: roleRepository,
                ),
              ),
          assigneRoleUtilisateurUsecase: AssigneRoleUtilisateurUsecase(
            utilisateurRepository: utilisateurRepository,
          ),
          supprimeRoleUtilisateurUsecase: SupprimeRoleUtilisateurUsecase(
            utilisateurRepository: utilisateurRepository,
          ),
          metAJourSuperAdminUsecase: MetAJourSuperAdminUsecase(
            utilisateurRepository: utilisateurRepository,
          ),
        )..add(const CerbereUtilisateursInitial()),
        child: CerbereUtilisateursView(colonneNom: colonneNom),
      ),
    );
  }
}
