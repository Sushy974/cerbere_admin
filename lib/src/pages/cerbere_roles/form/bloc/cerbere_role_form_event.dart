part of 'cerbere_role_form_bloc.dart';

/// Événements pour le formulaire de création/modification de rôle
sealed class CerbereRoleFormEvent extends Equatable {
  const CerbereRoleFormEvent();

  @override
  List<Object> get props => [];
}

/// Événement d'initialisation du formulaire
final class CerbereRoleFormInitial extends CerbereRoleFormEvent {
  const CerbereRoleFormInitial({
    this.role,
    required this.droitsDisponibles,
  });

  /// Rôle à modifier (null si création)
  final CerbereRole? role;

  /// Liste des droits disponibles
  final List<CerbereDroit> droitsDisponibles;

  @override
  List<Object> get props => [role ?? '', droitsDisponibles];
}

/// Événement de changement du nom du rôle
final class CerbereRoleFormNomChanged extends CerbereRoleFormEvent {
  const CerbereRoleFormNomChanged(this.nom);

  final String nom;

  @override
  List<Object> get props => [nom];
}

/// Événement de changement de sélection d'un droit
final class CerbereRoleFormDroitToggled extends CerbereRoleFormEvent {
  const CerbereRoleFormDroitToggled(this.droitCle);

  final String droitCle;

  @override
  List<Object> get props => [droitCle];
}

/// Événement pour tout cocher/décocher les droits
final class CerbereRoleFormToggleAllDroits extends CerbereRoleFormEvent {
  const CerbereRoleFormToggleAllDroits();
}

/// Événement de soumission du formulaire
final class CerbereRoleFormSubmitted extends CerbereRoleFormEvent {
  const CerbereRoleFormSubmitted();
}
