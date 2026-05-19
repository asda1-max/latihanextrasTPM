import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/space_item.dart';
import '../services/notification_service.dart';

class SnapiDetailScreen extends StatelessWidget {
  const SnapiDetailScreen({super.key, required this.item});

  final SpaceItem item;

  String _formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    final iso = local.toIso8601String();
    return iso.length >= 10 ? iso.substring(0, 10) : iso;
  }

  Future<void> _openUrl(BuildContext context) async {
    if (item.url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL tidak tersedia')),
      );
      return;
    }

    final uri = Uri.tryParse(item.url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL tidak valid')),
      );
      return;
    }

    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka browser')),
      );
    }
  }

  Future<void> _notify(BuildContext context) async {
    await NotificationService.instance.showSimpleNotification(
      title: 'Artikel pilihan',
      body: item.title,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notifikasi dikirim')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          IconButton(
            tooltip: 'Kirim Notifikasi',
            icon: const Icon(Icons.notifications),
            onPressed: () => _notify(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openUrl(context),
        icon: const Icon(Icons.open_in_new),
        label: const Text('See More'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: item.imageUrl.isEmpty
                    ? Container(color: Colors.black12)
                    : Image.network(
                        item.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: Colors.black12);
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(item.publishedAt),
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item.summary,
                      style: const TextStyle(color: Colors.black87, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
