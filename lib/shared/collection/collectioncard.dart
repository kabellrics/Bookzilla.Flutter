import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/screens/collection/collection_detail_screen.dart';
import 'package:flutter/material.dart';

class CollectionCard extends StatelessWidget {
  final LocalCollection item;

  const CollectionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Naviguez vers la page de détails de l'Item en passant l'Item en tant qu'argument
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CollectionDetailPage(item: item),
          ),
        );
      },
      child: Card(
        child: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: getImage(),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color:
                    Colors.grey.withOpacity(0.7), // Fond gris semi-transparent
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      item.name,
                      style: const TextStyle(fontSize: 25),
                      maxLines: 2,
                    )),
              ))
        ]),
      ),
    );
  }

  Widget getImage() {
    if (item.localfanartpath != '') {
      var file = File(item.localfanartpath);
      return Image.file(
        file,
        fit: BoxFit.fitHeight,
      );
    } else {
      return Image.network(
        'http://192.168.1.17:800/${item.fanartpath}',
        fit: BoxFit.cover,
      );
    }
  }
}
