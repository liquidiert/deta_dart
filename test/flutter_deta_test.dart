import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_deta/flutter_deta.dart';
import 'package:dotenv/dotenv.dart' show load, env;

import 'testModels/GameInfo.dart';
import 'testModels/GameResult.dart';
import 'testModels/User.dart';
import 'testModels/UserStats.dart';

void main() {
  load();

  DetaBase.instance
      .init(projectId: env["PROJECT_ID"]!, projectKey: env["PROJECT_KEY"]!);

  DetaBase.instance.initGenericFactories(<Type, Function>{
    GameInfo: (json) => GameInfo.fromJson(json),
    GameResult: (json) => GameResult.fromJson(json),
    User: (json) => User.fromJson(json),
    UserStats: (json) => UserStats.fromJson(json)
  });

  DetaDrive.instance
      .init(projectId: env["PROJECT_ID"]!, projectKey: env["PROJECT_KEY"]!);

  test("get generic item User", () async {
    var user = await DetaBase.instance
        .getGenericItem<User>("/users/items/9clzj009nqrc");
    expect(user, isNotNull);
  });

  test("deta drive simple CRUD", () async {
    final imgBytes =
        await File.fromUri(Uri.parse("./test/testSrc/Cat03.jpg")).readAsBytes();
    final resp =
        await DetaDrive.instance.uploadSmallFile("test", "test.jpg", imgBytes);
    expect(resp["name"], equals("test.jpg"));

    final img = await DetaDrive.instance.downloadFile("test", "test.jpg");
    expect(img, equals(imgBytes));

    final delResp = await DetaDrive.instance.deleteFiles("test", ["test.jpg"]);
    expect(delResp["deleted"], contains("test.jpg"));
  });

  test("deta drive big CRUD", () async {
    final imgBytes =
        await File.fromUri(Uri.parse("./test/testSrc/test.pdf")).readAsBytes();
    final resp = await DetaDrive.instance
        .chunkedUpload("test", "test.pdf", imgBytes)
        .last;
    expect(resp["name"], equals("test.pdf"));

    final img = await DetaDrive.instance.downloadFile("test", "test.pdf");
    expect(img, equals(imgBytes));

    final delResp = await DetaDrive.instance.deleteFiles("test", ["test.pdf"]);
    expect(delResp["deleted"], contains("test.pdf"));
  });
}
