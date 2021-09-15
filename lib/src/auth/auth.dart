class DetaAuth {
  late final String _projectKey;
  late final String _projectId;

  static final DetaAuth _instance = DetaAuth._internal();
  static DetaAuth get instance => _instance;

  DetaAuth._internal();

  factory DetaAuth({required String projectId, required String projectKey}) {
    throw UnimplementedError("DetaAuth isn't available yet!");
  }
}
