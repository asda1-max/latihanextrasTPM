import 'package:get/get.dart';

import '../services/auth_storage.dart';

class AppStartGateController extends GetxController {
  final AuthStorage _auth = AuthStorage();

  final isLoading = true.obs;
  final username = RxnString();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await _auth.getLoggedInUsername();
      username.value = user;
    } catch (_) {
      username.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
