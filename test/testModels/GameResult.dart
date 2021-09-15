// ignore_for_file: file_names
import 'package:json_annotation/json_annotation.dart';

part 'GameResult.g.dart';

@JsonSerializable()
class GameResult {
  String winnerId;
  int loserCups;

  GameResult({required this.winnerId, required this.loserCups});
  factory GameResult.fromJson(Map<String, dynamic> json) =>
      _$GameResultFromJson(json);
  Map<String, dynamic> toJson() => _$GameResultToJson(this);
}
