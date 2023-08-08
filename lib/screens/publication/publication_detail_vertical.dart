import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/shared/helper.dart';
import 'package:bookzilla_flutter/shared/tome/tomecard.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

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
    return GridView.builder(
        itemCount: widget.subItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Nombre de colonnes
            crossAxisSpacing: 4.0, // Espacement horizontal entre les cellules
            mainAxisSpacing: 4.0,
            childAspectRatio: 2 / 3),
        itemBuilder: ((context, index) {
          return TomeCard(item: widget.subItems[index]);
        }));
  }
}
