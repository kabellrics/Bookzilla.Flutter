import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BookDownloader {
  final String apiUrl = 'http://192.168.1.17:800';
  final TomeRepository tomeRepo = GetIt.I.get<TomeRepository>();

  void _showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text,
            style:
                const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
        duration: const Duration(
            seconds: 1), // Durée pendant laquelle le SnackBar est affiché
      ),
    );
  }

  String generatelocalpath(String targetpath, String itempath) {
    var pathelements = itempath.split('/');
    return join(targetpath, joinAll(pathelements));
  }

  Future<String> generateLocalPath(String localpath) async {
    return join((await getApplicationSupportDirectory()).path, localpath);
  }

  Future<String> generateTmpPath(String localpath) async {
    return join((await getTemporaryDirectory()).path, localpath);
  }
}
