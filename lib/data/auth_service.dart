import 'dummy_data.dart';
import 'models.dart';

/// Hasil percobaan login: [account] terisi bila berhasil, selain itu [error]
/// berisi pesan yang bisa langsung ditampilkan ke pengguna.
class AuthResult {
  const AuthResult.success(AppAccount this.account) : error = null;
  const AuthResult.failure(String this.error) : account = null;

  final AppAccount? account;
  final String? error;

  bool get isSuccess => account != null;
}

/// Autentikasi lokal memakai [dummyAccounts].
///
/// Sengaja dibuat async agar pemanggil tidak perlu diubah ketika
/// implementasinya diganti dengan panggilan ke backend.
class AuthService {
  AuthService._();
  static final instance = AuthService._();

  AppAccount? _current;
  AppAccount? get currentAccount => _current;

  Future<AuthResult> login({
    required LoginRole role,
    required String identifier,
    required String password,
  }) async {
    final id = identifier.trim().toLowerCase();
    AppAccount? match;
    for (final a in dummyAccounts) {
      if (a.email.toLowerCase() == id || a.username.toLowerCase() == id) {
        match = a;
        break;
      }
    }

    if (match == null || match.password != password) {
      return const AuthResult.failure('Email/username atau kata sandi salah.');
    }
    if (match.role != role) {
      return AuthResult.failure(role == LoginRole.admin
          ? 'Akun ini bukan akun Admin Paguyuban.'
          : 'Akun ini bukan akun Pengrajin.');
    }

    _current = match;
    return AuthResult.success(match);
  }

  void logout() => _current = null;
}
