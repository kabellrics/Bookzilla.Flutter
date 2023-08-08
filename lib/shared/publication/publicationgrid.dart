import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/screens/publication/publication_detail_screen.dart';
import 'package:bookzilla_flutter/shared/publication/publicationcard.dart';
import 'package:flutter/material.dart';

class PublicationGrid extends StatelessWidget {
  final List<LocalPublication> items;
  const PublicationGrid({required this.items});

  Image getImage(LocalPublication item) {
    if (item.localcoverpath != '') {
      var file = File(item.localcoverpath);
      return Image.file(
        file,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        'http://192.168.1.17:800/${item.coverPath}',
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OrientationBuilder(builder: ((context, orientation) {
        int crossAxisCount = orientation == Orientation.portrait ? 2 : 1;
        var axis = orientation == Orientation.portrait
            ? Axis.vertical
            : Axis.horizontal;
        return GridView.builder(
            itemCount: items.length,
            scrollDirection: axis,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, // Nombre de colonnes
                crossAxisSpacing:
                    4.0, // Espacement horizontal entre les cellules
                mainAxisSpacing: 4.0, // Espacement vertical entre les cellules
                childAspectRatio:
                    orientation == Orientation.portrait ? 2 / 3 : 3 / 2),
            itemBuilder: ((context, index) {
              return PublicationCard(item: items[index]);
              // return GestureDetector(
              //   onTap: () {
              //     // Naviguez vers la page de détails de l'Item en passant l'Item en tant qu'argument
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) =>
              //             PublicationDetailPage(item: items[index]),
              //       ),
              //     );
              //   },
              //   child: Card(
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         AspectRatio(
              //           aspectRatio: 2 / 3,
              //           child: getImage(items[index]),
              //         ),
              //         Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: AutoSizeText(
              //               items[index].name,
              //               style: const TextStyle(fontSize: 25),
              //               maxLines: 2,
              //             )),
              //       ],
              //     ),
              //   ),
              // );
            }));
      })),
    );
  }
}
