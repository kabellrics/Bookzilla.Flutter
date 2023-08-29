import 'dart:io';

import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication_repository.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
import 'package:bookzilla_flutter/shared/helper.dart';
import 'package:bookzilla_flutter/shared/tome/tomecard.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
            getFavAndSynchro(context),
            const SizedBox(height: 10.0),
            getgridviewChild(context),
          ],
        ),
      ),
    );
  }

  Widget getFavAndSynchro(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: getFavPart(context)),
        Expanded(flex: 2, child: getsynchroPart(context)),
      ],
    );
  }

  Widget getsynchroPart(BuildContext context) {
    TomeRepository tomeRepo = GetIt.I.get<TomeRepository>();
    int nbSync = 0;
    for (var element in subItems) {
      File file = File(element.localfilePath);
      if (file.existsSync()) {
        nbSync++;
      } else {
        element.localfilePath = '';
        tomeRepo.updateTome(element);
      }
    }
    if (nbSync == subItems.length) {
      return const Row(
        children: [
          Icon(
            Icons.cloud_done,
            color: Colors.blue,
            size: 30.0,
          ),
          SizedBox(width: 10.0),
          Text(
            'Publication completement Synchronisé',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      );
    } else {
      return Row(children: [
        const Icon(
          Icons.cloud_download,
          color: Colors.blue,
          size: 30.0,
        ),
        const SizedBox(width: 10.0),
        Text(
          "$nbSync/${subItems.length} Tome synchronisé dans la Publication",
          style: const TextStyle(fontSize: 18.0),
        ),
      ]);
    }
  }

  Widget getFavPart(BuildContext context) {
    PublicationRepository publiRepo = GetIt.I.get<PublicationRepository>();
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            item.isFavorite = item.isFavorite == "1" ? "0" : "1";
            publiRepo.updatePublication(item);
          },
          child: Icon(
            item.isFavorite == "1" ? Icons.star : Icons.star_border,
            color: Colors.yellow,
            size: 30.0,
          ),
        ),
        const SizedBox(width: 10.0),
        Text(
          item.isFavorite == "1" ? 'Favori' : 'Ajouter aux Favoris',
          style: const TextStyle(fontSize: 18.0),
        ),
      ],
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
