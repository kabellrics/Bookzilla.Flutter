import 'package:bookzilla_flutter/data/api/Publication/publication.dart' as api;

class LocalPublication extends api.RemmotePublication {
  String localcoverpath;
  bool haschangedSinceLastSynchro;

  LocalPublication(
      {required super.id,
      required super.name,
      required super.coverPath,
      this.localcoverpath = '',
      required super.collectionId,
      required super.isFavorite,
      this.haschangedSinceLastSynchro = false});

  String getStorageID() {
    return 'Publi-$id';
  }

  factory LocalPublication.fromJson(Map<String, dynamic> json) {
    return LocalPublication(
      id: json['Id'],
      name: json['Name'],
      coverPath: json['CoverPath'],
      localcoverpath: json['localcoverpath'],
      collectionId: json['CollectionId'],
      isFavorite: json['IsFavorite'],
      haschangedSinceLastSynchro: json['haschangedSinceLastSynchro'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'CoverPath': coverPath,
      'localcoverpath': localcoverpath,
      'CollectionId': collectionId,
      'IsFavorite': isFavorite,
      'haschangedSinceLastSynchro': haschangedSinceLastSynchro,
    };
  }
}
