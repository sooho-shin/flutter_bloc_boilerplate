import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

// •	@JsonSerializable()로 JSON 파싱을 자동화.
// •	build_runner로 todo_model.g.dart 파일을 생성해야 합니다.

// flutter packages pub run build_runner build

@JsonSerializable()
class TodoModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  TodoModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => _$TodoModelFromJson(json);
  Map<String, dynamic> toJson() => _$TodoModelToJson(this);
}