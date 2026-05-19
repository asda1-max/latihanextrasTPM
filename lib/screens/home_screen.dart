import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/snapi_category.dart';
import '../services/auth_storage.dart';
import '../services/notification_service.dart';
import 'list_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = AuthStorage();
  final _notifications = NotificationService.instance;

  String? _username;
  String _locationStatus = 'Belum diambil';
  String? _locationCoords;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final u = await _auth.getLoggedInUsername();
    if (!mounted) return;
    setState(() => _username = u);
  }

  Future<void> _sendQuickNotification() async {
    await _notifications.showSimpleNotification(
      title: 'SpaceFlight News',
      body: 'Siap jelajahi berita terbaru hari ini?',
    );
  }

  Future<void> _fetchLocation() async {
    if (_locating) return;
    setState(() {
      _locating = true;
      _locationStatus = 'Meminta izin lokasi...';
    });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      setState(() {
        _locating = false;
        _locationStatus = 'Layanan lokasi tidak aktif';
      });
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      if (!mounted) return;
      setState(() {
        _locating = false;
        _locationStatus = 'Izin lokasi ditolak';
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      setState(() {
        _locating = false;
        _locationStatus = 'Izin lokasi ditolak permanen';
      });
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      if (!mounted) return;
      setState(() {
        _locating = false;
        _locationCoords =
            '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
        _locationStatus = 'Lokasi terbaru';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locating = false;
        _locationStatus = 'Gagal mengambil lokasi';
      });
    }
  }

  void _openCategory(SnapiCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SnapiListScreen(category: category),
      ),
    );
  }

  Future<void> _logout() async {
    await _auth.clearLoggedInUser();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = _username ?? '...';

    final categories = <SnapiCategory>[
      SnapiCategory.news,
      SnapiCategory.blog,
      SnapiCategory.report,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Hai, $username!'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _logout,
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.my_location),
              title: const Text('Lokasi Saat Ini'),
              subtitle: Text(
                _locationCoords == null
                    ? _locationStatus
                    : '$_locationStatus: $_locationCoords',
              ),
              trailing: _locating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              onTap: _fetchLocation,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text('Notifikasi Cepat'),
              subtitle: const Text('Kirim notifikasi lokal untuk tes'),
              trailing: const Icon(Icons.send),
              onTap: _sendQuickNotification,
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
                onTap: () => _openCategory(category),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
