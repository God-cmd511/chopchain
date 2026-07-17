import '../models/app_user.dart';

class UserStore {
  static final List<AppUser> users = [
    AppUser(
      id: 'u1',
      name: "Auntie Efua's Chop Bar",
      contact: '024 111 2222',
      location: 'Accra, Nima',
      role: UserRole.chopBar,
    ),
    AppUser(
      id: 'u2',
      name: "Kwame's Fresh Produce",
      contact: '020 333 4444',
      location: 'Kaneshie Market',
      role: UserRole.supplier,
    ),
  ];

  static void addUser(AppUser user) {
    users.add(user);
  }
}
