import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/data/local/Collection/sub_collection_items.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/screens/collection/collection_detail_screen.dart';
import 'package:bookzilla_flutter/shared/helper.dart';
import 'package:flutter/material.dart';

class CollectionDetailVertical extends StatelessWidget {
  final LocalCollection item;
  final CollectionSubItem subItems;
  const CollectionDetailVertical({required this.item, required this.subItems});

  Widget getHeader(String text) {
    return Container(
        width: double.infinity, // Occupe toute la largeur du composant parent
        height: 50.0, // Hauteur du widget (peut être ajustée selon vos besoins)
        color: Colors.blue, // Couleur du fond du widget (peut être modifiée)
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize:
                  20.0, // Taille du texte (peut être ajustée selon vos besoins)
              fontWeight: FontWeight.bold,
              color: Colors.white, // Couleur du texte (peut être modifiée)
            ),
          ),
        ));
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CollectionDetailPage(item: items[index]),
                      ),
                    );
                  },
                  child: collectionCardBuilder(items, index));
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
        getHeader(item.name),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: HelperImage.getCollectionImage(item),
        ),
        getHeader("Contient :"),
        collectionGridBuilder(subItems.subCollections!),
        publicationGridBuilder(subItems.subpublications!)
      ],
    );
  }
}
