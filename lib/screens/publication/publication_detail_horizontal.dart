import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/shared/helper.dart';
import 'package:bookzilla_flutter/shared/tome/tomecard.dart';
import 'package:flutter/material.dart';

class PublicationDetailHorizontal extends StatelessWidget {
  final LocalPublication item;
  final List<LocalTome> subItems;
  const PublicationDetailHorizontal(
      {required this.item, required this.subItems});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AspectRatio(
            aspectRatio: 2 / 3,
            child: HelperImage.getPublicationImageDetail(item)),
        getRightPart(context)
      ],
    );
  }

  Widget getRightPart(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
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
            const SizedBox(height: 10.0),
            getgridviewChild(context),
          ],
        ),
      ),
    );
  }

  Widget getgridviewChild(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          itemCount: subItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Nombre de colonnes
              crossAxisSpacing: 4.0, // Espacement horizontal entre les cellules
              mainAxisSpacing: 4.0,
              childAspectRatio: 2 / 3),
          itemBuilder: ((context, index) {
            return TomeCard(item: subItems[index]);
          })),
    );
  }
}
