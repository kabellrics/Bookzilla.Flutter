import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection_repository.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication_repository.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
import 'package:bookzilla_flutter/screens/explorer/explorer_header.dart';
import 'package:bookzilla_flutter/screens/tome/tome_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RowExplorer extends StatefulWidget {
  RowExplorer({super.key});

  @override
  State<RowExplorer> createState() => _RowExplorerState();
}

class _RowExplorerState extends State<RowExplorer> {
  final CollectionRepository collectionRepo =
      GetIt.I.get<CollectionRepository>();
  final PublicationRepository publiRepo = GetIt.I.get<PublicationRepository>();
  final TomeRepository tomeRepo = GetIt.I.get<TomeRepository>();

  String currentId = "0";
  bool isCollec = true;
  String oldcurrentId = "0";
  bool oldisCollec = true;
  String currentName = "Explorer";
  String oldName = "";

  void navigateDown(String newid, bool newisCollec, String newName) {
    oldcurrentId = currentId;
    oldisCollec = isCollec;
    oldName = currentName;
    currentId = newid;
    isCollec = newisCollec;
    currentName = newName;
  }

  Future<void> navigateUp() async {
    String grandfatherid = "";
    String grandfathername = "";
    var collecs = await collectionRepo.getAllCollections();
    if (collecs.any((element) => element.id == oldcurrentId)) {
      var fathercollec = collecs.firstWhere((x) => x.id == oldcurrentId);
      if (fathercollec.parentid != "0") {
        var collec = collecs.firstWhere((x) => x.id == fathercollec.parentid);
        grandfatherid = collec.id;
        grandfathername = collec.name;
        currentId = oldcurrentId;
        isCollec = oldisCollec;
        currentName = oldName;
        oldcurrentId = grandfatherid;
        oldisCollec = true;
        oldName = grandfathername;
        return;
      }
    }
    currentId = oldcurrentId;
    isCollec = oldisCollec;
    currentName = oldName;
    oldcurrentId = "0";
    oldisCollec = true;
    oldName = "Explorer";
  }

  Future<List<LocalCollection>?> getSubCollection() async {
    if (isCollec) {
      var collecs = await collectionRepo.getAllCollections();
      return collecs.where((element) => element.parentid == currentId).toList();
    } else {
      return null;
    }
  }

  Future<List<LocalPublication>?> getSubPublication() async {
    if (isCollec) {
      var publis = await publiRepo.getAllPublications();
      return publis
          .where((element) => element.collectionId == currentId)
          .toList();
    } else {
      return List.empty();
    }
  }

  Future<List<LocalTome>?> getSubTome() async {
    if (!isCollec) {
      var tomes = await tomeRepo.getAllTomes();
      return tomes
          .where((element) => element.publicationId == currentId)
          .toList();
    } else {
      return List.empty();
    }
  }

  Image getPublicationImage(LocalPublication item) {
    if (item.localcoverpath != '') {
      var file = File(item.localcoverpath);
      return Image.file(
        file,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        'http://192.168.1.17:800/${item.coverPath}',
        fit: BoxFit.cover,
      );
    }
  }

  Image getTomeImage(LocalTome item) {
    if (item.localcoverpath != '') {
      var file = File(item.localcoverpath);
      return Image.file(
        file,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        'http://192.168.1.17:800/${item.coverPath}',
        fit: BoxFit.cover,
      );
    }
  }

  Widget getCollectionImage(LocalCollection item) {
    if (item.localfanartpath != '') {
      var file = File(item.localfanartpath);
      return Image.file(
        file,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        'http://192.168.1.17:800/${item.fanartpath}',
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ExplorerHeader(
          text: currentName,
          onBackButtonPressed: () async {
            await navigateUp();
            setState(() {});
          }),
      Expanded(
        child: ListView(
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            children: [
              futureCollectionBuilder(),
              futurePublicationBuilder(),
              futureTomeBuilder(),
            ]),
      ),
    ]);
    // return Row(
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: [
    //     futureCollectionBuilder(),
    //     futurePublicationBuilder(),
    //     futureTomeBuilder(),
    //   ],
    // );
  }

  FutureBuilder<List<LocalCollection>?> futureCollectionBuilder() {
    return FutureBuilder<List<LocalCollection>?>(
        future: getSubCollection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(), // Afficher un indicateur de chargement pendant l'attente
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur lors du chargement des données.'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<LocalCollection> items = snapshot.data!;
            return collectionGridViewBuilder(items);
          } else {
            // Cas où le Future est null
            return const Center();
          }
        });
  }

  FutureBuilder<List<LocalPublication>?> futurePublicationBuilder() {
    return FutureBuilder<List<LocalPublication>?>(
        future: getSubPublication(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(), // Afficher un indicateur de chargement pendant l'attente
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur lors du chargement des données.'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<LocalPublication> items = snapshot.data!;
            return publicationGridViewBuilder(items);
          } else {
            // Cas où le Future est null
            return const Center();
          }
        });
  }

  FutureBuilder<List<LocalTome>?> futureTomeBuilder() {
    return FutureBuilder<List<LocalTome>?>(
        future: getSubTome(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(), // Afficher un indicateur de chargement pendant l'attente
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur lors du chargement des données.'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<LocalTome> items = snapshot.data!;
            return tomeGridViewBuilder(items);
          } else {
            // Cas où le Future est null
            return const Center();
          }
        });
  }

  GridView tomeGridViewBuilder(List<LocalTome> items) {
    return GridView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Nombre de colonnes
            crossAxisSpacing: 4.0, // Espacement horizontal entre les cellules
            mainAxisSpacing: 4.0, // Espacement vertical entre les cellules
            childAspectRatio: 5 / 3.1),
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              // Naviguez vers la page de détails de l'Item en passant l'Item en tant qu'argument
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TomeDetailPage(item: items[index]),
                ),
              );
            },
            child: createTomeCard(items, index),
          );
        }));
  }

  Card createTomeCard(List<LocalTome> items, int index) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: getTomeImage(items[index]),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                items[index].name,
                style: const TextStyle(fontSize: 25),
                maxLines: 2,
              )),
        ],
      ),
    );
  }

  GridView publicationGridViewBuilder(List<LocalPublication> items) {
    return GridView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Nombre de colonnes
            crossAxisSpacing: 4.0, // Espacement horizontal entre les cellules
            mainAxisSpacing: 4.0, // Espacement vertical entre les cellules
            childAspectRatio: 5 / 3.1),
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              navigateDown(items[index].id, false, items[index].name);
              setState(() {});
            },
            child: createPublicationCard(items, index),
          );
        }));
  }

  Card createPublicationCard(List<LocalPublication> items, int index) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: getPublicationImage(items[index]),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                items[index].name,
                style: const TextStyle(fontSize: 25),
                maxLines: 2,
              )),
        ],
      ),
    );
  }

  GridView collectionGridViewBuilder(List<LocalCollection> items) {
    return GridView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Nombre de colonnes
            crossAxisSpacing: 4.0, // Espacement horizontal entre les cellules
            mainAxisSpacing: 4.0, // Espacement vertical entre les cellules
            childAspectRatio: 10 / 16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              navigateDown(items[index].id, true, items[index].name);
              setState(() {});
            },
            child: createCollectionCard(items, index),
          );
        });
  }

  Card createCollectionCard(List<LocalCollection> items, int index) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: getCollectionImage(items[index]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              items[index].name,
              style: const TextStyle(fontSize: 25),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
