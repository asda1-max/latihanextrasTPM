import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller.usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onSubmitted: (_) => controller.isLoading.value
                    ? null
                    : controller.login(),
              ),
              const SizedBox(height: 16),
              Obx(() {
                final loading = controller.isLoading.value;
                return ElevatedButton(
                  onPressed: loading ? null : controller.login,
                  child: loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login'),
                );
              }),
              const SizedBox(height: 8),
              Obx(() {
                final loading = controller.isLoading.value;
                return TextButton(
                  onPressed: loading ? null : controller.goToRegister,
                  child: const Text('Belum punya akun? Register'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
