import 'package:bookzilla_flutter/data/api/Collection/http_collection_helper.dart';
import 'package:bookzilla_flutter/data/api/Publication/http_publication_helper.dart';
import 'package:bookzilla_flutter/data/api/Tome/http_tome_helper.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection_repository.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication_repository.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class Init {
  static Future initialize() async {
    await _initSembast();
    _registerRepositories();
    _registerApiclient();
  }

  static Future _initSembast() async {
    final appDir = await getApplicationSupportDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, 'bookzilla.db');
    final database = await databaseFactoryIo.openDatabase(databasePath);
    GetIt.I.registerSingleton<Database>(database);
  }

  static _registerApiclient() {
    GetIt.I.registerLazySingleton<HttpCollectionHelper>(
        () => HttpCollectionHelper());
    GetIt.I.registerLazySingleton<HttpPublicationHelper>(
        () => HttpPublicationHelper());
    GetIt.I.registerLazySingleton<HttpTomeHelper>(() => HttpTomeHelper());
  }

  static _registerRepositories() {
    GetIt.I.registerLazySingleton<CollectionRepository>(
        () => CollectionRepository());
    GetIt.I.registerLazySingleton<PublicationRepository>(
        () => PublicationRepository());
    GetIt.I.registerLazySingleton<TomeRepository>(() => TomeRepository());
  }
}
