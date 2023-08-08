import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:bookzilla_flutter/data/api/Collection/http_collection_helper.dart';
import 'package:bookzilla_flutter/data/api/Publication/http_publication_helper.dart';
import 'package:bookzilla_flutter/data/api/Tome/http_tome_helper.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection_repository.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication_repository.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SynchroService {
  final String apiUrl = 'http://192.168.1.17:800';
  final CollectionRepository collectionRepo =
      GetIt.I.get<CollectionRepository>();
  final PublicationRepository publiRepo = GetIt.I.get<PublicationRepository>();
  final TomeRepository tomeRepo = GetIt.I.get<TomeRepository>();

  final HttpCollectionHelper collecAPIClient =
      GetIt.I.get<HttpCollectionHelper>();
  final HttpPublicationHelper publiAPIClient =
      GetIt.I.get<HttpPublicationHelper>();
  final HttpTomeHelper tomeAPIClient = GetIt.I.get<HttpTomeHelper>();

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

  Future<void> synchroCollection(BuildContext context) async {
    synchroUpCollection(context);
  }

  Future<void> synchroPublication(BuildContext context) async {
    synchroUpPublication(context);
  }

  Future<void> synchroTome(BuildContext context) async {
    synchroUpTome(context);
  }

  Future<void> downloadCollectionFanart(
      BuildContext context, LocalCollection item,
      [bool force = false]) async {
    if (force == true || item.localfanartpath == '') {
      final targetpath = await getApplicationSupportDirectory();
      http.Client client = http.Client();
      var urlpath = generatelocalpath(apiUrl, item.fanartpath);
      var request = await client.get(Uri.parse(urlpath));
      var bytes = request.bodyBytes;
      File file =
          await File(generatelocalpath(targetpath.path, item.fanartpath))
              .create(recursive: true);
      await file.writeAsBytes(bytes);
      item.localfanartpath = file.path;
      collectionRepo.updateCollection(item);
      if (context.mounted) {
        _showSnackbar(
            context, 'Téléchargement du Fanart de la Collection ${item.name}');
      }
    }
  }

  Future<void> downloadPublicationCover(
      BuildContext context, LocalPublication item,
      [bool force = false]) async {
    if (force == true || item.localcoverpath == '') {
      final targetpath = await getApplicationSupportDirectory();
      http.Client client = http.Client();
      var urlpath = generatelocalpath(apiUrl, item.coverPath);
      var request = await client.get(Uri.parse(urlpath));
      var bytes = request.bodyBytes;
      File file = await File(generatelocalpath(targetpath.path, item.coverPath))
          .create(recursive: true);
      await file.writeAsBytes(bytes);
      item.localcoverpath = file.path;
      publiRepo.updatePublication(item);
      if (context.mounted) {
        _showSnackbar(
            context, 'Téléchargement du Cover de la Publication ${item.name}');
      }
    }
  }

  Future<void> downloadTomeCover(BuildContext context, LocalTome item,
      [bool force = false]) async {
    if (force == true || item.localcoverpath == '') {
      final targetpath = await getApplicationSupportDirectory();
      http.Client client = http.Client();
      var urlpath = generatelocalpath(apiUrl, item.coverPath);
      var request = await client.get(Uri.parse(urlpath));
      var bytes = request.bodyBytes;
      File file = await File(generatelocalpath(targetpath.path, item.coverPath))
          .create(recursive: true);
      await file.writeAsBytes(bytes);
      item.localcoverpath = file.path;
      tomeRepo.updateTome(item);
      if (context.mounted) {
        _showSnackbar(context, 'Téléchargement du Cover du Tome ${item.name}');
      }
    }
  }

  String generatelocalpath(String targetpath, String itempath) {
    var pathelements = itempath.split('/');
    return join(targetpath, joinAll(pathelements));
  }

  Future<void> synchroUpCollection(BuildContext context) async {
    var remotecollecs = await collecAPIClient.getCollections();
    var localcollecs = await collectionRepo.getAllCollections();
    for (var remotecollec in remotecollecs) {
      bool isInList = localcollecs.any((x) => x.id == remotecollec.id);
      var collec = LocalCollection(
          id: remotecollec.id,
          name: remotecollec.name,
          fanartpath: remotecollec.fanartpath,
          parentid: remotecollec.parentid,
          localfanartpath: '',
          haschangedSinceLastSynchro: false);
      if (isInList) {
        collectionRepo.updateCollection(collec);
        if (context.mounted) {
          _showSnackbar(context, 'Mise à jour de la Collection ${collec.name}');
        }
      } else {
        collectionRepo.insertCollection(collec);
        if (context.mounted) {
          _showSnackbar(context, 'Création de la Collection ${collec.name}');
        }
      }
      if (context.mounted) {
        await downloadCollectionFanart(context, collec);
      }
    }
  }

  Future<void> synchroUpPublication(BuildContext context) async {
    var remotepublis = await publiAPIClient.getPublications();
    var localpublis = await publiRepo.getAllPublications();
    for (var remotepubli in remotepublis) {
      bool isInList = localpublis.any((x) => x.id == remotepubli.id);
      var publi = LocalPublication(
          id: remotepubli.id,
          name: remotepubli.name,
          coverPath: remotepubli.coverPath,
          localcoverpath: '',
          collectionId: remotepubli.collectionId,
          isFavorite: remotepubli.isFavorite,
          haschangedSinceLastSynchro: false);
      if (isInList) {
        publiRepo.updatePublication(publi);
        if (context.mounted) {
          _showSnackbar(context, 'Mise à jour de la Publication ${publi.name}');
        }
      } else {
        publiRepo.insertPublication(publi);
        if (context.mounted) {
          _showSnackbar(context, 'Création de la Publication ${publi.name}');
        }
      }
      if (context.mounted) {
        await downloadPublicationCover(context, publi);
      }
    }
  }

  Future<void> synchroUpTome(BuildContext context) async {
    var remotetomes = await tomeAPIClient.getTomes();
    var localtomes = await tomeRepo.getAllTomes();
    for (var remotetome in remotetomes) {
      bool isInList = localtomes.any((x) => x.id == remotetome.id);
      var tome = LocalTome(
          id: remotetome.id,
          name: remotetome.name,
          coverPath: remotetome.coverPath,
          localcoverpath: '',
          publicationId: remotetome.publicationId,
          currentPage: remotetome.currentPage,
          filePath: remotetome.filePath,
          localfilePath: '',
          orderInPublication: remotetome.orderInPublication,
          readingStatusId: remotetome.readingStatusId,
          size: remotetome.size,
          isEpub: remotetome.isEpub,
          cfi_EPUB: remotetome.cfi_EPUB,
          isFavorite: remotetome.isFavorite,
          haschangedSinceLastSynchro: false);
      if (isInList) {
        tomeRepo.updateTome(tome);
        if (context.mounted) {
          _showSnackbar(context, 'Mise à jour du Tome ${tome.name}');
        }
      } else {
        tomeRepo.insertTome(tome);
        if (context.mounted) {
          _showSnackbar(context, 'Création du Tome ${tome.name}');
        }
      }
      if (context.mounted) {
        await downloadTomeCover(context, tome);
      }
    }
  }
}
