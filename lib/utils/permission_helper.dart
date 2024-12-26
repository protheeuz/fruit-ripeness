import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestPermissions() async {
    // Periksa dan minta izin kamera
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      return false;
    }

    // Periksa dan minta izin penyimpanan
    final storageStatus = await Permission.storage.request();
    if (!storageStatus.isGranted) {
      return false;
    }

    return true; // Semua izin diberikan
  }
}