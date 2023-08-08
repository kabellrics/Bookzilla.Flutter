import 'package:bookzilla_flutter/data/api/Tome/tome.dart';
import 'package:bookzilla_flutter/data/local/Tome/tome.dart';
import 'package:flutter/material.dart';

class TomeDetailVertical extends StatefulWidget {
  final LocalTome item;
  final List<LocalTome> items;
  // ignore: use_key_in_widget_constructors
  const TomeDetailVertical({required this.item, required this.items});

  @override
  State<TomeDetailVertical> createState() => _TomeDetailVerticalState();
}

class _TomeDetailVerticalState extends State<TomeDetailVertical> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();

    currentIndex =
        widget.items!.indexWhere((element) => element.id == widget.item!.id);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
