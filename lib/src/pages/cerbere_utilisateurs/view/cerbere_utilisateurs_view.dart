import 'package:cerbere/cerbere.dart';
import 'package:cerbere_admin/src/models/cerbere_utilisateur_item.dart';
import 'package:cerbere_admin/src/pages/cerbere_utilisateurs/bloc/cerbere_utilisateurs_bloc.dart';
import 'package:cerbere_admin/src/theme/cerbere_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page Utilisateurs Cerbère : Scaffold complet (AppBar + body) avec padding manuel.
class CerbereUtilisateursView extends StatelessWidget {
  const CerbereUtilisateursView({
    super.key,
    this.colonneNom = false,
  });

  final bool colonneNom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CerbereTheme.background,
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
                  CerbereLangueVariable.titreUtilisateurs.traduction,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: CerbereTheme.foreground,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<CerbereUtilisateursBloc, CerbereUtilisateursState>(
                builder: (context, state) {
        if (state.isLoading) {
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
                      context.read<CerbereUtilisateursBloc>().add(
                            const CerbereUtilisateursInitial(),
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

        if (state.utilisateurs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                CerbereLangueVariable.aucunUtilisateurTrouve.traduction,
                style: const TextStyle(
                  fontSize: 15,
                  color: CerbereTheme.secondaryForeground,
                ),
              ),
            ),
          );
        }

        final utilisateursFiltres = state.utilisateursFiltres;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.messageError != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CerbereTheme.destructive.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(CerbereTheme.radiusMd),
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
            _SearchSection(
              query: state.rechercheEmail,
              onChanged: (value) {
                context.read<CerbereUtilisateursBloc>().add(
                      CerbereUtilisateursRechercheEmailChanged(value),
                    );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (utilisateursFiltres.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          CerbereLangueVariable.aucunNeCorrespondRecherche.traduction,
                          style: const TextStyle(
                            fontSize: 14,
                            color: CerbereTheme.secondaryForeground,
                          ),
                        ),
                      )
                    else
                      _UsersList(
                        utilisateurs: utilisateursFiltres,
                        roles: state.roles,
                        colonneNom: colonneNom,
                      ),
                  ],
                ),
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
}

class _SearchSection extends StatefulWidget {
  const _SearchSection({
    required this.query,
    required this.onChanged,
  });

  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<_SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<_SearchSection> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(_SearchSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.text = widget.query;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          CerbereLangueVariable.filtrerUtilisateurs.traduction,
          style: const TextStyle(
            fontSize: 13,
            color: CerbereTheme.secondaryForeground,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: CerbereTheme.input,
            borderRadius: BorderRadius.circular(CerbereTheme.radiusLg),
            border: Border.all(color: CerbereTheme.border),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  Icons.search,
                  size: 20,
                  color: CerbereTheme.secondaryForeground,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onChanged,
                  style: const TextStyle(
                    color: CerbereTheme.foreground,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: CerbereLangueVariable.rechercherParEmail.traduction,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              if (widget.query.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => widget.onChanged(''),
                  color: CerbereTheme.secondaryForeground,
                  style: IconButton.styleFrom(
                    minimumSize: const Size(24, 24),
                    padding: EdgeInsets.zero,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UsersList extends StatelessWidget {
  const _UsersList({
    required this.utilisateurs,
    required this.roles,
    this.colonneNom = false,
  });

  final List<CerbereUtilisateurItem> utilisateurs;
  final List<CerbereRole> roles;
  final bool colonneNom;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CerbereTheme.card,
        borderRadius: BorderRadius.circular(CerbereTheme.radiusLg),
        border: Border.all(color: CerbereTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < utilisateurs.length; i++) ...[
            _UserRow(
              utilisateur: utilisateurs[i],
              roles: roles,
              colonneNom: colonneNom,
            ),
            if (i < utilisateurs.length - 1)
              const Divider(height: 1, color: CerbereTheme.border),
          ],
        ],
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.utilisateur,
    required this.roles,
    this.colonneNom = false,
  });

  final CerbereUtilisateurItem utilisateur;
  final List<CerbereRole> roles;
  final bool colonneNom;

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = utilisateur.roleUid == null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  utilisateur.email,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: CerbereTheme.foreground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (colonneNom && utilisateur.displayName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    utilisateur.displayName!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: CerbereTheme.secondaryForeground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      CerbereLangueVariable.superAdmin.traduction,
                      style: const TextStyle(
                        fontSize: 13,
                        color: CerbereTheme.secondaryForeground,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: utilisateur.isAdmin,
                      onChanged: (value) {
                        context.read<CerbereUtilisateursBloc>().add(
                              CerbereUtilisateursSuperAdminChanged(
                                utilisateurUid: utilisateur.uid,
                                isAdmin: value,
                              ),
                            );
                      },
                      activeColor: CerbereTheme.primary,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 160,
                height: 36,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: utilisateur.roleUid,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(CerbereTheme.radiusMd),
                    dropdownColor: CerbereTheme.card,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isPlaceholder
                          ? CerbereTheme.mutedForeground
                          : CerbereTheme.foreground,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: CerbereTheme.secondaryForeground,
                    ),
                    items: [
                      DropdownMenuItem<String?>(
                        value: null,
                        child: Text(
                          CerbereLangueVariable.aucunRole.traduction,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      ...roles.map(
                        (CerbereRole r) => DropdownMenuItem<String?>(
                          value: r.uid,
                          child: Text(
                            r.nom,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (String? newRoleUid) {
                      if (newRoleUid == null) {
                        context.read<CerbereUtilisateursBloc>().add(
                              CerbereUtilisateursSuppressionRole(
                                utilisateurUid: utilisateur.uid,
                              ),
                            );
                      } else {
                        context.read<CerbereUtilisateursBloc>().add(
                              CerbereUtilisateursChangementRole(
                                utilisateurUid: utilisateur.uid,
                                roleUid: newRoleUid,
                              ),
                            );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
