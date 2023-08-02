import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection_repository.dart';
import 'package:bookzilla_flutter/shared/collection/collectiongrid.dart';
import 'package:bookzilla_flutter/shared/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final CollectionRepository collectionRepo =
      GetIt.I.get<CollectionRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Collections')),
        drawer: const MenuDrawer(),
        // body: const Center(child: FlutterLogo()),
        body: FutureBuilder<List<LocalCollection>>(
            future: collectionRepo.getAllCollections(),
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
                // return CollectionWrap(items: items);
                return CollectionGrid(items: items);
              } else {
                // Cas où le Future est null
                return const Center(
                  child: Text('Aucune donnée.'),
                );
              }
            }));
  }
}
