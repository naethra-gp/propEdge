import 'dart:io';

import 'package:external_path/external_path.dart';

class LocalStorage {
  static getDBFolder() async {
    // var path = (await ExternalPath.getExternalStorageDirectories());
    var directory = Directory('/storage/emulated/0/Download/PropEdge/DB');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    if (await Directory(directory.path).exists()) {
      return directory;
    }
    return null;
  }

  static getReimbursementFolder() async {
    String path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD);
    Directory dbFolder = Directory('$path/PropEdge/Reimbursement/');
    if (!await Directory(dbFolder.path).exists()) {
      await dbFolder.create(recursive: true);
    }
    if (await Directory(dbFolder.path).exists()) {
      return dbFolder;
    }
    return null;
  }

  static getSiteVisitFolder(String folder) async {
    String path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD);
    Directory dbFolder = Directory('$path/PropEdge/$folder/');
    if (!await Directory(dbFolder.path).exists()) {
      await dbFolder.create(recursive: true);
    }
    if (await Directory(dbFolder.path).exists()) {
      return dbFolder;
    }
    return null;
  }
}
