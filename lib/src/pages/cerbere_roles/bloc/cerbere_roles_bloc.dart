import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cerbere/cerbere.dart';
import 'package:cerbere_admin/src/usecases/recupere_stream_liste_roles_usecase.dart';
import 'package:cerbere_admin/src/usecases/supprime_role_usecase.dart';

part 'cerbere_roles_event.dart';
part 'cerbere_roles_state.dart';

/// BLoC pour la gestion des rôles et droits
class CerbereRolesBloc extends Bloc<CerbereRolesEvent, CerbereRolesState> {
  /// {@macro cerbere_roles_bloc}
  CerbereRolesBloc({
    required RecupereStreamListeRolesUsecase recupereStreamListeRolesUsecase,
    required SupprimeRoleUsecase supprimeRoleUsecase,
  }) : _recupereStreamListeRolesUsecase = recupereStreamListeRolesUsecase,
       _supprimeRoleUsecase = supprimeRoleUsecase,
       super(const CerbereRolesState()) {
    on<CerbereRolesInitial>(_onInitial);
    on<CerbereRolesSuppression>(_onSuppression);
  }

  final RecupereStreamListeRolesUsecase _recupereStreamListeRolesUsecase;
  final SupprimeRoleUsecase _supprimeRoleUsecase;

  Future<void> _onInitial(
    CerbereRolesInitial event,
    Emitter<CerbereRolesState> emit,
  ) async {
    emit(state.copyWith(status: CerbereRolesStatus.loading));

    try {
      await emit.forEach(
        _recupereStreamListeRolesUsecase.execute(),
        onData: (data) {
          return state.copyWith(
            roles: data,
            status: CerbereRolesStatus.success,
          );
        },
      );

      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      emit(
        state.copyWith(
          status: CerbereRolesStatus.failure,
          messageError: e is CerbereException
              ? e.message
              : 'Erreur lors du chargement: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSuppression(
    CerbereRolesSuppression event,
    Emitter<CerbereRolesState> emit,
  ) async {
    emit(state.copyWith(status: CerbereRolesStatus.loading));

    try {
      await _supprimeRoleUsecase.execute(
        SupprimeRoleCommand(roleUid: event.uid),
      );

      // Recharge les données
      add(const CerbereRolesInitial());
    } catch (e) {
      emit(
        state.copyWith(
          status: CerbereRolesStatus.failure,
          messageError: e is CerbereException
              ? e.message
              : 'Erreur lors de la suppression du rôle: ${e.toString()}',
        ),
      );
    }
  }
}
