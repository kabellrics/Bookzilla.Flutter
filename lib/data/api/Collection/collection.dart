class RemoteCollection {
  String id;
  String name;
  String fanartpath;
  String parentid;

  RemoteCollection(
      {required this.id,
      required this.name,
      required this.fanartpath,
      required this.parentid});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fanartpath': fanartpath,
      'parentid': parentid,
    };
  }

  factory RemoteCollection.fromJson(Map<String, dynamic> json) {
    return RemoteCollection(
      id: json['Id'],
      name: json['Name'],
      fanartpath: json['FanartPath'],
      parentid: json['ParentId'],
    );
  }
}

class CollectionContainer {
  List<RemoteCollection> body;
  int itemCount;

  CollectionContainer({required this.body, required this.itemCount});

  factory CollectionContainer.fromJson(Map<String, dynamic> json) {
    var bodytmp = <RemoteCollection>[];
    if (json['body'] != null) {
      json['body'].forEach((v) {
        bodytmp.add(RemoteCollection.fromJson(v));
      });
    }
    var itemCounttmp = json['itemCount'];
    return CollectionContainer(body: bodytmp, itemCount: itemCounttmp);
  }
}
