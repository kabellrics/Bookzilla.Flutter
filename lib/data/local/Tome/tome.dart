import 'package:bookzilla_flutter/data/api/Tome/tome.dart' as api;

class LocalTome extends api.RemoteTome {
  String localcoverpath;
  String localfilePath;
  bool haschangedSinceLastSynchro;

  LocalTome(
      {required super.id,
      required super.name,
      required super.coverPath,
      this.localcoverpath = '',
      required super.publicationId,
      required super.currentPage,
      required super.filePath,
      this.localfilePath = '',
      required super.orderInPublication,
      required super.readingStatusId,
      required super.size,
      required super.isFavorite,
      required super.isEpub,
      required super.cfi_EPUB,
      this.haschangedSinceLastSynchro = false});

  String getStorageID() {
    return 'Tome-$id';
  }

  factory LocalTome.fromJson(Map<String, dynamic> json) {
    return LocalTome(
      id: json['id'],
      name: json['name'],
      coverPath: json['coverPath'],
      localcoverpath: json['localcoverpath'],
      publicationId: json['publicationId'],
      currentPage: json['currentPage'],
      filePath: json['filePath'],
      localfilePath: json['localFilePath'],
      orderInPublication: json['orderInPublication'],
      readingStatusId: json['readingStatusId'],
      size: json['size'],
      isFavorite: json['isFavorite'],
      isEpub: json['IsEpub'],
      cfi_EPUB: json['CFI_EPUB'],
      haschangedSinceLastSynchro: json['haschangedSinceLastSynchro'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coverPath': coverPath,
      'localcoverpath': localcoverpath,
      'publicationId': publicationId,
      'currentPage': currentPage,
      'filePath': filePath,
      'localFilePath': localfilePath,
      'orderInPublication': orderInPublication,
      'readingStatusId': readingStatusId,
      'size': size,
      'isFavorite': isFavorite,
      'haschangedSinceLastSynchro': haschangedSinceLastSynchro,
      'IsEpub': isEpub,
      'CFI_EPUB': cfi_EPUB,
    };
  }
}
