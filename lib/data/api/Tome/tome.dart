class TomeContainer {
  List<RemoteTome> body;
  int itemCount;

  TomeContainer({required this.body, required this.itemCount});

  factory TomeContainer.fromJson(Map<String, dynamic> json) {
    var bodytmp = <RemoteTome>[];
    if (json['body'] != null) {
      json['body'].forEach((v) {
        bodytmp.add(RemoteTome.fromJson(v));
      });
    }
    var itemCounttmp = json['itemCount'];
    return TomeContainer(body: bodytmp, itemCount: itemCounttmp);
  }
}

class RemoteTome {
  String id;
  String name;
  String coverPath;
  String publicationId;
  String currentPage;
  String filePath;
  String orderInPublication;
  String readingStatusId;
  String size;
  String isFavorite;
  String isEpub;
  String cfi_EPUB;
  String googleBookId;
  String auteur;
  String description;
  String publicationDate;
  String iSBN_10;
  String iSBN_13;

  RemoteTome(
      {required this.id,
      required this.name,
      required this.coverPath,
      required this.publicationId,
      required this.currentPage,
      required this.filePath,
      required this.orderInPublication,
      required this.readingStatusId,
      required this.size,
      required this.isFavorite,
      required this.isEpub,
      required this.cfi_EPUB,
      required this.googleBookId,
      required this.auteur,
      required this.description,
      required this.publicationDate,
      required this.iSBN_10,
      required this.iSBN_13});

  factory RemoteTome.fromJson(Map<String, dynamic> json) {
    return RemoteTome(
        id: json['Id'],
        name: json['Name'],
        coverPath: json['CoverPath'],
        publicationId: json['PublicationId'],
        currentPage: json['CurrentPage'],
        filePath: json['FilePath'],
        orderInPublication: json['OrderInPublication'],
        readingStatusId: json['ReadingStatusId'],
        size: json['Size'],
        isFavorite: json['IsFavorite'],
        isEpub: json['IsEpub'],
        cfi_EPUB: json['CFI_EPUB'],
        googleBookId: json['GoogleBookId'],
        auteur: json['Auteur'],
        description: json['Description'],
        publicationDate: json['PublicationDate'],
        iSBN_10: json['ISBN_10'],
        iSBN_13: json['ISBN_13']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'CoverPath': coverPath,
      'PublicationId': publicationId,
      'CurrentPage': currentPage,
      'FilePath': filePath,
      'OrderInPublication': orderInPublication,
      'ReadingStatusId': readingStatusId,
      'Size': size,
      'IsFavorite': isFavorite,
      'IsEpub': isEpub,
      'CFI_EPUB': cfi_EPUB,
      'GoogleBookId': googleBookId,
      'Auteur': auteur,
      'Description': description,
      'PublicationDate': publicationDate,
      'ISBN_10': iSBN_10,
      'ISBN_13': iSBN_13,
    };
  }
}
