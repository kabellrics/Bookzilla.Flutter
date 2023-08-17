import 'dart:io';

import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/screens/tome/tome_detail_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TomeCard extends StatelessWidget {
  final LocalTome item;

  const TomeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Naviguez vers la page de détails de l'Item en passant l'Item en tant qu'argument
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TomeDetailPage(item: item),
          ),
        );
      },
      child: Card(
        child: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          AspectRatio(
            aspectRatio: 2.2 / 3.5,
            child: getImage(),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color:
                    Colors.grey.withOpacity(0.7), // Fond gris semi-transparent
                padding: const EdgeInsets.symmetric(vertical: 2.0),
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
      // child: ConstrainedBox(
      //   constraints: const BoxConstraints(maxHeight: 550.0, maxWidth: 300.0),
      //   child: Card(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //         AspectRatio(
      //           aspectRatio: 2 / 3,
      //           child: getImage(),
      //         ),
      //         Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: AutoSizeText(
      //               item.name,
      //               style: const TextStyle(fontSize: 25),
      //               maxLines: 2,
      //             )),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Image getImage() {
    if (item.localcoverpath != '') {
      var file = File(item.localcoverpath);
      return Image.file(
        file,
        fit: BoxFit.fitHeight,
      );
    } else {
      return Image.network(
        'http://192.168.1.17:800/${item.coverPath}',
        fit: BoxFit.cover,
      );
    }
  }
}
