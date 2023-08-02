import 'package:bookzilla_flutter/data/api/Collection/collection.dart' as api;

class LocalCollection extends api.RemoteCollection {
  String localfanartpath;
  bool haschangedSinceLastSynchro;

  LocalCollection(
      {required super.id,
      required super.name,
      required super.fanartpath,
      required super.parentid,
      this.localfanartpath = '',
      this.haschangedSinceLastSynchro = false});

  String getStorageID() {
    return 'Collec-$id';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fanartpath': fanartpath,
      'localfanartpath': localfanartpath,
      'parentid': parentid,
      'haschangedSinceLastSynchro': haschangedSinceLastSynchro,
    };
  }

  factory LocalCollection.fromJson(Map<String, dynamic> json) {
    return LocalCollection(
      id: json['id'],
      name: json['name'],
      fanartpath: json['fanartpath'],
      localfanartpath: json['localfanartpath'],
      parentid: json['parentid'],
      haschangedSinceLastSynchro: json['haschangedSinceLastSynchro'],
    );
  }
}
