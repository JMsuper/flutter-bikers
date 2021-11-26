import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> checkIosPhotoPermission() async {
    var status = Permission.photos.status.isGranted;
    return status;
  }

  static Future<bool> checkAndroidPhotoPermission() async {
    var status = await Permission.storage.status.isGranted;
    return status;
  }

  static Future<bool> checkCameraPermission() async {
    var storage = Permission.camera;
    var status = await storage.status;
    return status.isGranted;
  }
}
