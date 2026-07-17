import 'package:flutter/material.dart';
import '../models/app_user.dart';

class DashboardScreen extends StatelessWidget {
  final AppUser user;

  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome, ${user.name}')),
      body: Center(
        child: Text(
          'You are signed in as a ${user.role.name}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
