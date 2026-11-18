enum UserRole { admin, artisan, visitor }

extension UserRoleX on UserRole {
  String get label => switch (this) {
        UserRole.admin => 'Admin Paguyuban',
        UserRole.artisan => 'Pengrajin',
        UserRole.visitor => 'Wisatawan / Pengunjung',
      };

  static UserRole fromString(String? val) {
    switch (val?.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'artisan':
      case 'pengrajin':
        return UserRole.artisan;
      default:
        return UserRole.visitor;
    }
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String phone;
  final String? avatarUrl;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone = '',
    this.avatarUrl,
    required this.createdAt,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isArtisan => role == UserRole.artisan;
  bool get isVisitor => role == UserRole.visitor;
}
