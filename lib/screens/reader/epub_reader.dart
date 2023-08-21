import 'dart:io';

import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';

class EpubReader extends StatefulWidget {
  final LocalTome item;
  const EpubReader({required this.item});

  @override
  State<EpubReader> createState() => _EpubReaderState();
}

class _EpubReaderState extends State<EpubReader> {
  late EpubController _epubController;

  @override
  void initState() {
    super.initState();
    if (widget.item.cfi_EPUB == '') {
      _epubController = EpubController(
        // Load document
        document: EpubDocument.openFile(File(widget.item.localfilePath)),
      );
    } else {
      _epubController = EpubController(
        // Load document
        document: EpubDocument.openFile(File(widget.item.localfilePath)),
        // Set start point
        epubCfi: widget.item.cfi_EPUB,
      );
    }
  }

  @override
  void dispose() {
    try {
      widget.item.cfi_EPUB = _epubController.generateEpubCfi()!;
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Show actual chapter name
        title: EpubViewActualChapter(
            controller: _epubController,
            builder: (chapterValue) => Text(
                  'Chapitre: ${chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? ''}',
                  textAlign: TextAlign.center,
                )),
      ),
      drawer: Drawer(
        child: EpubViewTableOfContents(controller: _epubController),
      ),
      body: EpubView(
        controller: _epubController,
      ),
    );
  }
}
