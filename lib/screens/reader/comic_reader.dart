import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ComicReader extends StatefulWidget {
  final LocalTome item;
  final List<LocalTome> items;
  const ComicReader({required this.item, required this.items});
  int getstartindex() {
    return items.indexWhere((element) => element.id == item.id);
  }

  @override
  State<ComicReader> createState() => _ComicReaderState();
}

class _ComicReaderState extends State<ComicReader> {
  late int currentIndex;
  late List<String> imagePaths;
  late LocalTome currentTome;

  @override
  void dispose() {
    currentTome.currentPage = currentIndex.toString();
    super.dispose();
  }

  Future<List<String>> _extractImages() async {
    final zipBytes = File(widget.item.localfilePath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(zipBytes);

    final extractionPath = await _getExtractionPath();

    imagePaths = [];
    for (final file in archive) {
      if (file.isFile) {
        final data = file.content as List<int>;
        final imagePath = '$extractionPath/${file.name}';
        File(imagePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
        imagePaths.add(imagePath);
      }
    }

    imagePaths.sort((a, b) => a.split('/').last.compareTo(b.split('/').last));
    return imagePaths;
    // setState(() {});
  }

  Future<String> _getExtractionPath() async {
    final appDir = await getTemporaryDirectory();
    final extractionDir = '${appDir.path}/readingPages/${widget.item.name}';
    return extractionDir;
  }

  @override
  Widget build(BuildContext context) {
    currentTome = widget.item;
    // return const Placeholder();
    return Scaffold(
      appBar: AppBar(title: const Text('Lecteur')),
      body: FutureBuilder<List<String>>(
          future: _extractImages(),
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
              List<String> items = snapshot.data!;
              return PhotoViewGallery.builder(
                itemCount: items.length,
                builder: (context, index) {
                  currentIndex = index;
                  return PhotoViewGalleryPageOptions(
                    imageProvider: FileImage(File(items[index])),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
              );
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
