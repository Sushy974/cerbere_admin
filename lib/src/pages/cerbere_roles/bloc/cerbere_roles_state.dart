// ignore_for_file: public_member_api_docs

part of 'cerbere_roles_bloc.dart';

/// État du BLoC des rôles
class CerbereRolesState extends Equatable {
  const CerbereRolesState({
    this.status = CerbereRolesStatus.initial,
    this.roles = const [],
    this.messageError,
  });

  final CerbereRolesStatus status;
  final List<CerbereRole> roles;
  final String? messageError;

  bool get isLoading => status == CerbereRolesStatus.loading;
  bool get isSuccess => status == CerbereRolesStatus.success;
  bool get isFailure => status == CerbereRolesStatus.failure;

  CerbereRolesState copyWith({
    CerbereRolesStatus? status,
    List<CerbereRole>? roles,
    String? messageError,
  }) {
    return CerbereRolesState(
      status: status ?? this.status,
      roles: roles ?? this.roles,
      messageError: messageError ?? this.messageError,
    );
  }

  @override
  List<Object?> get props => [status, roles, messageError];
}

/// Statut du BLoC
enum CerbereRolesStatus {
  initial,
  loading,
  success,
  failure,
}
