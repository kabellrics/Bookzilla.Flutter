import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

class CollectionRepository {
  final Database _database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store('collection');

  Future insertCollection(LocalCollection collection) async {
    await _store
        .record(int.parse(collection.id))
        .put(_database, collection.toJson());
  }

  Future updateCollection(LocalCollection collection) async {
    await _store
        .record(int.parse(collection.id))
        .update(_database, collection.toJson());
  }

  Future deleteCollection(LocalCollection collection) async {
    await _store.record(int.parse(collection.id)).delete(_database);
  }

  Future<List<LocalCollection>> getAllCollections() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) =>
            LocalCollection.fromJson(snapshot.value as Map<String, dynamic>))
        .toList(growable: false);
  }
}
