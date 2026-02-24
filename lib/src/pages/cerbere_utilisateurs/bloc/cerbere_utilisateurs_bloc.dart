import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cerbere/cerbere.dart';
import '../../../models/cerbere_utilisateur_item.dart';
import '../../../usecases/assigne_role_utilisateur_usecase.dart';
import '../../../usecases/met_a_jour_super_admin_usecase.dart';
import '../../../usecases/recupere_utilisateurs_avec_roles_usecase.dart';
import '../../../usecases/supprime_role_utilisateur_usecase.dart';

part 'cerbere_utilisateurs_event.dart';
part 'cerbere_utilisateurs_state.dart';

/// BLoC pour la gestion des utilisateurs et leurs rôles
class CerbereUtilisateursBloc
    extends Bloc<CerbereUtilisateursEvent, CerbereUtilisateursState> {
  /// {@macro cerbere_utilisateurs_bloc}
  CerbereUtilisateursBloc({
    required RecupereUtilisateursAvecRolesUsecase
    recupereUtilisateursAvecRolesUsecase,
    required AssigneRoleUtilisateurUsecase assigneRoleUtilisateurUsecase,
    required SupprimeRoleUtilisateurUsecase supprimeRoleUtilisateurUsecase,
    required MetAJourSuperAdminUsecase metAJourSuperAdminUsecase,
  }) : _recupereUtilisateursAvecRolesUsecase =
           recupereUtilisateursAvecRolesUsecase,
       _assigneRoleUtilisateurUsecase = assigneRoleUtilisateurUsecase,
       _supprimeRoleUtilisateurUsecase = supprimeRoleUtilisateurUsecase,
       _metAJourSuperAdminUsecase = metAJourSuperAdminUsecase,
       super(const CerbereUtilisateursState()) {
    on<CerbereUtilisateursInitial>(_onInitial);
    on<CerbereUtilisateursRecharge>(_onRecharge);
    on<CerbereUtilisateursRechercheEmailChanged>(_onRechercheEmailChanged);
    on<CerbereUtilisateursChangementRole>(_onChangementRole);
    on<CerbereUtilisateursSuppressionRole>(_onSuppressionRole);
    on<CerbereUtilisateursSuperAdminChanged>(_onSuperAdminChanged);
  }

  void _onRechercheEmailChanged(
    CerbereUtilisateursRechercheEmailChanged event,
    Emitter<CerbereUtilisateursState> emit,
  ) {
    emit(state.copyWith(rechercheEmail: event.rechercheEmail));
  }

  final RecupereUtilisateursAvecRolesUsecase
  _recupereUtilisateursAvecRolesUsecase;
  final AssigneRoleUtilisateurUsecase _assigneRoleUtilisateurUsecase;
  final SupprimeRoleUtilisateurUsecase _supprimeRoleUtilisateurUsecase;
  final MetAJourSuperAdminUsecase _metAJourSuperAdminUsecase;

  Future<void> _onInitial(
    CerbereUtilisateursInitial event,
    Emitter<CerbereUtilisateursState> emit,
  ) async {
    emit(state.copyWith(status: CerbereUtilisateursStatus.loading));

    try {
      final result = await _recupereUtilisateursAvecRolesUsecase.execute();

      emit(
        state.copyWith(
          status: CerbereUtilisateursStatus.success,
          utilisateurs: result.utilisateurs,
          roles: result.roles,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CerbereUtilisateursStatus.failure,
          messageError: e is CerbereException
              ? e.message
              : 'Erreur lors du chargement: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRecharge(
    CerbereUtilisateursRecharge event,
    Emitter<CerbereUtilisateursState> emit,
  ) async {
    try {
      final result = await _recupereUtilisateursAvecRolesUsecase.execute();

      emit(
        state.copyWith(
          utilisateurs: result.utilisateurs,
          roles: result.roles,
          messageError: null, // Efface les erreurs précédentes
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          messageError: e is CerbereException
              ? e.message
              : 'Erreur lors du rechargement: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onChangementRole(
    CerbereUtilisateursChangementRole event,
    Emitter<CerbereUtilisateursState> emit,
  ) async {
    try {
      await _assigneRoleUtilisateurUsecase.execute(
        AssigneRoleUtilisateurCommand(
          utilisateurUid: event.utilisateurUid,
          roleUid: event.roleUid,
        ),
      );

      // Recharge les données sans afficher le loading
      add(const CerbereUtilisateursRecharge());
    } catch (e) {
      emit(
        state.copyWith(
          status: CerbereUtilisateursStatus.failure,
          messageError: e is CerbereException
              ? e.message
              : 'Erreur lors du changement de rôle: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSuppressionRole(
    CerbereUtilisateursSuppressionRole event,
    Emitter<CerbereUtilisateursState> emit,
  ) async {
    try {
      await _supprimeRoleUtilisateurUsecase.execute(
        SupprimeRoleUtilisateurCommand(
          utilisateurUid: event.utilisateurUid,
        ),
      );

      add(const CerbereUtilisateursRecharge());
    } catch (e) {
      emit(
        state.copyWith(
          status: CerbereUtilisateursStatus.failure,
          messageError: e is CerbereException
              ? e.message
              : 'Erreur lors de la suppression du rôle: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSuperAdminChanged(
    CerbereUtilisateursSuperAdminChanged event,
    Emitter<CerbereUtilisateursState> emit,
  ) async {
    try {
      await _metAJourSuperAdminUsecase.execute(
        event.utilisateurUid,
        event.isAdmin,
      );

      add(const CerbereUtilisateursRecharge());
    } catch (e) {
      emit(
        state.copyWith(
          status: CerbereUtilisateursStatus.failure,
          messageError: e is CerbereException
              ? e.message
              : 'Erreur lors de la mise à jour du statut super admin: ${e.toString()}',
        ),
      );
    }
  }
}
