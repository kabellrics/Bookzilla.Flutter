import 'dart:io';

import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication_repository.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
import 'package:bookzilla_flutter/shared/helper.dart';
import 'package:bookzilla_flutter/shared/tome/tomecard.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:get_it/get_it.dart';

class PublicationDetailVertical extends StatefulWidget {
  final LocalPublication item;
  final List<LocalTome> subItems;
  const PublicationDetailVertical({required this.item, required this.subItems});

  @override
  State<PublicationDetailVertical> createState() =>
      _PublicationDetailVerticalState();
}

class _PublicationDetailVerticalState extends State<PublicationDetailVertical> {
  late FlipCardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0), // Espacement du titre
          child: Center(
            child: GestureDetector(
              onTap: () {
                _controller.toggleCard();
              },
              child: Text(
                widget.item.name, // Titre à afficher
                style: const TextStyle(
                  fontSize:
                      38.0, // Taille du texte (peut être ajustée selon vos besoins)
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: FlipCard(
              controller: _controller,
              front: getFrontCard(),
              back: getBackCard()),
        )
      ],
    );
  }

  Widget getFrontCard() {
    return GestureDetector(
      onTap: () {
        _controller.toggleCard();
      },
      child: AspectRatio(
          aspectRatio: 2 / 3,
          child: HelperImage.getPublicationImageDetail(widget.item)),
    );
  }

  Widget getBackCard() {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [getFavAndSynchro(), getGridViexChild()],
      ),
    ));
  }

  Widget getFavAndSynchro() {
    return Row(
      children: [
        Expanded(flex: 1, child: getFavPart()),
        Expanded(flex: 2, child: getsynchroPart()),
      ],
    );
  }

  Widget getsynchroPart() {
    TomeRepository tomeRepo = GetIt.I.get<TomeRepository>();
    int nbSync = 0;
    for (var element in widget.subItems) {
      File file = File(element.localfilePath);
      if (file.existsSync()) {
        nbSync++;
      } else {
        element.localfilePath = '';
        tomeRepo.updateTome(element);
      }
    }
    if (nbSync == widget.subItems.length) {
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
          "$nbSync/${widget.subItems.length} Tome synchronisé dans la Publication",
          style: const TextStyle(fontSize: 18.0),
        ),
      ]);
    }
  }

  Widget getFavPart() {
    PublicationRepository publiRepo = GetIt.I.get<PublicationRepository>();
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            widget.item.isFavorite = widget.item.isFavorite == "1" ? "0" : "1";
            publiRepo.updatePublication(widget.item);
          },
          child: Icon(
            widget.item.isFavorite == "1" ? Icons.star : Icons.star_border,
            color: Colors.yellow,
            size: 30.0,
          ),
        ),
        const SizedBox(width: 10.0),
        Text(
          widget.item.isFavorite == "1" ? 'Favori' : 'Ajouter aux Favoris',
          style: const TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }

  Widget getGridViexChild() {
    return Expanded(
      child: GridView.builder(
          itemCount: widget.subItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Nombre de colonnes
              crossAxisSpacing: 4.0, // Espacement horizontal entre les cellules
              mainAxisSpacing: 4.0,
              childAspectRatio: 2 / 3),
          itemBuilder: ((context, index) {
            return TomeCard(item: widget.subItems[index]);
          })),
    );
  }
}
