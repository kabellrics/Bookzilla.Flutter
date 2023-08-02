import 'package:bookzilla_flutter/data/api/Publication/publication.dart';
import 'package:flutter/material.dart';

class PublicationDetailPage extends StatelessWidget {
  final RemmotePublication item;

  PublicationDetailPage({required this.item});

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
