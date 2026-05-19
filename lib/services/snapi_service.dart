import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/snapi_category.dart';
import '../models/space_item.dart';

class SnapiService {
  SnapiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<SpaceItem>> fetchItems(
    SnapiCategory category, {
    int limit = 30,
  }) async {
    final uri = Uri.parse(category.endpoint).replace(
      queryParameters: {
        'limit': '$limit',
      },
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load ${category.title} (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected response format');
    }

    final results = decoded['results'];
    if (results is! List) {
      throw Exception('Missing results');
    }

    return results
        .whereType<Map<String, dynamic>>()
        .map(SpaceItem.fromJson)
        .toList(growable: false);
  }
}
