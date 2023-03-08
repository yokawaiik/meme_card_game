String generateImagePath({
  required String rawFilePath,
  String fileName = 'file',
  String inDirectoryName = 'directory',
}) {
  final fileExt = rawFilePath.split('.').last;
  final _fileName = '${fileName}.$fileExt'.replaceAll(" ", "");
  final imagePath = "$inDirectoryName/$_fileName";

  return imagePath;
}
