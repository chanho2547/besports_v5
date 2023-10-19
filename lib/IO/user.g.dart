// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      exerciseRecords: (json['exerciseRecords'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            DateTime.parse(k),
            (e as List<dynamic>)
                .map((e) => ExerciseSession.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'exerciseRecords': instance.exerciseRecords.map((k, e) =>
          MapEntry(k.toIso8601String(), e.map((e) => e.toJson()).toList())),
    };

ExerciseSession _$ExerciseSessionFromJson(Map<String, dynamic> json) =>
    ExerciseSession(
      machineName: json['machineName'] as String,
      weightToCountPerSet: (json['weightToCountPerSet'] as List<dynamic>)
          .map((e) => Map<String, int>.from(e as Map))
          .toList(),
    );

Map<String, dynamic> _$ExerciseSessionToJson(ExerciseSession instance) =>
    <String, dynamic>{
      'machineName': instance.machineName,
      'weightToCountPerSet': instance.weightToCountPerSet,
    };
