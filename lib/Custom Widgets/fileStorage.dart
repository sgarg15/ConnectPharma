// ignore_for_file: unnecessary_string_interpolations

library basic_local_file_storage;

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  Future<String> get localPath async {
    //print("INSIDE LOCAL PATH");
    Directory directory = await getApplicationDocumentsDirectory();
    //print("directory $directory");
    return directory.path;
  }

  Future<File> readLocalFile({required String fileName}) async {
    final path = await localPath;
    return File('$path/$fileName');
  }

  Future<File> writeLocalFile({required String fileName, required String data}) async {
    final path = await localPath;
    final _file = File('$path/$fileName');
    return _file.writeAsString(data);
  }

  Future<File> writeFile({required String filePath, required String data}) async {
    final _file = File(filePath);
    return _file.writeAsString(data);
  }

  String readFile({required String filePath}) {
    final _file = File(filePath);
    return _file.readAsStringSync();
  }

  Future<void> removeFile({required String filePath}) {
    final _file = File(filePath);
    return _file.delete();
  }

  Future<Directory> createLocalDirectory({required String directoryName}) async {
    final _path = await localPath;
    final _directory = Directory('$_path/$directoryName');
    return _directory.create();
  }

  Future<Directory> createDirectory({required String path}) async {
    final _directory = Directory('$path');
    return _directory.create();
  }

  //Delete all files in the given directory
  Future<void> clearDirectoryFiles({required String path}) {
    final directory = Directory(path);
    directory.deleteSync(recursive: true);
    final _directory = Directory(path);
    return _directory.create();
  }

  //Get all the files in a directory
  List<FileSystemEntity> allDirectoryFiles({required String path}) {
    final directory = Directory(path);
    return directory.listSync();
  }

  //Move a file from one directory to another
  Future<void> moveFile({
    required String fromPath,
    required String toPath,
  }) async {
    final _file = File(fromPath);
    await _file.rename(toPath);
  }

  String checkFileSize({required File file}) {
    var bytes = file.lengthSync();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();

    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }
}
