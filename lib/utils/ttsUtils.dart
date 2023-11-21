import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

Future<void> numberToKoreanWord(int number, int lastNumber,
    FlutterTts flutterTts, Duration difference, int set) async {
  //_lastNumber = number; // 마지막 번호를 업데이트
  if (number == 0 && lastNumber == 0) {
    // 이전 번호도 0이었으므로 아무것도 하지 않음
  } else {
    try {
      if (number == 4) {
        await flutterTts.stop();
        await flutterTts.speak("마지막 하나");
      } else if (number == 5) {
        await flutterTts.stop();
        await flutterTts.speak("$set세트 종료 setRest시작");
      } else if (difference.inSeconds < 2.3 && number != 1) {
        // 너무 빠른 경우
        await flutterTts.stop();
        await flutterTts.speak("너무 빠릅니다. 천천히 하세요.");
      } else if (difference.inSeconds > 3.5 && number != 1) {
        // 너무 느린 경우
        await flutterTts.stop();
        await flutterTts.speak("너무 느립니다. 속도를 높이세요.");
      } else {
        await numberToTts(number, lastNumber, flutterTts);
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }
}

Future<void> numberToTts(
  int number,
  int lastNumber,
  FlutterTts flutterTts,
) async {
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
      await flutterTts.speak("다섯");
      break;
    case 6:
      await flutterTts.stop();
      await flutterTts.speak("여섯");
      break;
    case 7:
      await flutterTts.stop();
      await flutterTts.speak("일곱");
      break;
    case 8:
      await flutterTts.stop();
      await flutterTts.speak("여덟");
      break;
    case 9:
      await flutterTts.stop();
      await flutterTts.speak("아홉");
      break;
    case 10:
      await flutterTts.stop();
      await flutterTts.speak("열");
      break;
    case 11:
      await flutterTts.stop();
      await flutterTts.speak("열하나");
      break;
    case 12:
      await flutterTts.stop();
      await flutterTts.speak("열둘");
      break;
    case 13:
      await flutterTts.stop();
      await flutterTts.speak("열셋");
      break;
    case 14:
      await flutterTts.stop();
      await flutterTts.speak("열넷");
      break;
    case 15:
      await flutterTts.stop();
      await flutterTts.speak("열다섯");
      break;
    case 16:
      await flutterTts.stop();
      await flutterTts.speak("열여섯");
      break;
    case 17:
      await flutterTts.stop();
      await flutterTts.speak("열일곱");
      break;
    case 18:
      await flutterTts.stop();
      await flutterTts.speak("열여덟");
      break;
    case 19:
      await flutterTts.stop();
      await flutterTts.speak("열아홉");
      break;
    case 20:
      await flutterTts.stop();
      await flutterTts.speak("스물");
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
}
