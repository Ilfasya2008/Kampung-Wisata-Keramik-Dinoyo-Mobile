import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);

  Future<User> execute(String emailOrUsername, String password) async {
    final cleanEmail = emailOrUsername.trim();
    final cleanPass = password.trim();

    if (cleanEmail.isEmpty || cleanPass.isEmpty) {
      throw ArgumentError('Email/username dan kata sandi wajib diisi');
    }
    if (cleanPass.length < 6) {
      throw ArgumentError('Kata sandi minimal 6 karakter');
    }

    return await repository.login(cleanEmail, cleanPass);
  }
}
