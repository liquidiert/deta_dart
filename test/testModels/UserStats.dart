// ignore_for_file: file_names
import 'package:json_annotation/json_annotation.dart';

part 'UserStats.g.dart';

@JsonSerializable()
class UserStats {
  String? key;
  int wins;
  int losses;

  UserStats({this.key, required this.wins, required this.losses});
  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
  Map<String, dynamic> toJson() => _$UserStatsToJson(this);
}
