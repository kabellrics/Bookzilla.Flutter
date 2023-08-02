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
      required this.isFavorite});

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
    );
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
    };
  }
}
