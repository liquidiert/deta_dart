// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GameInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameInfo _$GameInfoFromJson(Map<String, dynamic> json) => GameInfo(
      key: json['key'] as String?,
      playerOne: json['playerOne'] as String,
      playerTwo: json['playerTwo'] as String,
      gameStart: json['gameStart'] as int,
    );

Map<String, dynamic> _$GameInfoToJson(GameInfo instance) => <String, dynamic>{
      'key': instance.key,
      'playerOne': instance.playerOne,
      'playerTwo': instance.playerTwo,
      'gameStart': instance.gameStart,
    };
