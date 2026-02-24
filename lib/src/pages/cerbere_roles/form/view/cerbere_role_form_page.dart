import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cerbere/cerbere.dart';
import 'package:cerbere_admin/src/pages/cerbere_roles/form/bloc/cerbere_role_form_bloc.dart';
import 'package:cerbere_admin/src/usecases/cree_role_usecase.dart';
import 'package:cerbere_admin/src/usecases/modifie_role_usecase.dart';
import 'cerbere_role_form_view.dart';

/// Page du formulaire de création/modification de rôle
class CerbereRoleFormPage extends StatelessWidget {
  /// {@macro cerbere_role_form_page}
  const CerbereRoleFormPage({
    this.role,
    super.key,
  });

  /// Rôle à modifier (null si création)
  final CerbereRole? role;

  @override
  Widget build(BuildContext context) {
    final droitsDisponibles = CerbereDroitsRegistry.all;
    final roleRepository = context.read<CerbereRoleRepository>();

    return BlocProvider(
      create: (context) => CerbereRoleFormBloc(
        creeRoleUsecase: CreeRoleUsecase(roleRepository: roleRepository),
        modifieRoleUsecase: ModifieRoleUsecase(roleRepository: roleRepository),
        role: role,
        droitsDisponibles: droitsDisponibles,
      ),
      child: const CerbereRoleFormView(),
    );
  }
}
