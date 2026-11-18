import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String emailOrUsername, String password);
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? phone,
  });
  Future<User?> getCurrentUser();
  Future<void> logout();
}
