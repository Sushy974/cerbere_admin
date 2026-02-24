part of 'cerbere_role_form_bloc.dart';

/// État du formulaire de création/modification de rôle
class CerbereRoleFormState extends Equatable {
  const CerbereRoleFormState({
    this.status = CerbereRoleFormStatus.initial,
    this.nom = '',
    this.droitsSelectionnes = const {},
    this.droitsDisponibles = const [],
    this.messageError,
  });

  final CerbereRoleFormStatus status;
  final String nom;
  final Set<String> droitsSelectionnes;
  final List<CerbereDroit> droitsDisponibles;
  final String? messageError;

  bool get isLoading => status == CerbereRoleFormStatus.loading;
  bool get isSuccess => status == CerbereRoleFormStatus.success;
  bool get isFailure => status == CerbereRoleFormStatus.failure;
  bool get isModification => status == CerbereRoleFormStatus.modification;

  bool get isValid => nom.isNotEmpty;

  CerbereRoleFormState copyWith({
    CerbereRoleFormStatus? status,
    String? nom,
    Set<String>? droitsSelectionnes,
    List<CerbereDroit>? droitsDisponibles,
    String? messageError,
  }) {
    return CerbereRoleFormState(
      status: status ?? this.status,
      nom: nom ?? this.nom,
      droitsSelectionnes: droitsSelectionnes ?? this.droitsSelectionnes,
      droitsDisponibles: droitsDisponibles ?? this.droitsDisponibles,
      messageError: messageError ?? this.messageError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        nom,
        droitsSelectionnes,
        droitsDisponibles,
        messageError,
      ];
}

/// Statut du formulaire
enum CerbereRoleFormStatus {
  initial,
  loading,
  success,
  failure,
  modification,
}
