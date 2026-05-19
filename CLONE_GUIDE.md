# Panduan Meniru Aplikasi (Dari Nol)

Dokumen ini berisi langkah cepat untuk membuat ulang aplikasi yang sama dari awal.

## 1) Persiapan
- Install **Flutter SDK** dan **Android Studio**.
- Pastikan perintah berikut sudah bisa dipakai:
  - `flutter --version`
  - `flutter doctor`
- Jika `flutter doctor` menunjukkan masalah Android SDK, buka Android Studio → **SDK Manager** → install **Android SDK Platform** terbaru dan **Android SDK Build-Tools**.
- Pastikan device/emulator tersedia: `flutter devices`.

## 2) Buat Project Baru
```bash
flutter create latihanresponsitpm
cd latihanresponsitpm
```

## 3) Ganti Struktur Folder
Buat folder dan file berikut (atau salin dari proyek contoh):
```
lib/
  main.dart
  models/
    snapi_category.dart
    space_item.dart
  screens/
    app_start_gate.dart
    detail_screen.dart
    home_screen.dart
    list_screen.dart
    login_screen.dart
    register_screen.dart
  services/
    auth_storage.dart
    db_service.dart
    notification_service.dart
    snapi_service.dart
```

## 4) Tambahkan Dependensi
Buka `pubspec.yaml`, lalu tambahkan:
```yaml
dependencies:
  http: ^1.2.2
  url_launcher: ^6.3.1
  sqflite: ^2.4.2+1
  path: ^1.9.1
  flutter_local_notifications: ^17.2.3
  geolocator: ^11.1.0
```

Lalu jalankan:
```bash
flutter pub get
```

### 4.1 Detail sulit: versi dan konflik
- Jika `pub get` gagal karena konflik versi, jalankan `flutter pub outdated` untuk melihat versi yang saling berbenturan.
- Prioritaskan versi yang kompatibel dengan `sdk: ^3.11.0`.
- Hindari menurunkan versi Flutter, lebih aman menyesuaikan versi paket.

## 5) Konfigurasi Android
### 5.1 Tambahkan desugaring di Gradle
Buka `android/app/build.gradle.kts` dan pastikan bagian ini ada:
```kotlin
android {
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
```

**Kenapa perlu ini?** `flutter_local_notifications` membutuhkan fitur Java 8+ di runtime Android. Tanpa desugaring, build akan gagal dengan pesan `checkDebugAarMetadata`.

### 5.2 Tambahkan permission di AndroidManifest
Buka `android/app/src/main/AndroidManifest.xml` lalu tambahkan:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

**Catatan penting**:
- `POST_NOTIFICATIONS` wajib di Android 13+ agar notifikasi muncul.
- Permission lokasi hanya muncul jika `geolocator` dipakai.

### 5.3 Tambahkan ikon notifikasi
Buat file ini:
```
android/app/src/main/res/drawable/ic_notification.xml
```
Dengan isi:
```xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="24dp"
    android:height="24dp"
    android:viewportWidth="24"
    android:viewportHeight="24">
    <path
        android:fillColor="#FFFFFFFF"
        android:pathData="M12,22c1.1,0 2,-0.9 2,-2h-4c0,1.1 0.9,2 2,2zm6,-6V11c0,-3.07 -1.63,-5.64 -4.5,-6.32V4c0,-0.83 -0.67,-1.5 -1.5,-1.5S10.5,3.17 10.5,4v0.68C7.63,5.36 6,7.92 6,11v5l-2,2v1h16v-1l-2,-2z"/>
</vector>
```

**Masalah umum**: Error `invalid_icon` artinya nama icon salah atau file tidak ada.
- Pastikan nama di kode Flutter **sama persis** dengan file drawable (`ic_notification`).
- Jangan pakai `mipmap` untuk notifikasi, gunakan `drawable`.

## 6) Konfigurasi iOS
Buka `ios/Runner/Info.plist`, lalu tambahkan:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi membutuhkan lokasi untuk menampilkan posisi terkini.</string>
```

**Catatan**:
- Untuk iOS, setelah menambah plugin baru jalankan `pod install`:
  ```bash
  cd ios
  pod install
  cd ..
  ```

## 7) Jalankan Aplikasi
```bash
flutter run
```

### 7.1 Detail sulit: LBS tidak keluar
- Pastikan **Location Services** emulator aktif.
- Di emulator Android, atur lokasi lewat **Extended Controls → Location**.
- Jika permission ditolak permanen, hapus aplikasi lalu pasang ulang.

### 7.2 Detail sulit: Notifikasi tidak muncul
- Pastikan izin notifikasi diberikan (Android 13+ akan menampilkan dialog).
- Coba tombol **Notifikasi Cepat** di Home.
- Pastikan aplikasi tidak dibatasi background oleh sistem.

## 8) Catatan Penggunaan
- **Notifikasi lokal**: tersedia tombol “Notifikasi Cepat” di Home dan tombol lonceng di Detail.
- **LBS (Location Based Service)**: tombol “Lokasi Saat Ini” di Home untuk ambil koordinat.

---
Jika ingin saya buatkan file `main.dart` dan semua file lainnya dari nol, beri tahu saya agar saya buatkan otomatis.
