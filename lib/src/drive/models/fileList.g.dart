// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fileList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileList _$FileListFromJson(Map<String, dynamic> json) => FileList(
      paging: Pagination.fromJson(json['paging'] as Map<String, dynamic>),
      names: (json['names'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FileListToJson(FileList instance) => <String, dynamic>{
      'paging': instance.paging,
      'names': instance.names,
    };
