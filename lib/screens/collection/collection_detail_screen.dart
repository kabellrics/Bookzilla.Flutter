import 'package:bookzilla_flutter/data/api/Collection/collection.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/screens/collection/collection_detail_horizontal.dart';
import 'package:bookzilla_flutter/screens/collection/collection_detail_vertical.dart';
import 'package:flutter/material.dart';

class CollectionDetailPage extends StatelessWidget {
  final LocalCollection item;

  CollectionDetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return CollectionDetailVertical(item: item);
        } else {
          return CollectionDetailHorizontal(item: item);
        }
      }),
    );
  }
}
