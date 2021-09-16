import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_deta/src/drive/models/fileList.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class DetaDrive {
  late final String _projectKey;
  late final String _projectId;

  static final DetaDrive _instance = DetaDrive._internal();
  static DetaDrive get instance => _instance;

  DetaDrive._internal();

  factory DetaDrive() => _instance;

  init({required String projectId, required String projectKey}) {
    _projectId = projectId;
    _projectKey = projectKey;
  }

  get _baseUrl => "https://drive.deta.sh/v1/$_projectId";
  get _defaultHeaders => {"X-API-Key": _projectKey};

  _checkForCreds() {
    // ignore: unnecessary_null_comparison
    if (_projectId == null && _projectKey == null) {
      throw ArgumentError(
          "ProjectID and ProjectKey must not be null! Did you call DetaBase.init(id, key)?");
    }
  }

  uploadSmallFile(String drive, String name, Uint8List file) async {
    _checkForCreds();
    final fileLength = file.length;
    if (fileLength > 10485760) {
      throw ArgumentError.value(fileLength, "file",
          "Files mustn't be larger than 10MB. Please use chunkedUpload for large files.");
    }
    return jsonDecode((await http.post(
            Uri.parse("$_baseUrl/$drive/files?name=$name"),
            body: file,
            headers: _defaultHeaders))
        .body);
  }

  Stream chunkedUpload(String drive, String name, Uint8List file) async* {
    _checkForCreds();
    final fileLength = file.length;
    if (fileLength <= 10485760) {
      // ignore: avoid_print
      developer.log(
          "WARNING: this File is smaller than 10MB, you could use uploadSmallFile for those. I will do that for you :)");
      yield await uploadSmallFile(drive, name, file);
      return;
    }
    final initResp = jsonDecode((await http.post(
            Uri.parse("$_baseUrl/$drive/uploads?name=$name"),
            headers: _defaultHeaders))
        .body);
    final numPackages = (file.length / 5242880).truncate();
    try {
      for (int i = 0; i < numPackages + 1; i++) {
        var bytes = i != numPackages
            ? file.getRange(i * 5242880, (i + 1) * 5242880)
            : file.getRange(i * 5242880, file.lengthInBytes);
        yield jsonDecode((await http.post(
                Uri.parse(
                    "$_baseUrl/$drive/uploads/${initResp["upload_id"]}/parts?name=$name&part=${i + 1}"),
                body: Uint8List.fromList(List.from(bytes)),
                headers: _defaultHeaders))
            .body);
      }
    } catch (ex) {
      // something went wrong; abort upload
      await http.delete(
          Uri.parse(
              "$_baseUrl/$drive/uploads/${initResp["upload_id"]}?name=$name"),
          headers: _defaultHeaders);
      throw Exception("Failed to upload file $name: $ex");
    }
    yield jsonDecode((await http.patch(
            Uri.parse(
                "$_baseUrl/$drive/uploads/${initResp["upload_id"]}?name=$name"),
            headers: _defaultHeaders))
        .body);
  }

  Future<Uint8List> downloadFile(String drive, String name) async {
    _checkForCreds();
    return Uint8List.fromList((await http.get(
            Uri.parse("$_baseUrl/$drive/files/download?name=$name"),
            headers: _defaultHeaders))
        .bodyBytes);
  }

  Future<FileList> listFiles(String drive,
      {int limit = 100, String? prefix, String? lastName}) async {
    _checkForCreds();
    var resp = await http.get(
        Uri.parse(
            "$_baseUrl/$drive/files?limit=$limit${prefix != null ? '&prefix=$prefix' : ''}${lastName != null ? '&last=$lastName' : ''}"),
        headers: _defaultHeaders);
    return FileList.fromJson(jsonDecode(resp.body));
  }

  Stream<FileList> listFilesStream(String drive,
      {int limit = 100,
      String? prefix,
      String? lastName,
      Duration? timeOut}) async* {
    _checkForCreds();
    while (true) {
      yield await listFiles(drive,
          limit: limit, prefix: prefix, lastName: lastName);
      await Future.delayed(timeOut ?? const Duration(seconds: 5));
    }
  }

  deleteFiles(String drive, List<String> filesToDelete) async {
    _checkForCreds();
    if (filesToDelete.length > 1000) {
      throw ArgumentError.value(filesToDelete.length, "filesToDelete",
          "You can't delete more than 1000 files at once.");
    }
    var headers = <String, String>{};
    headers.addAll(_defaultHeaders);
    headers.addAll({"Content-Type": "application/json"});
    return jsonDecode((await http.delete(Uri.parse("$_baseUrl/$drive/files"),
            body: jsonEncode({"names": filesToDelete}), headers: headers))
        .body);
  }
}
