import 'package:broker_app/features/admin/models/user_list_response.dart';
import 'package:broker_app/features/admin/providers/admin_dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserManagementFilter {
  final int page;
  final String? search;
  final String? role;

  UserManagementFilter({this.page = 1, this.search, this.role});

  UserManagementFilter copyWith({int? page, String? search, String? role}) {
    return UserManagementFilter(
      page: page ?? this.page,
      search: search ?? this.search,
      role: role ?? this.role,
    );
  }
}

class UserManagementState {
  final bool isLoading;
  final UserListResponse? data;
  final String? error;
  final UserManagementFilter filter;

  UserManagementState({
    this.isLoading = false,
    this.data,
    this.error,
    required this.filter,
  });
}

class UserManagementNotifier extends StateNotifier<UserManagementState> {
  UserManagementNotifier(this.ref)
    : super(UserManagementState(filter: UserManagementFilter()));

  final Ref ref;

  Future<void> loadUsers() async {
    state = UserManagementState(
      isLoading: true,
      data: state.data,
      filter: state.filter,
    );
    try {
      final repository = ref.read(adminRepositoryProvider);
      final response = await repository.fetchUsers(
        page: state.filter.page,
        search: state.filter.search,
        role: state.filter.role,
      );
      state = UserManagementState(
        data: response,
        filter: state.filter,
        isLoading: false,
      );
    } catch (e) {
      state = UserManagementState(
        error: e.toString(),
        data: state.data,
        filter: state.filter,
        isLoading: false,
      );
    }
  }

  void setFilter(UserManagementFilter filter) {
    state = UserManagementState(
      filter: filter,
      data: state.data,
      isLoading: state.isLoading,
    );
    loadUsers();
  }

  Future<void> updateUserRole(String userId, List<String> roles) async {
    try {
      final repository = ref.read(adminRepositoryProvider);
      await repository.updateUser(userId, {'roles': roles});
      loadUsers(); // Refresh list
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final repository = ref.read(adminRepositoryProvider);
      await repository.deleteUser(userId);
      loadUsers(); // Refresh list
    } catch (e) {
      rethrow;
    }
  }
}

final userManagementProvider =
    StateNotifierProvider<UserManagementNotifier, UserManagementState>((ref) {
      return UserManagementNotifier(ref);
    });
