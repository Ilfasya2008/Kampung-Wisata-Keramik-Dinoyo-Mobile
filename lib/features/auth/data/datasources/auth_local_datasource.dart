import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> login(String emailOrUsername, String password);
  Future<UserModel> register(UserModel user);
  Future<UserModel?> getCurrentUser();
  Future<void> saveCurrentUser(UserModel user);
  Future<void> logout();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;
  static const String _usersKey = 'dinoyo_registered_users';
  static const String _currentUserKey = 'dinoyo_current_user_session';

  AuthLocalDataSourceImpl(this.prefs) {
    _ensureSeedUsers();
  }

  void _ensureSeedUsers() {
    final raw = prefs.getStringList(_usersKey);
    if (raw == null || raw.isEmpty) {
      final initialUsers = [
        UserModel(
          id: 'usr_admin_01',
          name: 'Admin Paguyuban',
          email: 'admin@dinoyo.id',
          role: UserRole.admin,
          phone: '081234567890',
          createdAt: DateTime(2024, 1, 1),
          passwordHash: 'admin123',
        ),
        UserModel(
          id: 'usr_artisan_01',
          name: 'Pengrajin Sari Asih',
          email: 'sari@dinoyo.id',
          role: UserRole.artisan,
          phone: '081333444555',
          createdAt: DateTime(2024, 1, 15),
          passwordHash: 'sari123',
        ),
        UserModel(
          id: 'usr_visitor_01',
          name: 'Robbi Pantduro',
          email: 'robbi@student.ac.id',
          role: UserRole.visitor,
          phone: '085777888999',
          createdAt: DateTime(2024, 2, 1),
          passwordHash: 'robbi123',
        ),
      ];

      final encoded = initialUsers.map((u) => jsonEncode(u.toJson())).toList();
      prefs.setStringList(_usersKey, encoded);
    }
  }

  List<UserModel> _getSavedUsers() {
    final raw = prefs.getStringList(_usersKey) ?? [];
    return raw
        .map((str) {
          try {
            return UserModel.fromJson(jsonDecode(str));
          } catch (_) {
            return null;
          }
        })
        .whereType<UserModel>()
        .toList();
  }

  @override
  Future<UserModel> login(String emailOrUsername, String password) async {
    final users = _getSavedUsers();
    final cleanInput = emailOrUsername.trim().toLowerCase();

    final found = users.firstWhere(
      (u) =>
          (u.email.toLowerCase() == cleanInput ||
              u.name.toLowerCase() == cleanInput) &&
          u.passwordHash == password,
      orElse: () => throw StateError('Email/username atau kata sandi salah'),
    );

    await saveCurrentUser(found);
    return found;
  }

  @override
  Future<UserModel> register(UserModel user) async {
    final users = _getSavedUsers();

    if (users.any((u) => u.email.toLowerCase() == user.email.toLowerCase())) {
      throw StateError('Email sudah terdaftar. Silakan masuk atau gunakan email lain.');
    }

    users.add(user);
    final encoded = users.map((u) => jsonEncode(u.toJson())).toList();
    await prefs.setStringList(_usersKey, encoded);

    await saveCurrentUser(user);
    return user;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final str = prefs.getString(_currentUserKey);
    if (str == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(str));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveCurrentUser(UserModel user) async {
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  @override
  Future<void> logout() async {
    await prefs.remove(_currentUserKey);
  }
}
