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
bool isFavorite = false; 
  bool isDownloaded = false;

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
String formatFileSize(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  } else if (bytes < 1024 * 1024) {
    double sizeKB = bytes / 1024;
    return '${sizeKB.toStringAsFixed(2)} KB';
  } else if (bytes < 1024 * 1024 * 1024) {
    double sizeMB = bytes / (1024 * 1024);
    return '${sizeMB.toStringAsFixed(2)} MB';
  } else {
    double sizeGB = bytes / (1024 * 1024 * 1024);
    return '${sizeGB.toStringAsFixed(2)} GB';
  }
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
      mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: AutoSizeText(
          widget.items[currentIndex].name,
          style: const TextStyle(fontSize: 50),
          maxLines: 2,textAlign: TextAlign.center,
        )),
        AutoSizeText(
          ShowNumOrder(),
          style: const TextStyle(fontSize: 25),
          maxLines: 2,
        ),
        AutoSizeText(
          ShowReadingStatus(),
          style: const TextStyle(fontSize: 25),
          maxLines: 2,
        ),
        AutoSizeText(
          ShowFavorite(),
          style: const TextStyle(fontSize: 25),
          maxLines: 2,
        ),
        AutoSizeText(
          formatFileSize(int.parse(widget.items[currentIndex].size)),
          style: const TextStyle(fontSize: 25),
          maxLines: 2,
        ),Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite; // Inverser l'état des favoris
                      });
                    },
                    child: Icon(
                      isFavorite
                          ? Icons.star // Étoile remplie si en favori
                          : Icons.star_border, // Contour d'étoile sinon
                      color: Colors.yellow,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    isFavorite ? 'Favori' : 'Ajouter aux Favoris',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isDownloaded = !isDownloaded; // Inverser l'état de téléchargement
                      });
                    },
                    child: Icon(
                      isDownloaded
                          ? Icons.cloud_done // Icône de téléchargement réussi
                          : Icons.cloud_download, // Icône de téléchargement
                      color: Colors.blue,
                      size: 30.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    isDownloaded ? 'Téléchargé' : 'Télécharger',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
      ],
    );
  }
}
