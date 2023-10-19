import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final String id;
  Map<DateTime, List<ExerciseSession>> exerciseRecords;

  User({required this.id, required this.exerciseRecords});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
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
