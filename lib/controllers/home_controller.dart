import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../models/snapi_category.dart';
import '../services/auth_storage.dart';
import '../services/notification_service.dart';
import '../screens/list_screen.dart';
import '../screens/login_screen.dart';

class HomeController extends GetxController {
  final AuthStorage _auth = AuthStorage();
  final NotificationService _notifications = NotificationService.instance;

  final username = RxnString();
  final locationStatus = 'Belum diambil'.obs;
  final locationCoords = RxnString();
  final locating = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final user = await _auth.getLoggedInUsername();
    username.value = user;
  }

  Future<void> logout() async {
    await _auth.clearLoggedInUser();
    Get.offAll(() => const LoginScreen());
  }

  void openCategory(SnapiCategory category) {
    Get.to(() => SnapiListScreen(category: category));
  }

  Future<void> sendQuickNotification() async {
    await _notifications.showSimpleNotification(
      title: 'SpaceFlight News',
      body: 'Siap jelajahi berita terbaru hari ini?',
    );
  }

  Future<void> fetchLocation() async {
    if (locating.value) return;
    locating.value = true;
    locationStatus.value = 'Meminta izin lokasi...';

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locating.value = false;
      locationStatus.value = 'Layanan lokasi tidak aktif';
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      locating.value = false;
      locationStatus.value = 'Izin lokasi ditolak';
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      locating.value = false;
      locationStatus.value = 'Izin lokasi ditolak permanen';
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      locationCoords.value =
          '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
      locationStatus.value = 'Lokasi terbaru';
    } catch (_) {
      locationStatus.value = 'Gagal mengambil lokasi';
    } finally {
      locating.value = false;
    }
  }
}
