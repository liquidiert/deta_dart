// ignore_for_file: file_names
import 'package:json_annotation/json_annotation.dart';

part 'GameInfo.g.dart';

@JsonSerializable()
class GameInfo {
  String? key;
  String playerOne;
  String playerTwo;
  int gameStart;

  GameInfo(
      {this.key,
      required this.playerOne,
      required this.playerTwo,
      required this.gameStart});
  factory GameInfo.fromJson(Map<String, dynamic> json) =>
      _$GameInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GameInfoToJson(this);
}
