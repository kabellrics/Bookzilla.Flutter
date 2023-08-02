import 'package:bookzilla_flutter/data/local/Publication/publication.dart';
import 'package:bookzilla_flutter/data/local/Publication/publication_repository.dart';
import 'package:bookzilla_flutter/shared/publication/publicationwrap.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../shared/menu_drawer.dart';

class PublicationScreen extends StatefulWidget {
  const PublicationScreen({super.key});

  @override
  State<PublicationScreen> createState() => _PublicationScreenState();
}

class _PublicationScreenState extends State<PublicationScreen> {
  final PublicationRepository publiRepo = GetIt.I.get<PublicationRepository>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Publications')),
        drawer: const MenuDrawer(),
        body: FutureBuilder<List<LocalPublication>>(
            future: publiRepo.getAllPublications(),
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
                List<LocalPublication> items = snapshot.data!;
                return PublicationWrap(items: items);
              } else {
                // Cas où le Future est null
                return const Center(
                  child: Text('Aucune donnée.'),
                );
              }
            }));
  }
}
