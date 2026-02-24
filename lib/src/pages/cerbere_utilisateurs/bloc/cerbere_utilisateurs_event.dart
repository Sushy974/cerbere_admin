part of 'cerbere_utilisateurs_bloc.dart';

/// Événements pour le BLoC des utilisateurs
sealed class CerbereUtilisateursEvent extends Equatable {
  const CerbereUtilisateursEvent();

  @override
  List<Object> get props => [];
}

/// Événement d'initialisation
final class CerbereUtilisateursInitial extends CerbereUtilisateursEvent {
  const CerbereUtilisateursInitial();
}

/// Événement de rechargement (sans changer le status)
final class CerbereUtilisateursRecharge extends CerbereUtilisateursEvent {
  const CerbereUtilisateursRecharge();
}

/// Événement de changement du critère de recherche par e-mail
final class CerbereUtilisateursRechercheEmailChanged
    extends CerbereUtilisateursEvent {
  const CerbereUtilisateursRechercheEmailChanged(this.rechercheEmail);

  final String rechercheEmail;

  @override
  List<Object> get props => [rechercheEmail];
}

/// Événement de changement de rôle
final class CerbereUtilisateursChangementRole
    extends CerbereUtilisateursEvent {
  const CerbereUtilisateursChangementRole({
    required this.utilisateurUid,
    required this.roleUid,
  });

  final String utilisateurUid;
  final String roleUid;

  @override
  List<Object> get props => [utilisateurUid, roleUid];
}

/// Événement de suppression de rôle
final class CerbereUtilisateursSuppressionRole
    extends CerbereUtilisateursEvent {
  const CerbereUtilisateursSuppressionRole({
    required this.utilisateurUid,
  });

  final String utilisateurUid;

  @override
  List<Object> get props => [utilisateurUid];
}

/// Événement de changement du statut super admin
final class CerbereUtilisateursSuperAdminChanged
    extends CerbereUtilisateursEvent {
  const CerbereUtilisateursSuperAdminChanged({
    required this.utilisateurUid,
    required this.isAdmin,
  });

  final String utilisateurUid;
  final bool isAdmin;

  @override
  List<Object> get props => [utilisateurUid, isAdmin];
}
