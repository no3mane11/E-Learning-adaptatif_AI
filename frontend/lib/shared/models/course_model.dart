import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
class CourseModel with _$CourseModel {
  const factory CourseModel({
    required String id,
    required String title,
    required String description,
    String? thumbnail,
    required String instructorId,
    String? instructorName,
    @Default([]) List<String> categories,
    @Default(0) int lessonCount,
    @Default(0) int studentCount,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default('beginner') String level,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}



