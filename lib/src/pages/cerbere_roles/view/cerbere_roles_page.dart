import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cerbere/cerbere.dart';
import 'package:cerbere_admin/src/pages/cerbere_roles/bloc/cerbere_roles_bloc.dart';
import 'package:cerbere_admin/src/pages/cerbere_roles/view/cerbere_roles_view.dart';
import 'package:cerbere_admin/src/theme/cerbere_theme.dart';
import 'package:cerbere_admin/src/usecases/recupere_stream_liste_roles_usecase.dart';
import 'package:cerbere_admin/src/usecases/supprime_role_usecase.dart';

/// Page de gestion des rôles et droits (autonome, sans CerbereLayout).
class CerbereRolesPage extends StatelessWidget {
  /// Creates the roles management page.
  ///
  /// {@macro cerbere_roles_page}
  const CerbereRolesPage({super.key});

  /// cerbere_admin_page_unused
  static Page<dynamic> page() => const MaterialPage<dynamic>(
    child: CerbereRolesPage(),
  );

  /// cerbere_admin_route_unused
  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const CerbereRolesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleRepository = context.read<CerbereRoleRepository>();

    return Theme(
      data: CerbereTheme.theme,
      child: BlocProvider(
        create: (context) => CerbereRolesBloc(
          recupereStreamListeRolesUsecase: RecupereStreamListeRolesUsecase(
            roleRepository: roleRepository,
          ),
          supprimeRoleUsecase: SupprimeRoleUsecase(
            roleRepository: roleRepository,
          ),
        )..add(const CerbereRolesInitial()),
        child: const CerbereRolesView(),
      ),
    );
  }
}
