import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Converts a DateTime object to a string in the format YYYY-MM-DD.
String dateTimeToString(DateTime dt) {
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

String nowToString() {
  DateTime dt = DateTime.now();
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

/// Converts a string in the format YYYY-MM-DD to a DateTime object.
DateTime stringToDateTime(String str) {
  List<String> parts = str.split('-');
  return DateTime(
      int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}

String? recivedDataToRawData(String data) {
  return data.replaceAll("\$r", '').replaceAll(';', '');
}

void numberToKoreanWord(
    int number, int lastNumber, FlutterTts flutterTts) async {
  //_lastNumber = number; // 마지막 번호를 업데이트
  if (number == 0 && lastNumber == 0) {
    // 이전 번호도 0이었으므로 아무것도 하지 않음
  } else {
    try {
      switch (number) {
        case 1:
          await flutterTts.stop();
          await flutterTts.speak("하나");
          break;
        case 2:
          await flutterTts.stop();
          await flutterTts.speak("둘");
          break;
        case 3:
          await flutterTts.stop();
          await flutterTts.speak("셋");
          break;
        case 4:
          await flutterTts.stop();
          await flutterTts.speak("넷");
          break;
        case 5:
          await flutterTts.stop();
          await flutterTts.speak("둘");
          break;
        case 0:
          await flutterTts.stop();
          // 벨소리 재생을 위한 audioplayer
          final player = AudioPlayer();
          player.setVolume(0.4); // 볼륨 설정, 최대 1.0
          player.play(AssetSource('../sounds/bell_sound.mp3')); // 벨소리 재생
          break;
        default:
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }
}
