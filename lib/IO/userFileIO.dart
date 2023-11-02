import 'dart:io';
import 'dart:convert';
import 'package:besports_v5/utils/dateUtils.dart';
import 'package:besports_v5/IO/user.dart';
import 'package:path_provider/path_provider.dart';

class UserFileIO {
  Future<void> initializeDefaultUser() async {
    final file = await _localFile;
    if (!await file.exists()) {
      User defaultUser = User.initializeDefault(); // 이런 메서드가 있다고 가정합니다.
      await saveData(defaultUser);
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final userDir = Directory('${directory.path}/user_data');

    // 해당 디렉토리가 없으면 생성합니다.
    if (!await userDir.exists()) {
      await userDir.create();
    }

    return userDir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  // 파일에서 데이터 로드
  Future<User> loadData() async {
    final file = await _localFile;
    if (await file.exists()) {
      String jsonString = await file.readAsString();
      return User.fromJson(json.decode(jsonString));
    } else {
      return User.initializeDefault(); // 파일이 존재하지 않을 때 기본 사용자 반환
    }
  }

  // 데이터를 파일에 저장
  Future<void> saveData(User user) async {
    final file = await _localFile;
    String jsonString = json.encode(user.toJson());
    await file.writeAsString(jsonString);
  }

  // 특정 날짜의 운동 세션 가져오기
  // 사용법: 원하는 날짜를 인자로 전달하여 해당 날짜의 운동 세션 리스트를 가져옴
  // 예: List<ExerciseSession> sessions = fileIO.getExerciseSessionsOn("2023-10-20");
  Future<List<ExerciseSession>> getExerciseSessionsOn(String dateString) async {
    User user = await loadData();
    return user.exerciseRecords[dateString] ?? [];
  }

  // 특정 날짜의 특정 운동 세션에서 사용된 기계의 이름 가져오기
  // 사용법: 원하는 날짜와 세션 인덱스를 인자로 전달
  // 예: String machineName = fileIO.getMachineNameOn("2023-10-20", 0);
  Future<String> getMachineNameOn(String dateString, int sessionIndex) async {
    var sessions = await getExerciseSessionsOn(dateString);
    if (sessionIndex < sessions.length) {
      return sessions[sessionIndex].machineName;
    }
    throw Exception('Session index out of range');
  }

  // 특정 날짜의 특정 운동 세션에서 각 세트의 무게와 카운트 가져오기
  // 사용법: 원하는 날짜와 세션 인덱스를 인자로 전달
  // 예: List<Map<String, int>> weights = fileIO.getWeightToCountOn("2023-10-20", 0);
  Future<List<Map<String, int>>> getWeightToCountOn(
      String dateString, int sessionIndex) async {
    var sessions = await getExerciseSessionsOn(dateString);
    if (sessionIndex < sessions.length) {
      return sessions[sessionIndex].weightToCountPerSet;
    }
    throw Exception('Session index out of range');
  }

  // 특정 날짜에 운동 세션 추가하기
  // 사용법: 추가하려는 날짜와 ExerciseSession 객체를 인자로 전달
  // 예: fileIO.addExerciseSession(DateTime.now(), newSession);
  Future<void> addExerciseSession(
      DateTime date, ExerciseSession session) async {
    User user = await loadData();
    String dateString = dateTimeToString(date); // 날짜를 문자열로 변환
    if (user.exerciseRecords.containsKey(dateString)) {
      user.exerciseRecords[dateString]!.add(session);
    } else {
      user.exerciseRecords[dateString] = [session];
    }
    await saveData(user);
  }

  // 특정 날짜의 특정 운동 세션 수정하기
  // 사용법: 수정하려는 날짜, 세션 인덱스와 수정된 ExerciseSession 객체를 인자로 전달
  // 예: fileIO.updateExerciseSession(DateTime.now(), 0, updatedSession);
  Future<void> updateExerciseSession(
      DateTime date, int sessionIndex, ExerciseSession updatedSession) async {
    User user = await loadData();
    String dateString = dateTimeToString(date);
    if (!user.exerciseRecords.containsKey(dateString) ||
        sessionIndex >= user.exerciseRecords[dateString]!.length) {
      throw Exception('Session not found');
    }
    user.exerciseRecords[dateString]![sessionIndex] = updatedSession;
    await saveData(user);
  }

  // 특정 날짜에 운동 세션들을 추가하기 (여러 개의 세션을 추가하는 경우)
  // 사용법: 추가하려는 날짜와 여러 ExerciseSession 객체의 리스트를 인자로 전달
  // 예: fileIO.pushExerciseSessions(DateTime.now(), [session1, session2]);
  Future<void> pushExerciseSessions(
      DateTime date, List<ExerciseSession> sessions) async {
    User user = await loadData();
    String dateString = dateTimeToString(date); // 날짜를 문자열로 변환

    if (user.exerciseRecords.containsKey(dateString)) {
      user.exerciseRecords[dateString]!.addAll(sessions);
    } else {
      user.exerciseRecords[dateString] = sessions;
    }

    await saveData(user);
  }

  // 특정 날짜에 한 개의 운동 세션을 추가하기
  // 사용법: 추가하려는 날짜와 ExerciseSession 객체를 인자로 전달
  // 예: fileIO.pushExerciseSession(DateTime.now(), newSession);
  Future<void> pushExerciseSession(
      DateTime date, ExerciseSession session) async {
    await pushExerciseSessions(date, [session]); // 위의 메서드를 활용
  }

  // 특정 날짜의 운동 기구 이름을 기준으로 해당 기구로 수행한 전체 세트 수 반환
  // int setsForSeatedRow = fileIO.getTotalSetsForMachineOn("2023-10-20", "시티드로우");
  // print('시티드로우로 수행한 총 세트 수: $setsForSeatedRow');
  Future<int> getTotalSetsForMachineOn(
      String dateString, String machineName) async {
    List<ExerciseSession> sessions = await getExerciseSessionsOn(dateString);

    int totalSets = 0;

    for (var session in sessions) {
      if (session.machineName == machineName) {
        totalSets += session.weightToCountPerSet.length;
      }
    }
    return totalSets;
  }

  Future<String> getExerciseDataAsString(String dateString) async {
    List<ExerciseSession> sessions = await getExerciseSessionsOn(dateString);
    StringBuffer sb = StringBuffer();
    sb.writeln('운동 데이터 - 날짜: $dateString\n');
    for (var session in sessions) {
      sb.writeln('기계 이름: ${session.machineName}');
      for (var set in session.weightToCountPerSet) {
        if (set.keys.isNotEmpty && set.values.isNotEmpty) {
          // 여기를 추가
          sb.writeln('무게: ${set.keys.first}, 횟수: ${set.values.first}');
        }
      }
      sb.writeln('--------------------');
    }
    return sb.toString();
  }
}
