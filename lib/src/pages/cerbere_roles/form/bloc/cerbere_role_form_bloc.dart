import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cerbere/cerbere.dart';
import 'package:cerbere_admin/src/usecases/cree_role_usecase.dart';
import 'package:cerbere_admin/src/usecases/modifie_role_usecase.dart';
import 'package:uuid/uuid.dart';

part 'cerbere_role_form_event.dart';
part 'cerbere_role_form_state.dart';

/// BLoC pour le formulaire de création/modification de rôle
class CerbereRoleFormBloc
    extends Bloc<CerbereRoleFormEvent, CerbereRoleFormState> {
  /// {@macro cerbere_role_form_bloc}
  CerbereRoleFormBloc({
    required CreeRoleUsecase creeRoleUsecase,
    required ModifieRoleUsecase modifieRoleUsecase,
    CerbereRole? role,
    required List<CerbereDroit> droitsDisponibles,
  }) : _creeRoleUsecase = creeRoleUsecase,
       _modifieRoleUsecase = modifieRoleUsecase,
       _roleUid = role?.uid,
       super(
         CerbereRoleFormState(
           droitsDisponibles: droitsDisponibles,
           status: role != null
               ? CerbereRoleFormStatus.modification
               : CerbereRoleFormStatus.initial,
           nom: role?.nom ?? '',
           droitsSelectionnes: role?.droits.toSet() ?? {},
         ),
       ) {
    on<CerbereRoleFormNomChanged>(_onNomChanged);
    on<CerbereRoleFormDroitToggled>(_onDroitToggled);
    on<CerbereRoleFormToggleAllDroits>(_onToggleAllDroits);
    on<CerbereRoleFormSubmitted>(_onSubmitted);
  }

  final CreeRoleUsecase _creeRoleUsecase;
  final ModifieRoleUsecase _modifieRoleUsecase;
  final String? _roleUid;

  void _onNomChanged(
    CerbereRoleFormNomChanged event,
    Emitter<CerbereRoleFormState> emit,
  ) {
    emit(state.copyWith(nom: event.nom));
  }

  void _onDroitToggled(
    CerbereRoleFormDroitToggled event,
    Emitter<CerbereRoleFormState> emit,
  ) {
    final droit = state.droitsDisponibles.firstWhere(
      (d) => d.cle == event.droitCle,
      orElse: () => throw StateError('Droit introuvable: ${event.droitCle}'),
    );

    final nouveauxDroits = Set<String>.from(state.droitsSelectionnes);

    // Si on essaie d'activer un droit lié, vérifier que le parent est activé
    if (droit.cleDroitLie != null) {
      final parentCle = droit.cleDroitLie!;
      if (!nouveauxDroits.contains(parentCle)) {
        // Le parent n'est pas activé, on ne peut pas activer ce droit
        return;
      }
    }

    if (nouveauxDroits.contains(event.droitCle)) {
      // Désactiver le droit et tous ses enfants
      nouveauxDroits.remove(event.droitCle);
      _desactiverDroitsEnfants(event.droitCle, nouveauxDroits);
    } else {
      // Activer le droit (le parent est déjà vérifié)
      nouveauxDroits.add(event.droitCle);
    }

    emit(state.copyWith(droitsSelectionnes: nouveauxDroits));
  }

  /// Désactive récursivement tous les droits enfants d'un droit parent
  void _desactiverDroitsEnfants(
    String parentCle,
    Set<String> droitsSelectionnes,
  ) {
    final droitsEnfants = state.droitsDisponibles
        .where((d) => d.cleDroitLie == parentCle)
        .map((d) => d.cle)
        .toList();

    for (final enfantCle in droitsEnfants) {
      droitsSelectionnes.remove(enfantCle);
      // Désactiver récursivement les enfants de cet enfant
      _desactiverDroitsEnfants(enfantCle, droitsSelectionnes);
    }
  }

  void _onToggleAllDroits(
    CerbereRoleFormToggleAllDroits event,
    Emitter<CerbereRoleFormState> emit,
  ) {
    // Seuls les droits parents (sans cleDroitLie) peuvent être cochés directement
    final droitsParents = state.droitsDisponibles
        .where((d) => d.cleDroitLie == null)
        .map((d) => d.cle)
        .toSet();
    
    final tousParentsCoches = droitsParents.length ==
            state.droitsSelectionnes.length &&
        droitsParents.every((cle) => state.droitsSelectionnes.contains(cle));

    // Si tous les parents sont cochés ou partiellement cochés, on décoche tout
    // Sinon, on coche tous les parents (les enfants seront activables après)
    final nouveauxDroits = tousParentsCoches
        ? <String>{}
        : Set<String>.from(droitsParents);
    emit(state.copyWith(droitsSelectionnes: nouveauxDroits));
  }

  Future<void> _onSubmitted(
    CerbereRoleFormSubmitted event,
    Emitter<CerbereRoleFormState> emit,
  ) async {
    if (!state.isValid) {
      emit(
        state.copyWith(
          status: CerbereRoleFormStatus.failure,
          messageError: 'Le nom du rôle est requis',
        ),
      );
      return;
    }

    emit(state.copyWith(status: CerbereRoleFormStatus.loading));

    try {
      final isModification = state.isModification;
      final roleUid = _roleUid ?? const Uuid().v4();

      final role = CerbereRole(
        uid: roleUid,
        nom: state.nom,
        droits: state.droitsSelectionnes.toList(),
      );

      if (isModification) {
        await _modifieRoleUsecase.execute(ModifieRoleCommand(role: role));
      } else {
        await _creeRoleUsecase.execute(CreeRoleCommand(role: role));
      }

      emit(state.copyWith(status: CerbereRoleFormStatus.success));
    } catch (e) {
      final isModification = state.isModification;
      emit(
        state.copyWith(
          status: CerbereRoleFormStatus.failure,
          messageError: e is CerbereException
              ? e.message
              : 'Erreur lors de ${isModification ? 'la modification' : 'la création'} du rôle: ${e.toString()}',
        ),
      );
    }
  }
}
