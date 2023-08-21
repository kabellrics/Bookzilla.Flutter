import 'dart:io';

import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class BookDownloader {
  final String apiUrl = 'http://192.168.1.17:800';
  final TomeRepository tomeRepo = GetIt.I.get<TomeRepository>();

  Future<String> downloadInTmpAsync(String source, String target) async {
    http.Client client = http.Client();
    var urlpath = redefineUrlPath(apiUrl, target);
    var request = await client.get(Uri.parse(urlpath));
    var bytes = request.bodyBytes;
    var tmpfilepath = await generateTmpPath(target);
    File file = await File(tmpfilepath).create(recursive: true);
    await file.writeAsBytes(bytes);
    return tmpfilepath;
  }

  Future<String> downloadInLocalAsync(String source, String target) async {
    http.Client client = http.Client();
    var urlpath = redefineUrlPath(apiUrl, target);
    var request = await client.get(Uri.parse(urlpath));
    var bytes = request.bodyBytes;
    var tmpfilepath = await generateLocalPath(target);
    File file = await File(tmpfilepath).create(recursive: true);
    await file.writeAsBytes(bytes);
    return tmpfilepath;
  }

  void downloadIntmp(LocalTome tome) async {
    var newlocalpath = await downloadInTmpAsync(tome.filePath, tome.filePath);
    tome.localfilePath = newlocalpath;
    tomeRepo.updateTome(tome);
  }

  void downloadInLocal(LocalTome tome) async {
    var newlocalpath = await downloadInLocalAsync(tome.filePath, tome.filePath);
    tome.localfilePath = newlocalpath;
    tomeRepo.updateTome(tome);
  }

  String redefineUrlPath(String targetpath, String itempath) {
    var pathelements = itempath.split('/');
    return join(targetpath, joinAll(pathelements));
  }

  Future<String> generateLocalPath(String localpath) async {
    var pathelements = localpath.split('/');
    return join(
        (await getApplicationSupportDirectory()).path, joinAll(pathelements));
  }

  Future<String> generateTmpPath(String localpath) async {
    var pathelements = localpath.split('/');
    return join((await getTemporaryDirectory()).path, 'temporary',
        joinAll(pathelements));
  }
}
