import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

class PublicationRepository {
  final Database _database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store('publication');

  Future insertPublication(LocalPublication publication) async {
    await _store
        .record(int.parse(publication.id))
        .put(_database, publication.toJson());
  }

  Future updatePublication(LocalPublication publication) async {
    await _store
        .record(int.parse(publication.id))
        .update(_database, publication.toJson());
  }

  Future deletePublication(LocalPublication publication) async {
    await _store.record(int.parse(publication.id)).delete(_database);
  }

  Future<List<LocalPublication>> getAllPublications() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) =>
            LocalPublication.fromJson(snapshot.value as Map<String, dynamic>))
        .toList(growable: false);
  }
}
