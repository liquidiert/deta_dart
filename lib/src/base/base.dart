import 'dart:convert';
import 'package:http/http.dart' as http;

class DetaBase {
  late final String _projectKey;
  late final String _projectId;

  static final DetaBase _instance = DetaBase._internal();
  static DetaBase get instance => _instance;

  DetaBase._internal();

  factory DetaBase() => _instance;

  init({required String projectId, required String projectKey}) {
    _projectId = projectId;
    _projectKey = projectKey;
  }

  Map<Type, Function>? _factories;

  // has to be called if generic calls shall be used
  initGenericFactories(Map<Type, Function> factories) {
    _factories = factories;
  }

  _checkForCreds() {
    // ignore: unnecessary_null_comparison
    if (_projectId == null && _projectKey == null) {
      throw ArgumentError(
          "ProjectID and ProjectKey must not be null! Did you call DetaBase.init(id, key)?");
    }
  }

  get _baseUrl => "https://database.deta.sh/v1/$_projectId";
  get _defaultHeaders =>
      {"X-API-Key": _projectKey, "Content-Type": "application/json"};

  Future<dynamic> addItem(String path, Object body) async {
    _checkForCreds();
    return jsonDecode((await http.post(Uri.parse(_baseUrl + path),
            body: jsonEncode({"items": body}), headers: _defaultHeaders))
        .body);
  }

  Future<dynamic> addMultipleItems(String path, List<Object> body) async {
    _checkForCreds();
    return jsonDecode((await http.post(Uri.parse(_baseUrl + path),
            body: jsonEncode({"items": body}), headers: _defaultHeaders))
        .body);
  }

  Future<dynamic> updateItem(String path, Object body) async {
    _checkForCreds();
    return jsonDecode((await http.patch(Uri.parse(_baseUrl + path),
            body: jsonEncode(body), headers: _defaultHeaders))
        .body);
  }

  Future<dynamic> getItem(String url) async {
    _checkForCreds();
    return json.decode(
        (await http.get(Uri.parse(_baseUrl + url), headers: _defaultHeaders))
            .body);
  }

  Future<dynamic> queryItem(String url, List<Object> queries) async {
    _checkForCreds();
    return json.decode((await http.post(Uri.parse(_baseUrl + url),
            body: jsonEncode({"query": queries}), headers: _defaultHeaders))
        .body);
  }

  Future<dynamic> deleteItem(String path) async {
    _checkForCreds();
    return json.decode((await http.delete(Uri.parse(_baseUrl + path),
            headers: _defaultHeaders))
        .body);
  }

  // region generic calls
  checkFactories() {
    if (_factories == null) {
      throw ArgumentError.notNull(
          "You have to initialize factories via initGenericFactories if you want to use generic methods!");
    }
  }

  Future<T> addGenericItem<T>(String path, Object body) async {
    _checkForCreds();
    checkFactories();
    final resp = jsonDecode((await http.post(Uri.parse(_baseUrl + path),
            body: jsonEncode({"items": body}), headers: _defaultHeaders))
        .body);
    return _factories![T]!(resp);
  }

  Future<T> addMultipleGenericItems<T>(String path, List<Object> body) async {
    _checkForCreds();
    checkFactories();
    final resp = jsonDecode((await http.post(Uri.parse(_baseUrl + path),
            body: jsonEncode({"items": body}), headers: _defaultHeaders))
        .body);
    return _factories![T]!(resp);
  }

  Future<T> updateGenericItem<T>(String path, Object body) async {
    _checkForCreds();
    checkFactories();
    final resp = jsonDecode((await http.patch(Uri.parse(_baseUrl + path),
            body: jsonEncode(body), headers: _defaultHeaders))
        .body);
    return _factories![T]!(resp);
  }

  Future<T> getGenericItem<T>(String url) async {
    _checkForCreds();
    checkFactories();
    final resp = json.decode(
        (await http.get(Uri.parse(_baseUrl + url), headers: _defaultHeaders))
            .body);
    return _factories![T]!(resp);
  }

  Future<T?> querySingleGenericItem<T>(String url, List<Object> queries) async {
    _checkForCreds();
    checkFactories();
    final resp = json.decode((await http.post(Uri.parse(_baseUrl + url),
            body: jsonEncode({"query": queries, "limit": 1}),
            headers: _defaultHeaders))
        .body);
    return resp["items"].length == 0 ? null : _factories![T]!(resp["items"][0]);
  }

  Future<List<T>> queryGenericItems<T>(String url, List<Object> queries) async {
    _checkForCreds();
    checkFactories();
    final resp = json.decode((await http.post(Uri.parse(_baseUrl + url),
            body: jsonEncode({"query": queries}), headers: _defaultHeaders))
        .body)["items"];
    return _factories![T]!(resp);
  }
  // endregion

  // region raw calls
  Future<dynamic> addRawItem(String path, Object body) async {
    _checkForCreds();
    return jsonDecode((await http.post(Uri.parse(_baseUrl + path),
            body: jsonEncode(body), headers: _defaultHeaders))
        .body);
  }

  Future<dynamic> addMultipleRawItems(String path, Object body) async {
    _checkForCreds();
    return jsonDecode((await http.post(Uri.parse(_baseUrl + path),
            body: jsonEncode(body), headers: _defaultHeaders))
        .body);
  }

  Future<dynamic> queryRaw(String url, Object query) async {
    _checkForCreds();
    return json.decode((await http.post(Uri.parse(_baseUrl + url),
            body: jsonEncode(query), headers: _defaultHeaders))
        .body);
  }
  // endregion

  // region safe calls
  Future<dynamic> addItemSafe(String base, Object body) async {
    _checkForCreds();
    return jsonDecode((await http.post(Uri.parse("$_baseUrl/$base/items"),
            body: jsonEncode({"items": body}), headers: _defaultHeaders))
        .body);
  }

  Future<dynamic> addMultipleItemsSafe(String base, List<Object> body) async {
    _checkForCreds();
    return jsonDecode((await http.post(Uri.parse("$_baseUrl/$base/items"),
            body: jsonEncode({"items": body}), headers: _defaultHeaders))
        .body);
  }

  Future<dynamic> updateItemSafe(
      String base, String toUpdateKey, Object body) async {
    _checkForCreds();
    return jsonDecode((await http.patch(
            Uri.parse("$_baseUrl/$base/items/$toUpdateKey"),
            body: jsonEncode(body),
            headers: _defaultHeaders))
        .body);
  }

  Future<dynamic> getItemSafe(String base, String key) async {
    _checkForCreds();
    return json.decode((await http.get(Uri.parse("$_baseUrl/$base/items/$key"),
            headers: _defaultHeaders))
        .body);
  }

  Future<dynamic> queryItemSafe(String base, List<Object> queries) async {
    _checkForCreds();
    return json.decode((await http.post(Uri.parse("$_baseUrl/$base/query"),
            body: jsonEncode({"query": queries}), headers: _defaultHeaders))
        .body);
  }

  Future<dynamic> deleteItemSafe(String base, String toDeleteKey) async {
    _checkForCreds();
    return json.decode((await http.delete(
            Uri.parse("$_baseUrl/$base/items/$toDeleteKey"),
            headers: _defaultHeaders))
        .body);
  }
  // endregion
}
