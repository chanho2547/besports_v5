import 'dart:io';
import 'dart:convert';

class MapFileIO {
  late final String _filePath;
  late Map<String, String> _mapDatastructure;

  MapFileIO([String filePath = 'directory/machinList.json'])
      : _filePath = filePath {
    _loadData(_filePath);
  }

  //dataLoad from filePath=>json
  void _loadData(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      String jsonString = file.readAsStringSync();
      _mapDatastructure = Map<String, String>.from(json.decode(jsonString));
    }
  }

  void _saveData() {
    final file = File(_filePath);
    String jsonString = json.encode(_mapDatastructure);
    file.writeAsStringSync(jsonString);
  }

  void addElement(String key, String value) {
    _mapDatastructure[key] = value;
    _saveData();
  }

  String? keyToValue(String key) {
    return _mapDatastructure[key];
  }
}
