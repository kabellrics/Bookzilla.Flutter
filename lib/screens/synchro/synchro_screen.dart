import 'package:bookzilla_flutter/data/service/synchro_service.dart';
import 'package:flutter/material.dart';
import '../../shared/menu_drawer.dart';

class SynchroScreen extends StatefulWidget {
  const SynchroScreen({super.key});

  @override
  State<SynchroScreen> createState() => _SynchroScreenState();
}

class _SynchroScreenState extends State<SynchroScreen> {
  final SynchroService syncService = SynchroService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Etat de la synchronisation des données')),
      drawer: const MenuDrawer(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => syncService.synchroCollection(context),
            child: const Text('Mettre à jour les Collections'),
          ),
          ElevatedButton(
              onPressed: () => syncService.synchroPublication(context),
              child: const Text('Mettre à jour les Publications')),
          ElevatedButton(
              onPressed: () => syncService.synchroTome(context),
              child: const Text('Mettre à jour les Tomes')),
        ],
      )),
    );
  }
}
