import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/register_user.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final GetCurrentUser getCurrentUser;
  final LogoutUser logoutUser;

  AuthViewModel({
    required this.loginUser,
    required this.registerUser,
    required this.getCurrentUser,
    required this.logoutUser,
  }) {
    initSession();
  }

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> initSession() async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await getCurrentUser.execute();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String emailOrUsername, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      _currentUser = await loginUser.execute(emailOrUsername, password);
      _successMessage = 'Selamat datang, ${_currentUser?.name}!';
      _isLoading = false;
      notifyListeners();
      return true;
    } on ArgumentError catch (e) {
      _errorMessage = e.message?.toString() ?? 'Input tidak valid';
    } on StateError catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat masuk: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      _currentUser = await registerUser.execute(
        name: name,
        email: email,
        password: password,
        role: role,
        phone: phone,
      );
      _successMessage = 'Pendaftaran berhasil! Selamat datang, ${_currentUser?.name}';
      _isLoading = false;
      notifyListeners();
      return true;
    } on ArgumentError catch (e) {
      _errorMessage = e.message?.toString() ?? 'Data pendaftaran tidak valid';
    } on StateError catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Gagal mendaftar: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await logoutUser.execute();
      _currentUser = null;
      _successMessage = 'Berhasil keluar';
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Gagal keluar: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessage() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
