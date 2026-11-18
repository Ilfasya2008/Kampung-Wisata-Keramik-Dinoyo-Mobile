import '../../domain/entities/user.dart';

class UserModel extends User {
  final String passwordHash;

  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.phone,
    super.avatarUrl,
    required super.createdAt,
    required this.passwordHash,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role.name,
        'phone': phone,
        'avatarUrl': avatarUrl,
        'createdAt': createdAt.toIso8601String(),
        'passwordHash': passwordHash,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        role: UserRoleX.fromString(json['role']),
        phone: json['phone'] ?? '',
        avatarUrl: json['avatarUrl'],
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        passwordHash: json['passwordHash'] ?? '',
      );

  User toDomain() => User(
        id: id,
        name: name,
        email: email,
        role: role,
        phone: phone,
        avatarUrl: avatarUrl,
        createdAt: createdAt,
      );
}
