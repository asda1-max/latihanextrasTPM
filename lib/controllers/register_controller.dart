import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_storage.dart';

class RegisterController extends GetxController {
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

  Future<void> register() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Register gagal', 'Username dan password wajib diisi');
      return;
    }

    isLoading.value = true;
    try {
      await _auth.register(username: username, password: password);
      Get.snackbar('Register berhasil', 'Silakan login.');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }
}
