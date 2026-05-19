import 'package:flutter/material.dart';

import '../models/snapi_category.dart';
import '../models/space_item.dart';
import '../services/snapi_service.dart';
import 'detail_screen.dart';

class SnapiListScreen extends StatefulWidget {
  const SnapiListScreen({super.key, required this.category});

  final SnapiCategory category;

  @override
  State<SnapiListScreen> createState() => _SnapiListScreenState();
}

class _SnapiListScreenState extends State<SnapiListScreen> {
  final _service = SnapiService();
  late Future<List<SpaceItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchItems(widget.category);
  }

  String _formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    final iso = local.toIso8601String();
    return iso.length >= 10 ? iso.substring(0, 10) : iso;
  }

  void _openDetail(SpaceItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SnapiDetailScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category.title)),
      body: FutureBuilder<List<SpaceItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Gagal memuat data: ${snapshot.error}'),
              ),
            );
          }

          final items = snapshot.data ?? const <SpaceItem>[];
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
        },
      ),
    );
  }
}
