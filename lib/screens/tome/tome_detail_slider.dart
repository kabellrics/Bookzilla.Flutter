import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
import 'package:bookzilla_flutter/data/service/book_downloader_service.dart';
import 'package:bookzilla_flutter/shared/helper.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get_it/get_it.dart';
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
  final TomeRepository tomeRepo = GetIt.I.get<TomeRepository>();
  final BookDownloader bookDownloader = GetIt.I.get<BookDownloader>();

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
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      double sizeKB = bytes / 1024;
      return ' ${sizeKB.toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      double sizeMB = bytes / (1024 * 1024);
      return '${sizeMB.toStringAsFixed(2)} MB';
    } else {
      double sizeGB = bytes / (1024 * 1024 * 1024);
      return '${sizeGB.toStringAsFixed(2)} GB';
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
      padding: const EdgeInsets.all(1.0),
      child: Row(
        children: [
          Expanded(flex: 1, child: getCoverImage(item)),
          Expanded(flex: 2, child: getTomeInfo(context, item))
        ],
      ),
    );
  }

  AspectRatio getCoverImage(LocalTome item) {
    return AspectRatio(
        aspectRatio: 2 / 3, child: HelperImage.getTomeImage(item));
  }

  Widget showTitleAndText(String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          title.trim(),
          style: const TextStyle(fontSize: 30),
          maxLines: 1,
          textAlign: TextAlign.left,
        ),
        // Text(
        //   text.trim(),
        //   maxLines: 6,
        //   softWrap: true,
        //   textAlign: TextAlign.justify,
        //   style: const TextStyle(fontSize: 20),
        // )
        AutoSizeText(
          text.trim(),
          style: const TextStyle(fontSize: 20),
          maxLines: 6,
          textAlign: TextAlign.left,
        )
      ],
    );
  }

  Widget getTomeInfo(BuildContext context, LocalTome item) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: AutoSizeText(
            item.name,
            style: const TextStyle(fontSize: 45),
            maxLines: 2,
            textAlign: TextAlign.center,
          )),
          showTitleAndText(
              'Numéro dans la publication :', item.orderInPublication),
          showTitleAndText('Auteur(s) :', item.auteur),
          showTitleAndText('Taille :', formatFileSize(int.parse(item.size))),
          showTitleAndText('Date de Publication :', item.publicationDate),
          showTitleAndText('Description :', item.description),
          // AutoSizeText(
          //   showNumOrder(item),
          //   style: const TextStyle(fontSize: 25),
          //   maxLines: 2,
          // ),
          // AutoSizeText(
          //   showReadingStatus(item),
          //   style: const TextStyle(fontSize: 25),
          //   maxLines: 2,
          // ),
          // AutoSizeText(
          //   formatFileSize(int.parse(item.size)),
          //   style: const TextStyle(fontSize: 25),
          //   maxLines: 2,
          // ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    item.isFavorite = item.isFavorite == "1" ? "0" : "1";
                    tomeRepo.updateTome(item);
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
                    bookDownloader.downloadInLocal(item);
                  });
                },
                child: Icon(
                  !item.localfilePath.contains('temporary') &&
                          item.localfilePath != ''
                      ? Icons.cloud_done
                      : Icons.cloud_download,
                  color: Colors.blue,
                  size: 30.0,
                ),
              ),
              const SizedBox(width: 10.0),
              Text(
                !item.localfilePath.contains('temporary') &&
                        item.localfilePath != ''
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
      ),
    );
  }
}
