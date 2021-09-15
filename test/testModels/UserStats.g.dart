// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserStats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStats _$UserStatsFromJson(Map<String, dynamic> json) => UserStats(
      key: json['key'] as String?,
      wins: json['wins'] as int,
      losses: json['losses'] as int,
    );

Map<String, dynamic> _$UserStatsToJson(UserStats instance) => <String, dynamic>{
      'key': instance.key,
      'wins': instance.wins,
      'losses': instance.losses,
    };
