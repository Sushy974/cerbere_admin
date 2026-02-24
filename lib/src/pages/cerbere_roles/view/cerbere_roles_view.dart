import 'package:cerbere/cerbere.dart';
import 'package:cerbere_admin/src/pages/cerbere_roles/bloc/cerbere_roles_bloc.dart';
import 'package:cerbere_admin/src/pages/cerbere_roles/form/view/cerbere_role_form_page.dart';
import 'package:cerbere_admin/src/theme/cerbere_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Vue de gestion des rôles et droits (Scaffold complet : AppBar + body + FAB).
class CerbereRolesView extends StatelessWidget {
  const CerbereRolesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CerbereTheme.background,
      floatingActionButton: _FabAddRole(
        onPressed: () => _navigateToForm(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 56,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  CerbereLangueVariable.titreRoles.traduction,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: CerbereTheme.foreground,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<CerbereRolesBloc, CerbereRolesState>(
                builder: (context, state) {
          if (state.isLoading || state.status == CerbereRolesStatus.initial) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(48),
                child: CircularProgressIndicator(color: CerbereTheme.primary),
              ),
            );
          }

          if (state.isFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: CerbereTheme.mutedForeground,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      CerbereLangueVariable.erreur.traduction,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CerbereTheme.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.messageError ??
                          CerbereLangueVariable.uneErreurEstSurvenue.traduction,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: CerbereTheme.secondaryForeground,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton.icon(
                      onPressed: () {
                        context.read<CerbereRolesBloc>().add(
                              const CerbereRolesInitial(),
                            );
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(CerbereLangueVariable.reessayer.traduction),
                      style: TextButton.styleFrom(
                        foregroundColor: CerbereTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.roles.isEmpty && state.isSuccess) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: CerbereTheme.input,
                        borderRadius:
                            BorderRadius.circular(CerbereTheme.radiusMd),
                        border: Border.all(color: CerbereTheme.border),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        size: 32,
                        color: CerbereTheme.secondaryForeground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      CerbereLangueVariable.aucunRoleMessage.traduction,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CerbereTheme.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CerbereLangueVariable.creezVotrePremierRole.traduction,
                      style: const TextStyle(
                        fontSize: 14,
                        color: CerbereTheme.secondaryForeground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _navigateToForm(context),
                      icon: const Icon(Icons.add, size: 20),
                      label: Text(CerbereLangueVariable.creerUnRole.traduction),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CerbereTheme.primary,
                        foregroundColor: CerbereTheme.primaryForeground,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(CerbereTheme.radiusXl * 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.messageError != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CerbereTheme.destructive.withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(CerbereTheme.radiusMd),
                    border: Border.all(
                      color: CerbereTheme.destructive.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    state.messageError!,
                    style: const TextStyle(
                      color: CerbereTheme.destructive,
                      fontSize: 14,
                    ),
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 8),
                  child: _RolesListCard(roles: state.roles),
                ),
              ),
            ],
          );
        },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToForm(
    BuildContext context, [
    CerbereRole? role,
  ]) async {
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => CerbereRoleFormPage(role: role),
    );
  }
}

class _FabAddRole extends StatelessWidget {
  const _FabAddRole({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: CerbereTheme.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: CerbereTheme.primary,
        foregroundColor: CerbereTheme.primaryForeground,
        icon: const Icon(Icons.add, size: 20),
        label: Text(CerbereLangueVariable.creerUnRole.traduction),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
    );
  }
}

class _RolesListCard extends StatelessWidget {
  const _RolesListCard({required this.roles});

  final List<CerbereRole> roles;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CerbereTheme.card,
        borderRadius: BorderRadius.circular(CerbereTheme.radiusLg),
        border: Border.all(color: CerbereTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: roles.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          color: CerbereTheme.border,
        ),
        itemBuilder: (context, index) {
          final role = roles[index];
          return _RoleRow(
            role: role,
            onTap: () => _navigateToForm(context, role),
            onDelete: () => _showDeleteRoleDialog(context, role.uid, role.nom),
          );
        },
      ),
    );
  }

  void _navigateToForm(BuildContext context, CerbereRole role) {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) => CerbereRoleFormPage(role: role),
    );
  }

  void _showDeleteRoleDialog(
    BuildContext context,
    String roleUid,
    String roleNom,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: CerbereTheme.card,
          title: Text(
            CerbereLangueVariable.supprimerLeRole.traduction,
            style: const TextStyle(color: CerbereTheme.foreground),
          ),
          content: Text(
            '${CerbereLangueVariable.etesVousSurDeVouloirSupprimerLeRole.traduction} "$roleNom" ?',
            style: const TextStyle(color: CerbereTheme.secondaryForeground),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                CerbereLangueVariable.annuler.traduction,
                style: const TextStyle(color: CerbereTheme.primary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<CerbereRolesBloc>().add(
                      CerbereRolesSuppression(uid: roleUid),
                    );
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CerbereTheme.destructive,
                foregroundColor: CerbereTheme.primaryForeground,
              ),
              child: Text(CerbereLangueVariable.supprimer.traduction),
            ),
          ],
        );
      },
    );
  }
}

class _RoleRow extends StatelessWidget {
  const _RoleRow({
    required this.role,
    required this.onTap,
    required this.onDelete,
  });

  final CerbereRole role;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: CerbereTheme.input,
                  borderRadius:
                      BorderRadius.circular(CerbereTheme.radiusMd),
                  border: Border.all(color: CerbereTheme.border),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 20,
                  color: CerbereTheme.foreground,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      role.nom,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: CerbereTheme.foreground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${role.droits.length} ${CerbereLangueVariable.droits.traduction}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: CerbereTheme.secondaryForeground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Material(
                color: CerbereTheme.destructive.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(CerbereTheme.radiusMd),
                child: InkWell(
                  onTap: onDelete,
                  borderRadius:
                      BorderRadius.circular(CerbereTheme.radiusMd),
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(
                      Icons.delete_outlined,
                      size: 18,
                      color: CerbereTheme.destructive,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
