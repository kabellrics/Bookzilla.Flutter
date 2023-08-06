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
import 'package:bookzilla_flutter/shared/helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ColumnExplorer extends StatefulWidget {
  ColumnExplorer({super.key});

  @override
  State<ColumnExplorer> createState() => _ColumnExplorerState();
}

class _ColumnExplorerState extends State<ColumnExplorer> {
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
      return List.empty();
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      children: [
        ExplorerHeader(
            text: currentName,
            onBackButtonPressed: () async {
              await navigateUp();
              setState(() {});
            }),
        futureCollectionBuilder(),
        futurePublicationBuilder(),
        futureTomeBuilder(),
      ],
    );
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: [
    //     futureCollectionBuilder(),
    //     futurePublicationBuilder(),
    //     futureTomeBuilder(),
    //   ],
    // );
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
          } else if (snapshot.hasData) {
            List<LocalTome> items = snapshot.data!;
            return tomeGridBuilder(items);
          } else {
            // Cas où le Future est null
            return const Center();
          }
        });
  }

  Flexible tomeGridBuilder(List<LocalTome> items) {
    return Flexible(
        child: GridView.builder(
            itemCount: items.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Nombre de colonnes
                crossAxisSpacing:
                    4.0, // Espacement horizontal entre les cellules
                mainAxisSpacing: 4.0, // Espacement vertical entre les cellules
                childAspectRatio: 2 / 3.25),
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
                child: tomeCardBuilder(items, index),
              );
            })));
  }

  Card tomeCardBuilder(List<LocalTome> items, int index) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: HelperImage.getTomeImage(items[index]),
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
          } else if (snapshot.hasData) {
            List<LocalPublication> items = snapshot.data!;
            return publicationGridBuilder(items);
          } else {
            // Cas où le Future est null
            return const Center();
          }
        });
  }

  Flexible publicationGridBuilder(List<LocalPublication> items) {
    return Flexible(
        child: GridView.builder(
            itemCount: items.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Nombre de colonnes
                crossAxisSpacing:
                    4.0, // Espacement horizontal entre les cellules
                mainAxisSpacing: 4.0, // Espacement vertical entre les cellules
                childAspectRatio: 2 / 3.5),
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () {
                  navigateDown(items[index].id, false, items[index].name);
                  setState(() {});
                },
                child: publicationCardBuilder(items, index),
              );
            })));
  }

  Card publicationCardBuilder(List<LocalPublication> items, int index) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: HelperImage.getPublicationImage(items[index]),
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
          } else if (snapshot.hasData) {
            List<LocalCollection> items = snapshot.data!;
            return collectionGridBuilder(items);
          } else {
            // Cas où le Future est null
            return const Center();
          }
        });
  }

  Flexible collectionGridBuilder(List<LocalCollection> items) {
    return Flexible(
        child: GridView.builder(
            itemCount: items.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Nombre de colonnes
                crossAxisSpacing:
                    4.0, // Espacement horizontal entre les cellules
                mainAxisSpacing: 4.0, // Espacement vertical entre les cellules
                childAspectRatio: 16 / 11),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  navigateDown(items[index].id, true, items[index].name);
                  setState(() {});
                },
                child: collectionCardBuilder(items, index),
              );
            }));
  }

  Card collectionCardBuilder(List<LocalCollection> items, int index) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: HelperImage.getCollectionImage(items[index]),
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
