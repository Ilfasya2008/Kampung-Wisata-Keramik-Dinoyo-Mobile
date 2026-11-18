import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<User> login(String emailOrUsername, String password) async {
    final model = await localDataSource.login(emailOrUsername, password);
    return model.toDomain();
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? phone,
  }) async {
    final newModel = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      role: role,
      phone: phone ?? '',
      createdAt: DateTime.now(),
      passwordHash: password,
    );

    final saved = await localDataSource.register(newModel);
    return saved.toDomain();
  }

  @override
  Future<User?> getCurrentUser() async {
    final model = await localDataSource.getCurrentUser();
    return model?.toDomain();
  }

  @override
  Future<void> logout() async {
    await localDataSource.logout();
  }
}
