import 'package:bookzilla_flutter/data/api/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
import 'package:bookzilla_flutter/screens/publication/publication_detail_horizontal.dart';
import 'package:bookzilla_flutter/screens/publication/publication_detail_vertical.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PublicationDetailPage extends StatelessWidget {
  final LocalPublication item;

  Future<List<LocalTome>> getChildTomes() async {
    TomeRepository tomeRepo = GetIt.I.get<TomeRepository>();
    var tomes = await tomeRepo.getAllTomes();
    return tomes.where((element) => element.publicationId == item.id).toList();
  }

  PublicationDetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(item.name),
        ),
        body: FutureBuilder<List<LocalTome>>(
            future: getChildTomes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child:
                      CircularProgressIndicator(), // Afficher un indicateur de chargement pendant l'attente
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Erreur lors du chargement des données.'),
                );
              } else if (snapshot.hasData) {
                List<LocalTome> subItems = snapshot.data!;
                return OrientationBuilder(builder: (context, orientation) {
                  if (orientation == Orientation.portrait) {
                    return PublicationDetailVertical(
                        item: item, subItems: subItems);
                  } else {
                    return PublicationDetailHorizontal(
                        item: item, subItems: subItems);
                  }
                });
              } else {
                // Cas où le Future est null
                return const Center();
              }
            }));
  }
}
