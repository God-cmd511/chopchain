enum UserRole { chopBar, supplier }

class AppUser {
  final String id;
  final String name;
  final String contact;
  final String location;
  final UserRole role;

  AppUser({
    required this.id,
    required this.name,
    required this.contact,
    required this.location,
    required this.role,
  });
}
