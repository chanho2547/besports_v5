import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String id;
  Map<String, List<ExerciseSession>> exerciseRecords;

  User({required this.id, required this.exerciseRecords});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      exerciseRecords: (json['exerciseRecords'] as Map<String, dynamic>).map(
        (k, v) => MapEntry<String, List<ExerciseSession>>(
            k,
            (v as List)
                .map((e) => ExerciseSession.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);

  // 기본 사용자 생성을 위한 정적 메서드
  static User initializeDefault() {
    return User(
        id: 'defaultID', // 기본 ID 값을 설정합니다.
        exerciseRecords: {} // 빈 운동 기록을 설정합니다.
        );
  }
}

@JsonSerializable()
class ExerciseSession {
  final String machineName;
  List<Map<String, int>> weightToCountPerSet;

  ExerciseSession(
      {required this.machineName, required this.weightToCountPerSet});

  factory ExerciseSession.fromJson(Map<String, dynamic> json) =>
      _$ExerciseSessionFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseSessionToJson(this);
}
