import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection_repository.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication_repository.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
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

  Future<List<LocalCollection>> getSubCollection() async {
    if (isCollec) {
      var collecs = await collectionRepo.getAllCollections();
      return collecs.where((element) => element.parentid == currentId).toList();
    } else {
      return List.empty();
    }
  }

  Future<List<LocalPublication>> getSubPublication() async {
    if (isCollec) {
      var publis = await publiRepo.getAllPublications();
      return publis
          .where((element) => element.collectionId == currentId)
          .toList();
    } else {
      return List.empty();
    }
  }

  Future<List<LocalTome>> getSubTome() async {
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureCollectionBuilder(),
        FuturePublicationBuilder(),
        FutureTomeBuilder(),
      ],
    );
  }

  FutureBuilder<List<LocalCollection>> FutureCollectionBuilder() {
    return FutureBuilder<List<LocalCollection>>(
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
            return CollectionGridBuilder(items);
          } else {
            // Cas où le Future est null
            return const Center();
          }
        });
  }

  FutureBuilder<List<LocalPublication>> FuturePublicationBuilder() {
    return FutureBuilder<List<LocalPublication>>(
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
            return PublicationGridBuilder(items);
          } else {
            // Cas où le Future est null
            return const Center();
          }
        });
  }

  FutureBuilder<List<LocalTome>> FutureTomeBuilder() {
    return FutureBuilder<List<LocalTome>>(
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
            return TomeGridBuilder(items);
          } else {
            // Cas où le Future est null
            return const Center();
          }
        });
  }

  Padding CollectionGridBuilder(List<LocalCollection> items) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OrientationBuilder(builder: (context, orientation) {
        int crossAxisCount = orientation == Orientation.portrait ? 1 : 1;
        var axis = orientation == Orientation.portrait
            ? Axis.vertical
            : Axis.horizontal;
        return CollectionGridViewBuilder(
            items, axis, crossAxisCount, orientation);
      }),
    );
  }

  Padding PublicationGridBuilder(List<LocalPublication> items) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OrientationBuilder(builder: ((context, orientation) {
        int crossAxisCount = orientation == Orientation.portrait ? 2 : 1;
        var axis = orientation == Orientation.portrait
            ? Axis.vertical
            : Axis.horizontal;
        return PublicationGridViewBuilder(
            items, axis, crossAxisCount, orientation);
      })),
    );
  }

  Padding TomeGridBuilder(List<LocalTome> items) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OrientationBuilder(builder: ((context, orientation) {
        int crossAxisCount = orientation == Orientation.portrait ? 2 : 1;
        var axis = orientation == Orientation.portrait
            ? Axis.vertical
            : Axis.horizontal;
        return TomeGridViewBuilder(items, axis, crossAxisCount, orientation);
      })),
    );
  }

  GridView TomeGridViewBuilder(List<LocalTome> items, Axis axis,
      int crossAxisCount, Orientation orientation) {
    return GridView.builder(
        itemCount: items.length,
        scrollDirection: axis,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // Nombre de colonnes
            crossAxisSpacing: 4.0, // Espacement horizontal entre les cellules
            mainAxisSpacing: 4.0, // Espacement vertical entre les cellules
            childAspectRatio:
                orientation == Orientation.portrait ? 2 / 3.25 : 5 / 3.1),
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
            child: Card(
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
            ),
          );
        }));
  }

  GridView PublicationGridViewBuilder(List<LocalPublication> items, Axis axis,
      int crossAxisCount, Orientation orientation) {
    return GridView.builder(
        itemCount: items.length,
        scrollDirection: axis,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // Nombre de colonnes
            crossAxisSpacing: 4.0, // Espacement horizontal entre les cellules
            mainAxisSpacing: 4.0, // Espacement vertical entre les cellules
            childAspectRatio:
                orientation == Orientation.portrait ? 2 / 3.25 : 5 / 3.1),
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {
              currentId = items[index].id;
              isCollec = false;
              setState(() {});
            },
            child: Card(
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
            ),
          );
        }));
  }

  GridView CollectionGridViewBuilder(List<LocalCollection> items, Axis axis,
      int crossAxisCount, Orientation orientation) {
    return GridView.builder(
        itemCount: items.length,
        scrollDirection: axis,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // Nombre de colonnes
            crossAxisSpacing: 4.0, // Espacement horizontal entre les cellules
            mainAxisSpacing: 4.0, // Espacement vertical entre les cellules
            childAspectRatio:
                orientation == Orientation.portrait ? 16 / 11 : 11 / 16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              currentId = items[index].id;
              isCollec = true;
              setState(() {});
            },
            child: Card(
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
            ),
          );
        });
  }
}
