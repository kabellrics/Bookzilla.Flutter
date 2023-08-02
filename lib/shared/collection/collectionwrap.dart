import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/shared/collection/collectioncard.dart';
import 'package:flutter/material.dart';

class CollectionWrap extends StatelessWidget {
  final List<LocalCollection> items;

  CollectionWrap({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: items.map((item) => CollectionCard(item: item)).toList(),
        ),
      ),
    );
  }
}
