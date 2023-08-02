import 'dart:io';

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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 350.0, maxWidth: 500.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: getImage(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item.name,
                  style: const TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getImage() {
    if (item.localfanartpath != '') {
      var file = File(item.localfanartpath);
      return Image.file(
        file,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        'http://192.168.1.17:800/${item.fanartpath}',
        fit: BoxFit.cover,
      );
    }
  }
}
