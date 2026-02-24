import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cerbere/cerbere.dart';
import 'package:cerbere_admin/src/pages/cerbere_roles/form/bloc/cerbere_role_form_bloc.dart';

/// Vue du formulaire de création/modification de rôle
class CerbereRoleFormView extends StatelessWidget {
  /// {@macro cerbere_role_form_view}
  const CerbereRoleFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CerbereRoleFormBloc, CerbereRoleFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pop(true);
        }
        if (state.isFailure && state.messageError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.messageError!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<CerbereRoleFormBloc, CerbereRoleFormState>(
        builder: (context, state) {
          return Dialog(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            state.isModification
                                ? CerbereLangueVariable.modifierLeRole.traduction
                                : CerbereLangueVariable.creerUnNouveauRole.traduction,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Content
                  if (state.isLoading)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Champ nom
                              TextFormField(
                                initialValue: state.nom,
                                decoration: InputDecoration(
                                  labelText: CerbereLangueVariable.nomDuRole.traduction,
                                  hintText: CerbereLangueVariable.exempleAdministrateur.traduction,
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  context
                                      .read<CerbereRoleFormBloc>()
                                      .add(CerbereRoleFormNomChanged(value));
                                },
                                enabled: !state.isLoading,
                              ),
                              const SizedBox(height: 24),

                              // Section droits
                              Text(
                                CerbereLangueVariable.droitsAssocies.traduction,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (state.droitsDisponibles.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    CerbereLangueVariable.aucunDroitDisponible.traduction,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              else
                                Builder(
                                  builder: (context) {
                                    // Organiser les droits en arborescence
                                    final droitsParents = state.droitsDisponibles
                                        .where((d) => d.cleDroitLie == null)
                                        .toList();

                                    // Fonction pour obtenir les enfants d'un droit
                                    List<CerbereDroit> getEnfants(String parentCle) {
                                      return state.droitsDisponibles
                                          .where((d) => d.cleDroitLie == parentCle)
                                          .toList();
                                    }

                                    // Fonction pour vérifier si un droit parent est activé
                                    bool isParentActive(String? cleDroitLie) {
                                      if (cleDroitLie == null) return true;
                                      return state.droitsSelectionnes.contains(cleDroitLie);
                                    }

                                    // Calculer l'état de la checkbox "Tout sélectionner"
                                    final droitsParentsCles = droitsParents
                                        .map((d) => d.cle)
                                        .toSet();
                                    final tousParentsCoches = droitsParentsCles.length ==
                                            state.droitsSelectionnes.length &&
                                        droitsParentsCles.every((cle) =>
                                            state.droitsSelectionnes.contains(cle));
                                    final aucunParentCoche = droitsParentsCles.every(
                                        (cle) => !state.droitsSelectionnes.contains(cle));
                                    final triStateValue = tousParentsCoches
                                        ? true
                                        : (aucunParentCoche ? false : null);

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        // Checkbox "Tout sélectionner/désélectionner"
                                        CheckboxListTile(
                                          title: Text(
                                            CerbereLangueVariable.toutSelectionner.traduction,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          value: triStateValue,
                                          tristate: true,
                                          onChanged: state.isLoading
                                              ? null
                                              : (bool? value) {
                                                  context
                                                      .read<CerbereRoleFormBloc>()
                                                      .add(
                                                        const CerbereRoleFormToggleAllDroits(),
                                                      );
                                                },
                                        ),
                                        const Divider(),
                                        // Liste des droits organisés en arborescence
                                        ...droitsParents.expand((droitParent) {
                                          final enfants = getEnfants(droitParent.cle);
                                          final isParentSelected = state.droitsSelectionnes
                                              .contains(droitParent.cle);
                                          
                                          return [
                                            // Droit parent
                                            CheckboxListTile(
                                              title: Text(droitParent.nom),
                                              subtitle: droitParent.description.isNotEmpty
                                                  ? Text(
                                                      droitParent.description,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  : null,
                                              value: isParentSelected,
                                              onChanged: state.isLoading
                                                  ? null
                                                  : (bool? value) {
                                                      context
                                                          .read<CerbereRoleFormBloc>()
                                                          .add(
                                                            CerbereRoleFormDroitToggled(
                                                              droitParent.cle,
                                                            ),
                                                          );
                                                    },
                                            ),
                                            // Droits enfants (indentés)
                                            ...enfants.map((droitEnfant) {
                                              final isEnfantSelected = state.droitsSelectionnes
                                                  .contains(droitEnfant.cle);
                                              final parentActif = isParentActive(
                                                  droitEnfant.cleDroitLie);
                                              
                                              return Padding(
                                                padding: const EdgeInsets.only(left: 16.0),
                                                child: CheckboxListTile(
                                                  title: Text(
                                                    droitEnfant.nom,
                                                    style: TextStyle(
                                                      color: parentActif
                                                          ? null
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                  subtitle: droitEnfant.description.isNotEmpty
                                                      ? Text(
                                                          droitEnfant.description,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: parentActif
                                                                ? Colors.grey
                                                                : Colors.grey.shade400,
                                                          ),
                                                        )
                                                      : null,
                                                  value: isEnfantSelected,
                                                  enabled: parentActif && !state.isLoading,
                                                  onChanged: parentActif && !state.isLoading
                                                      ? (bool? value) {
                                                          context
                                                              .read<CerbereRoleFormBloc>()
                                                              .add(
                                                                CerbereRoleFormDroitToggled(
                                                                  droitEnfant.cle,
                                                                ),
                                                              );
                                                        }
                                                      : null,
                                                ),
                                              );
                                            }),
                                          ];
                                        }),
                                      ],
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  // Footer avec boutons
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(CerbereLangueVariable.annuler.traduction),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: state.isLoading || !state.isValid
                              ? null
                              : () {
                                  context
                                      .read<CerbereRoleFormBloc>()
                                      .add(
                                        const CerbereRoleFormSubmitted(),
                                      );
                                },
                          child: Text(CerbereLangueVariable.enregistrer.traduction),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
