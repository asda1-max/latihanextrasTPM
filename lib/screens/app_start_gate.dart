import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/app_start_gate_controller.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AppStartGate extends StatelessWidget {
  const AppStartGate({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppStartGateController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final username = controller.username.value;
      if (username != null && username.trim().isNotEmpty) {
        return const HomeScreen();
      }

      return const LoginScreen();
    });
  }
}
