import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
class SessionModel with _$SessionModel {
  const factory SessionModel({
    required String id,
    required String lessonId,
    required String userId,
    @Default(0) int duration, // en secondes
    @Default({}) Map<String, double> emotionData,
    @Default(0.0) double averageEngagement,
    @Default(0.0) double averageFocus,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? createdAt,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}



