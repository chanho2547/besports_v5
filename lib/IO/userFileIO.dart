import 'dart:io';
import 'dart:convert';
import 'package:besports_v5/utils/dateUtils.dart';
import 'package:besports_v5/IO/user.dart';

class UserFileIO {
  final String _filePath;

  UserFileIO([String filePath = 'directory/userData.json'])
      : _filePath = filePath;

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

  // 특정 날짜의 운동 세션 가져오기
  // 사용법: 원하는 날짜를 인자로 전달하여 해당 날짜의 운동 세션 리스트를 가져옴
  // 예: List<ExerciseSession> sessions = fileIO.getExerciseSessionsOn("2023-10-20");
  List<ExerciseSession> getExerciseSessionsOn(String dateString) {
    User user = loadData();
    return user.exerciseRecords[dateString] ?? [];
  }

  // 특정 날짜의 특정 운동 세션에서 사용된 기계의 이름 가져오기
  // 사용법: 원하는 날짜와 세션 인덱스를 인자로 전달
  // 예: String machineName = fileIO.getMachineNameOn("2023-10-20", 0);
  String getMachineNameOn(String dateString, int sessionIndex) {
    var sessions = getExerciseSessionsOn(dateString);
    if (sessionIndex < sessions.length) {
      return sessions[sessionIndex].machineName;
    }
    throw Exception('Session index out of range');
  }

  // 특정 날짜의 특정 운동 세션에서 각 세트의 무게와 카운트 가져오기
  // 사용법: 원하는 날짜와 세션 인덱스를 인자로 전달
  // 예: List<Map<String, int>> weights = fileIO.getWeightToCountOn("2023-10-20", 0);
  List<Map<String, int>> getWeightToCountOn(
      String dateString, int sessionIndex) {
    var sessions = getExerciseSessionsOn(dateString);
    if (sessionIndex < sessions.length) {
      return sessions[sessionIndex].weightToCountPerSet;
    }
    throw Exception('Session index out of range');
  }

  // 특정 날짜에 운동 세션 추가하기
  // 사용법: 추가하려는 날짜와 ExerciseSession 객체를 인자로 전달
  // 예: fileIO.addExerciseSession(DateTime.now(), newSession);
  void addExerciseSession(DateTime date, ExerciseSession session) {
    User user = loadData();
    String dateString = dateTimeToString(date); // 날짜를 문자열로 변환
    if (user.exerciseRecords.containsKey(dateString)) {
      user.exerciseRecords[dateString]!.add(session);
    } else {
      user.exerciseRecords[dateString] = [session];
    }
    saveData(user);
  }

  // 특정 날짜의 특정 운동 세션 수정하기
  // 사용법: 수정하려는 날짜, 세션 인덱스와 수정된 ExerciseSession 객체를 인자로 전달
  // 예: fileIO.updateExerciseSession(DateTime.now(), 0, updatedSession);
  void updateExerciseSession(
      DateTime date, int sessionIndex, ExerciseSession updatedSession) {
    User user = loadData();
    String dateString = dateTimeToString(date);
    if (!user.exerciseRecords.containsKey(dateString) ||
        sessionIndex >= user.exerciseRecords[dateString]!.length) {
      throw Exception('Session not found');
    }
    user.exerciseRecords[dateString]![sessionIndex] = updatedSession;
    saveData(user);
  }

  // 특정 날짜에 운동 세션들을 추가하기 (여러 개의 세션을 추가하는 경우)
  // 사용법: 추가하려는 날짜와 여러 ExerciseSession 객체의 리스트를 인자로 전달
  // 예: fileIO.pushExerciseSessions(DateTime.now(), [session1, session2]);
  void pushExerciseSessions(DateTime date, List<ExerciseSession> sessions) {
    User user = loadData();
    String dateString = dateTimeToString(date); // 날짜를 문자열로 변환

    if (user.exerciseRecords.containsKey(dateString)) {
      user.exerciseRecords[dateString]!.addAll(sessions);
    } else {
      user.exerciseRecords[dateString] = sessions;
    }

    saveData(user);
  }

  // 특정 날짜에 한 개의 운동 세션을 추가하기
  // 사용법: 추가하려는 날짜와 ExerciseSession 객체를 인자로 전달
  // 예: fileIO.pushExerciseSession(DateTime.now(), newSession);
  void pushExerciseSession(DateTime date, ExerciseSession session) {
    pushExerciseSessions(date, [session]); // 위의 메서드를 활용
  }
}
