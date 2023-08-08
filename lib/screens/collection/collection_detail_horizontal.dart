import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/data/local/Collection/sub_collection_items.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/screens/collection/collection_detail_screen.dart';
import 'package:bookzilla_flutter/shared/helper.dart';
import 'package:flutter/material.dart';

class CollectionDetailHorizontal extends StatelessWidget {
  final LocalCollection item;
  final CollectionSubItem subItems;
  const CollectionDetailHorizontal(
      {required this.item, required this.subItems});

  Widget getUpPart(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height /
          2, // Moitié de la hauteur disponible
      color: Colors.grey, // Couleur de fond du container (peut être modifiée)
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width /
                2, // Moitié de la largeur disponible
            child: AspectRatio(
                aspectRatio: 16 / 9, // Ratio 16/9 de l'image
                child: HelperImage.getCollectionImage(item)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0), // Espacement du titre
              child: Center(
                child: Text(
                  item.name, // Titre à afficher
                  style: const TextStyle(
                    fontSize:
                        38.0, // Taille du texte (peut être ajustée selon vos besoins)
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
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
            childAspectRatio: 6 / 3.4),
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () {},
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
            childAspectRatio: 11 / 16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CollectionDetailPage(item: items[index]),
                ),
              );
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getUpPart(context),
        Expanded(
            child: ListView(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.horizontal,
          children: [
            collectionGridViewBuilder(subItems.subCollections!),
            publicationGridViewBuilder(subItems.subpublications!)
          ],
        ))
      ],
    );
  }
}
