import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome_repository.dart';
import 'package:bookzilla_flutter/shared/tome/tomewrap.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../shared/menu_drawer.dart';

class TomeScreen extends StatefulWidget {
  const TomeScreen({super.key});

  @override
  State<TomeScreen> createState() => _TomeScreenState();
}

class _TomeScreenState extends State<TomeScreen> {
  final TomeRepository tomeRepo = GetIt.I.get<TomeRepository>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Tomes')),
        drawer: const MenuDrawer(),
        body: FutureBuilder<List<LocalTome>>(
            future: tomeRepo.getAllTomes(),
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
                return TomeWrap(items: items);
              } else {
                // Cas où le Future est null
                return const Center(
                  child: Text('Aucune donnée.'),
                );
              }
            }));
  }
}
