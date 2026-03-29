import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider((ref) {
  return AuthService();
});

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return CurrentUserNotifier(authService);
});

class CurrentUserNotifier extends StateNotifier<User?> {
  final AuthService _authService;

  CurrentUserNotifier(this._authService) : super(_authService.currentUser);

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final success = await _authService.register(
      email: email,
      password: password,
      name: name,
    );
    
    if (success) {
      state = _authService.currentUser;
    }
    return success;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final success = await _authService.login(
      email: email,
      password: password,
    );
    
    if (success) {
      state = _authService.currentUser;
    }
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    state = null;
  }

  Future<bool> deleteAccount(String password) async {
    final success = await _authService.deleteAccount(password);
    if (success) {
      state = null;
    }
    return success;
  }
}
