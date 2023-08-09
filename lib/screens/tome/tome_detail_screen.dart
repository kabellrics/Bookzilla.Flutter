import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
import 'package:bookzilla_flutter/screens/tome/tome_detail_slider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TomeDetailPage extends StatelessWidget {
  final LocalTome item;

  TomeDetailPage({required this.item});

  Future<List<LocalTome>> getAllTomesOfPubli() async {
    TomeRepository tomeRepo = GetIt.I.get<TomeRepository>();
    var tomes = await tomeRepo.getAllTomes();
    return tomes.where((x) => x.publicationId == item.publicationId).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: FutureBuilder<List<LocalTome>>(
          future: getAllTomesOfPubli(),
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
              List<LocalTome> items = snapshot.data!;
              return TomeDetailSlider(item: item, items: items);
            } else {
              // Cas où le Future est null
              return const Center(
                child: Text('Aucune donnée.'),
              );
            }
          }),
    );
  }
}
