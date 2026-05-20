import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../models/snapi_category.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    final categories = <SnapiCategory>[
      SnapiCategory.news,
      SnapiCategory.blog,
      SnapiCategory.report,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final username = controller.username.value ?? '...';
          return Text('Hai, $username!');
        }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: controller.logout,
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Obx(() {
            final coords = controller.locationCoords.value;
            final status = controller.locationStatus.value;
            final locating = controller.locating.value;
            return Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.my_location),
                title: const Text('Lokasi Saat Ini'),
                subtitle: Text(
                  coords == null ? status : '$status: $coords',
                ),
                trailing: locating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                onTap: controller.fetchLocation,
              ),
            );
          }),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text('Notifikasi Cepat'),
              subtitle: const Text('Kirim notifikasi lokal untuk tes'),
              trailing: const Icon(Icons.send),
              onTap: controller.sendQuickNotification,
            ),
          ),
          const SizedBox(height: 12),
          for (final category in categories) ...[
            Card(
              elevation: 2,
              child: ListTile(
                title: Text(category.title),
                subtitle: Text(category.description),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => controller.openCategory(category),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
