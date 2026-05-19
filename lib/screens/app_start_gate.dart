import 'package:flutter/material.dart';

import '../services/auth_storage.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AppStartGate extends StatefulWidget {
  const AppStartGate({super.key});

  @override
  State<AppStartGate> createState() => _AppStartGateState();
}

class _AppStartGateState extends State<AppStartGate> {
  final _auth = AuthStorage();
  bool _loading = true;
  String? _username;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final username = await _auth.getLoggedInUsername();
      if (!mounted) return;
      setState(() {
        _username = username;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _username = null;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_username != null && _username!.trim().isNotEmpty) {
      return const HomeScreen();
    }

    return const LoginScreen();
  }
}
