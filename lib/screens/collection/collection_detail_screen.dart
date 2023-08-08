import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection_repository.dart';
import 'package:bookzilla_flutter/data/local/Collection/sub_collection_items.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication_repository.dart';
import 'package:bookzilla_flutter/screens/collection/collection_detail_horizontal.dart';
import 'package:bookzilla_flutter/screens/collection/collection_detail_vertical.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CollectionDetailPage extends StatelessWidget {
  final LocalCollection item;

  Future<List<LocalCollection>> getSubCollection() async {
    CollectionRepository collectionRepo = GetIt.I.get<CollectionRepository>();
    var collecs = await collectionRepo.getAllCollections();
    return collecs.where((element) => element.parentid == item.id).toList();
  }

  Future<List<LocalPublication>> getSubPublication() async {
    PublicationRepository publiRepo = GetIt.I.get<PublicationRepository>();
    var publics = await publiRepo.getAllPublications();
    return publics.where((element) => element.collectionId == item.id).toList();
  }

  Future<CollectionSubItem> getSubItems() async {
    var subitems = CollectionSubItem();
    subitems.subCollections = await getSubCollection();
    subitems.subpublications = await getSubPublication();
    return subitems;
  }

  CollectionDetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(item.name),
        ),
        body: FutureBuilder<CollectionSubItem>(
            future: getSubItems(),
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
                CollectionSubItem subItems = snapshot.data!;
                return OrientationBuilder(builder: (context, orientation) {
                  if (orientation == Orientation.portrait) {
                    return CollectionDetailVertical(
                        item: item, subItems: subItems);
                  } else {
                    return CollectionDetailHorizontal(
                        item: item, subItems: subItems);
                  }
                });
              } else {
                // Cas où le Future est null
                return const Center();
              }
            }));
  }
}
