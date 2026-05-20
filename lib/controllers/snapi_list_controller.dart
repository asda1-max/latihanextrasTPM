import 'package:get/get.dart';

import '../models/snapi_category.dart';
import '../models/space_item.dart';
import '../services/snapi_service.dart';

class SnapiListController extends GetxController {
  SnapiListController({required this.category});

  final SnapiCategory category;
  final SnapiService _service = SnapiService();

  final isLoading = true.obs;
  final errorMessage = RxnString();
  final items = <SpaceItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _service.fetchItems(category);
      items.assignAll(data);
    } catch (e) {
      errorMessage.value = 'Gagal memuat data: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
