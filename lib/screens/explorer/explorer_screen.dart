import 'package:bookzilla_flutter/screens/explorer/column_explorer.dart';
import 'package:bookzilla_flutter/screens/explorer/row_explorer.dart';
import 'package:bookzilla_flutter/shared/menu_drawer.dart';
import 'package:flutter/material.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorer')),
      drawer: const MenuDrawer(),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return ColumnExplorer();
        } else {
          return RowExplorer();
        }
      }),
    );
  }
}
