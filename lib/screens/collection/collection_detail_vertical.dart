import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection_repository.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication_repository.dart';
import 'package:bookzilla_flutter/shared/helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CollectionDetailVertical extends StatelessWidget {
  final LocalCollection item;
  const CollectionDetailVertical({required this.item});

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

  Widget getHeader() {
    return Container(
        width: double.infinity, // Occupe toute la largeur du composant parent
        height: 50.0, // Hauteur du widget (peut être ajustée selon vos besoins)
        color: Colors.blue, // Couleur du fond du widget (peut être modifiée)
        child: Center(
          child: Text(
            item.name,
            style: const TextStyle(
              fontSize:
                  20.0, // Taille du texte (peut être ajustée selon vos besoins)
              fontWeight: FontWeight.bold,
              color: Colors.white, // Couleur du texte (peut être modifiée)
            ),
          ),
        ));
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
              return collectionCardBuilder(items, index);
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
              return publicationCardBuilder(items, index);
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      scrollDirection: Axis.vertical,
      children: [
        getHeader(),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: HelperImage.getCollectionImage(item),
        ),
        futureCollectionBuilder(),
        futurePublicationBuilder()
      ],
    );
  }
}
