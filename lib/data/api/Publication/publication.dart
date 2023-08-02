class PublicationContainer {
  List<RemmotePublication> body;
  int itemCount;

  PublicationContainer({required this.body, required this.itemCount});

  factory PublicationContainer.fromJson(Map<String, dynamic> json) {
    var bodytmp = <RemmotePublication>[];
    if (json['body'] != null) {
      json['body'].forEach((v) {
        bodytmp.add(RemmotePublication.fromJson(v));
      });
    }
    var itemCounttmp = json['itemCount'];
    return PublicationContainer(body: bodytmp, itemCount: itemCounttmp);
  }
}

class RemmotePublication {
  String id;
  String name;
  String coverPath;
  String collectionId;
  String isFavorite;

  RemmotePublication(
      {required this.id,
      required this.name,
      required this.coverPath,
      required this.collectionId,
      required this.isFavorite});

  factory RemmotePublication.fromJson(Map<String, dynamic> json) {
    return RemmotePublication(
      id: json['Id'],
      name: json['Name'],
      coverPath: json['CoverPath'],
      collectionId: json['CollectionId'],
      isFavorite: json['IsFavorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'CoverPath': coverPath,
      'CollectionId': collectionId,
      'IsFavorite': isFavorite,
    };
  }
}
