import 'dart:io';
import 'dart:convert';

import 'package:besports_v5/IO/user.dart';

class UserFileIO {
  final String _filePath;

  UserFileIO([this._filePath = 'directory/userData.json']);

  // 파일에서 데이터 로드
  User loadData() {
    final file = File(_filePath);
    if (file.existsSync()) {
      String jsonString = file.readAsStringSync();
      return User.fromJson(json.decode(jsonString));
    } else {
      throw Exception('File does not exist');
    }
  }

  // 데이터를 파일에 저장
  void saveData(User user) {
    final file = File(_filePath);
    String jsonString = json.encode(user.toJson());
    file.writeAsStringSync(jsonString);
  }
}
