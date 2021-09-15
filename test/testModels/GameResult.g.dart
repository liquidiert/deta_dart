// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GameResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameResult _$GameResultFromJson(Map<String, dynamic> json) => GameResult(
      winnerId: json['winnerId'] as String,
      loserCups: json['loserCups'] as int,
    );

Map<String, dynamic> _$GameResultToJson(GameResult instance) =>
    <String, dynamic>{
      'winnerId': instance.winnerId,
      'loserCups': instance.loserCups,
    };
