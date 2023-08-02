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
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 550.0, maxWidth: 300.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 2 / 3,
                child: getImage(),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    item.name,
                    style: const TextStyle(fontSize: 25),
                    maxLines: 2,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Image getImage() {
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
}
