import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> getDataFromJsonFile(String filePath) async {
  var input = await File(filePath).readAsString();
  var map = jsonDecode(input) as Map<String, dynamic>;
  return map;
}
