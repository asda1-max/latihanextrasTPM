import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/snapi_list_controller.dart';
import '../models/snapi_category.dart';
import '../models/space_item.dart';
import 'detail_screen.dart';

class SnapiListScreen extends StatelessWidget {
  const SnapiListScreen({super.key, required this.category});

  final SnapiCategory category;

  String _formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    final iso = local.toIso8601String();
    return iso.length >= 10 ? iso.substring(0, 10) : iso;
  }

  void _openDetail(SpaceItem item) {
    Get.to(() => SnapiDetailScreen(item: item));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SnapiListController(category: category));

    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final error = controller.errorMessage.value;
        if (error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(error),
            ),
          );
        }

        final items = controller.items;
        if (items.isEmpty) {
          return const Center(child: Text('Tidak ada data.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _openDetail(item),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 96,
                          height: 72,
                          child: item.imageUrl.isEmpty
                              ? Container(color: Colors.black12)
                              : Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(color: Colors.black12);
                                  },
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.newsSite,
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(item.publishedAt),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
