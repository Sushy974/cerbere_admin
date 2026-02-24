part of 'cerbere_utilisateurs_bloc.dart';

/// État du BLoC des utilisateurs
class CerbereUtilisateursState extends Equatable {
  const CerbereUtilisateursState({
    this.status = CerbereUtilisateursStatus.initial,
    this.utilisateurs = const [],
    this.roles = const [],
    this.messageError,
    this.rechercheEmail = '',
  });

  final CerbereUtilisateursStatus status;
  final List<CerbereUtilisateurItem> utilisateurs;
  final List<CerbereRole> roles;
  final String? messageError;

  /// Critère de recherche par e-mail (filtre la liste affichée).
  final String rechercheEmail;

  /// Liste des utilisateurs filtrée par [rechercheEmail] (contient si vide).
  List<CerbereUtilisateurItem> get utilisateursFiltres {
    if (rechercheEmail.trim().isEmpty) return utilisateurs;
    final query = rechercheEmail.trim().toLowerCase();
    return utilisateurs
        .where(
          (u) => u.email.toLowerCase().contains(query),
        )
        .toList();
  }

  bool get isLoading => status == CerbereUtilisateursStatus.loading;
  bool get isSuccess => status == CerbereUtilisateursStatus.success;
  bool get isFailure => status == CerbereUtilisateursStatus.failure;

  CerbereUtilisateursState copyWith({
    CerbereUtilisateursStatus? status,
    List<CerbereUtilisateurItem>? utilisateurs,
    List<CerbereRole>? roles,
    String? messageError,
    String? rechercheEmail,
  }) {
    return CerbereUtilisateursState(
      status: status ?? this.status,
      utilisateurs: utilisateurs ?? this.utilisateurs,
      roles: roles ?? this.roles,
      messageError: messageError ?? this.messageError,
      rechercheEmail: rechercheEmail ?? this.rechercheEmail,
    );
  }

  @override
  List<Object?> get props => [status, utilisateurs, roles, messageError, rechercheEmail];
}

/// Statut du BLoC
enum CerbereUtilisateursStatus {
  initial,
  loading,
  success,
  failure,
}
