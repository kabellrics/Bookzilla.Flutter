import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection_repository.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication_repository.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ColumnExplorer extends StatelessWidget {
  final int crossAxisCount;
  final double aspectratiocover;
  final Axis axis;
  ColumnExplorer(
      {required this.crossAxisCount,
      required this.aspectratiocover,
      required this.axis});

  final CollectionRepository collectionRepo =
      GetIt.I.get<CollectionRepository>();

  final PublicationRepository publiRepo = GetIt.I.get<PublicationRepository>();

  final TomeRepository tomeRepo = GetIt.I.get<TomeRepository>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [],
    );
  }
}
