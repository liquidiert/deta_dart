// ignore_for_file: file_names
import 'package:flutter_deta/src/drive/models/pagination.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fileList.g.dart';

@JsonSerializable()
class FileList {
  Pagination paging;
  List<String> names;

  FileList({required this.paging, required this.names});
  factory FileList.fromJson(Map<String, dynamic> json) =>
      _$FileListFromJson(json);
  Map<String, dynamic> toJson() => _$FileListToJson(this);
}
