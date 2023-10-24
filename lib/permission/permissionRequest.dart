import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequest {
  static Future<Map<Permission, PermissionStatus>> requestPermissions() async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.location,
        Permission.bluetooth,
      ].request();

      return statuses; // 권한 요청 상태를 반환하게 변경
    } catch (e) {
      print('Error requesting permissions: $e');
      return {}; // 오류 시 빈 Map 반환
    }
  }
}

class PermissionService {
  static Future<bool> requestStoragePermission() async {
    try {
      PermissionStatus status = await Permission.storage.request();
      return status.isGranted;
    } catch (e) {
      print('Error requesting storage permission: $e');
      return false; // 오류 시 false 반환
    }
  }
}
