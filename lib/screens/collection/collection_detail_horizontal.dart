import 'package:bookzilla_flutter/data/api/Collection/collection.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection.dart';
import 'package:bookzilla_flutter/data/local/Collection/collection_repository.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CollectionDetailHorizontal extends StatelessWidget {
  final RemoteCollection item;
  const CollectionDetailHorizontal({required this.item});

  Future<List<LocalCollection>> getSubCollection() async {
    CollectionRepository collectionRepo = GetIt.I.get<CollectionRepository>();
    var collecs = await collectionRepo.getAllCollections();
    return collecs.where((element) => element.parentid == item.id).toList();
  }

  Future<List<LocalPublication>> getSubPublication() async {
    PublicationRepository publiRepo = GetIt.I.get<PublicationRepository>();
    var publics = await publiRepo.getAllPublications();
    return publics.where((element) => element.collectionId == item.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
