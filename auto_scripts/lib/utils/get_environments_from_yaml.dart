import 'dart:developer';
import 'dart:io';
import 'package:yaml/yaml.dart';

Future<dynamic> getEnvironmentsFromYaml(String fileName) async {
  try {
    final configFile = File(fileName);
    final yamlString = await configFile.readAsString();
    final environments = loadYaml(yamlString);

    return environments;
  } catch (e) {
    log("getEnvironmentsFromYaml threw an Exception.");
    rethrow;
  }
}
