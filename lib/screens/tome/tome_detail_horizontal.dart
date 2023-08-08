import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookzilla_flutter/data/api/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/shared/helper.dart';
import 'package:flutter/material.dart';

class TomeDetailHorizontal extends StatefulWidget {
  final LocalTome item;
  final List<LocalTome> items;
  // ignore: use_key_in_widget_constructors
  const TomeDetailHorizontal({required this.item, required this.items});
  int getstartindex() {
    return items.indexWhere((element) => element.id == item.id);
  }

  @override
  State<TomeDetailHorizontal> createState() => _TomeDetailHorizontalState();
}

class _TomeDetailHorizontalState extends State<TomeDetailHorizontal> {
  late int currentIndex;

  void getstartindex() {
    currentIndex = widget.getstartindex();
  }

  @override
  Widget build(BuildContext context) {
    getstartindex();
    return Row(
      children: [
        AspectRatio(
            aspectRatio: 2 / 3,
            child: HelperImage.getTomeImage(widget.items[currentIndex])),
        getRightPart(context)
      ],
    );
  }

  String ShowNumOrder() {
    return 'Numéro :' + widget.items[currentIndex].orderInPublication;
  }

  String ShowReadingStatus() {
    switch (widget.items[currentIndex].readingStatusId) {
      case "1":
        return 'Non lu';
      case "2":
        return 'Lecture en cours';
      case "3":
        return 'Lu';
      default:
        return '';
    }
  }

  String ShowFavorite() {
    switch (widget.items[currentIndex].readingStatusId) {
      case "0":
        return '';
      case "1":
        return 'Favoris';
      default:
        return '';
    }
  }

  Widget getRightPart(BuildContext context) {
    return Column(
      children: [
        Center(
            child: AutoSizeText(
          widget.items[currentIndex].name,
          style: const TextStyle(fontSize: 50),
          maxLines: 2,
        )),
        Center(
            child: AutoSizeText(
          ShowNumOrder(),
          style: const TextStyle(fontSize: 25),
          maxLines: 2,
        )),
        Center(
            child: AutoSizeText(
          ShowReadingStatus(),
          style: const TextStyle(fontSize: 25),
          maxLines: 2,
        )),
        Center(
            child: AutoSizeText(
          ShowFavorite(),
          style: const TextStyle(fontSize: 25),
          maxLines: 2,
        )),
        Center(
            child: AutoSizeText(
          widget.items[currentIndex].size,
          style: const TextStyle(fontSize: 25),
          maxLines: 2,
        )),
        // Center(
        //   child: const ElevatedButton(
        //     onPressed: () {},
        //     child: AutoSizeText(
        //       'Lire',
        //       style: TextStyle(fontSize: 25),
        //       maxLines: 2,
        //     ),
        //   ),
        // ),
        // Center(
        //   child: const ElevatedButton(
        //     onPressed: () {},
        //     child: AutoSizeText(
        //       'Favori',
        //       style: TextStyle(fontSize: 25),
        //       maxLines: 2,
        //     ),
        //   ),
        // ),
        // Center(
        //   child: const ElevatedButton(
        //     onPressed: () {},
        //     child: AutoSizeText(
        //       'Télécharger',
        //       style: TextStyle(fontSize: 25),
        //       maxLines: 2,
        //     ),
        //   ),
        // )
      ],
    );
  }
}
