import 'package:bookzilla_flutter/data/api/Collection/collection.dart';
import 'package:flutter/material.dart';

class CollectionDetailPage extends StatelessWidget {
  final RemoteCollection item;

  CollectionDetailPage({required this.item});

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
