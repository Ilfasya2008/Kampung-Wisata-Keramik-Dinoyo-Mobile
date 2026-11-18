import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;
  RegisterUser(this.repository);

  Future<User> execute({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? phone,
  }) async {
    final cleanName = name.trim();
    final cleanEmail = email.trim();
    final cleanPass = password.trim();

    if (cleanName.isEmpty) {
      throw ArgumentError('Nama lengkap wajib diisi');
    }
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      throw ArgumentError('Format email tidak valid');
    }
    if (cleanPass.length < 6) {
      throw ArgumentError('Kata sandi minimal 6 karakter');
    }

    return await repository.register(
      name: cleanName,
      email: cleanEmail,
      password: cleanPass,
      role: role,
      phone: phone?.trim(),
    );
  }
}
