import 'dart:io';

import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/screens/collection/collection_detail_screen.dart';
import 'package:flutter/material.dart';

class CollectionGrid extends StatelessWidget {
  final List<LocalCollection> items;
  const CollectionGrid({required this.items});

  Widget getImage(LocalCollection item) {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OrientationBuilder(builder: (context, orientation) {
        int crossAxisCount = orientation == Orientation.portrait ? 2 : 2;
        var axis = orientation == Orientation.portrait
            ? Axis.vertical
            : Axis.horizontal;
        return GridView.builder(
            itemCount: items.length,
            scrollDirection: axis,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // Nombre de colonnes
              crossAxisSpacing: 4.0, // Espacement horizontal entre les cellules
              mainAxisSpacing: 4.0, // Espacement vertical entre les cellules
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Naviguez vers la page de détails de l'Item en passant l'Item en tant qu'argument
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CollectionDetailPage(item: items[index]),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: getImage(items[index]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          items[index].name,
                          style: const TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
