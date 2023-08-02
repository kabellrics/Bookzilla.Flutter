import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/shared/publication/publicationcard.dart';
import 'package:flutter/material.dart';

class PublicationWrap extends StatelessWidget {
  final List<LocalPublication> items;

  PublicationWrap({required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: items.map((item) => PublicationCard(item: item)).toList(),
        ),
      ),
    );
  }
}
