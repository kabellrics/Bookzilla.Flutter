import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/screens/tome/tome_detail_screen.dart';
import 'package:bookzilla_flutter/shared/tome/tomecard.dart';
import 'package:flutter/material.dart';

class TomeGrid extends StatelessWidget {
  final List<LocalTome> items;
  const TomeGrid({required this.items});

  Image getImage(LocalTome item) {
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
              return TomeCard(item: items[index]);
              // return GestureDetector(
              //   onTap: () {
              //     // Naviguez vers la page de détails de l'Item en passant l'Item en tant qu'argument
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => TomeDetailPage(item: items[index]),
              //       ),
              //     );
              //   },
              //   child:                 Card(
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
