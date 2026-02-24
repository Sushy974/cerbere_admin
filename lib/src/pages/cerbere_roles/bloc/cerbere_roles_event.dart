part of 'cerbere_roles_bloc.dart';

/// Événements pour le BLoC des rôles
sealed class CerbereRolesEvent extends Equatable {
  const CerbereRolesEvent();

  @override
  List<Object> get props => [];
}

/// Événement d'initialisation
final class CerbereRolesInitial extends CerbereRolesEvent {
  const CerbereRolesInitial();
}

/// Événement de suppression d'un rôle
final class CerbereRolesSuppression extends CerbereRolesEvent {
  const CerbereRolesSuppression({
    required this.uid,
  });

  final String uid;

  @override
  List<Object> get props => [uid];
}
