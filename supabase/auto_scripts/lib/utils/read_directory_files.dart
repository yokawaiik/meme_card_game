import 'dart:io';

Future<List<String>?> readDirectoryFiles(String pathToFolder,
    {bool onlyNames = false}) async {
  try {
    final directory = Directory(pathToFolder);

    if (!await directory.exists()) {
      throw Exception("Such directory doesn't exist.");
    }

    final filesRaw = directory.listSync();

    List<String> files = [];

    if (onlyNames) {
      files = filesRaw.map((file) => file.uri.pathSegments.last).toList();
      files = filesRaw.map((file) => file.uri.pathSegments.last).toList();
    } else {
      files = filesRaw.map((file) => file.path).toList();
    }

    return files;
  } catch (e) {
    print("readDirectoryFiles exception: $e.");
    rethrow;
  }
}
