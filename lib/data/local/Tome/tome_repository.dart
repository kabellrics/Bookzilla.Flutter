import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

class TomeRepository {
  final Database _database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store('tome');

  Future insertTome(LocalTome tome) async {
    await _store.record(int.parse(tome.id)).put(_database, tome.toJson());
  }

  Future updateTome(LocalTome tome) async {
    await _store.record(int.parse(tome.id)).update(_database, tome.toJson());
  }

  Future deleteTome(LocalTome tome) async {
    await _store.record(int.parse(tome.id)).delete(_database);
  }

  Future<List<LocalTome>> getAllTomes() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) =>
            LocalTome.fromJson(snapshot.value as Map<String, dynamic>))
        .toList(growable: false);
  }
}
