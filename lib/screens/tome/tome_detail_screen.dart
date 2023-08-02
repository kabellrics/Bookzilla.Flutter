import 'package:bookzilla_flutter/data/api/Tome/tome.dart';
import 'package:flutter/material.dart';

class TomeDetailPage extends StatelessWidget {
  final RemoteTome item;

  TomeDetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: const Center(child: FlutterLogo()),
    );
  }
}
