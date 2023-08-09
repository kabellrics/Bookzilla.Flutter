import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/shared/helper.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path_provider/path_provider.dart';

class TomeDetailSlider extends StatefulWidget {
  final LocalTome item;
  final List<LocalTome> items;
  const TomeDetailSlider({required this.item, required this.items});
  int getstartindex() {
    return items.indexWhere((element) => element.id == item.id);
  }

  @override
  State<TomeDetailSlider> createState() => _TomeDetailSliderState();
}

class _TomeDetailSliderState extends State<TomeDetailSlider> {
  late int currentIndex;
  bool isDownloaded = false;
  late FlipCardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
  }

  void getstartindex() {
    currentIndex = widget.getstartindex();
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return 'Taille du fichier : $bytes B';
    } else if (bytes < 1024 * 1024) {
      double sizeKB = bytes / 1024;
      return 'Taille du fichier : ${sizeKB.toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      double sizeMB = bytes / (1024 * 1024);
      return 'Taille du fichier : ${sizeMB.toStringAsFixed(2)} MB';
    } else {
      double sizeGB = bytes / (1024 * 1024 * 1024);
      return 'Taille du fichier : ${sizeGB.toStringAsFixed(2)} GB';
    }
  }

  String showNumOrder(LocalTome item) {
    return 'Numéro :${item.orderInPublication}';
  }

  String showReadingStatus(LocalTome item) {
    switch (item.readingStatusId) {
      case "1":
        return 'Statut : Non lu';
      case "2":
        return 'Statut : Lecture en cours';
      case "3":
        return 'Statut : Lu';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    getstartindex();
    return OrientationBuilder(builder: ((context, orientation) {
      final double height = MediaQuery.of(context).size.height;
      return CarouselSlider.builder(
        itemCount: widget.items.length,
        options: CarouselOptions(
            height: height,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: false,
            initialPage: currentIndex),
        itemBuilder: (context, index, realIndex) {
          if (orientation == Orientation.portrait) {
            return buildVerticalItem(context, widget.items[index]);
          } else {
            return buildHorizontalItem(context, widget.items[index]);
          }
        },
      );
    }));
  }

  Widget buildVerticalItem(BuildContext context, LocalTome item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlipCard(
          controller: _controller,
          front: GestureDetector(
              onTap: () {
                _controller.toggleCard();
              },
              child: getCoverImage(item)),
          back: getTomeInfo(context, item)),
    );
  }

  Widget buildHorizontalItem(BuildContext context, LocalTome item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [getCoverImage(item), getTomeInfo(context, item)],
      ),
    );
  }

  AspectRatio getCoverImage(LocalTome item) {
    return AspectRatio(
        aspectRatio: 2 / 3, child: HelperImage.getTomeImage(item));
  }

  Widget getTomeInfo(BuildContext context, LocalTome item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: AutoSizeText(
          item.name,
          style: const TextStyle(fontSize: 50),
          maxLines: 2,
          textAlign: TextAlign.center,
        )),
        AutoSizeText(
          showNumOrder(item),
          style: const TextStyle(fontSize: 25),
          maxLines: 2,
        ),
        AutoSizeText(
          showReadingStatus(item),
          style: const TextStyle(fontSize: 25),
          maxLines: 2,
        ),
        AutoSizeText(
          formatFileSize(int.parse(item.size)),
          style: const TextStyle(fontSize: 25),
          maxLines: 2,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  item.isFavorite = item.isFavorite == "1" ? "0" : "1";
                });
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
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isDownloaded = !isDownloaded;
                });
              },
              child: Icon(
                !item.localfilePath.contains('tmp') && item.localfilePath != ''
                    ? Icons.cloud_done
                    : Icons.cloud_download,
                color: Colors.blue,
                size: 30.0,
              ),
            ),
            const SizedBox(width: 10.0),
            Text(
              !item.localfilePath.contains('tmp') && item.localfilePath != ''
                  ? 'Tome Synchronisé'
                  : 'Tome Non Synchronisé',
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            Icon(
              item.isEpub == "1" ? Icons.book : Icons.book_online,
              color: Colors.green,
              size: 30.0,
            ),
            const SizedBox(width: 10.0),
            Text(
              item.isEpub == "1" ? 'Livre' : 'Comics',
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ],
    );
  }
}
