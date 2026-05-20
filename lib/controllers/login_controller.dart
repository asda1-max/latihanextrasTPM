import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_storage.dart';
import '../screens/home_screen.dart';
import '../screens/register_screen.dart';

class LoginController extends GetxController {
  final AuthStorage _auth = AuthStorage();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Login gagal', 'Username dan password wajib diisi');
      return;
    }

    isLoading.value = true;
    try {
      final ok = await _auth.login(username: username, password: password);
      if (ok) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.snackbar('Login gagal', 'Data tidak cocok');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.to(() => const RegisterScreen());
  }
}
