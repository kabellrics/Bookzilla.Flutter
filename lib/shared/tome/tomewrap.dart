import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/shared/tome/tomecard.dart';
import 'package:flutter/material.dart';

class TomeWrap extends StatelessWidget {
  final List<LocalTome> items;

  TomeWrap({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: items.map((item) => TomeCard(item: item)).toList(),
        ),
      ),
    );
  }
}
