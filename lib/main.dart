import 'package:bookzilla_flutter/init.dart';
import 'package:bookzilla_flutter/screens/intro_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BookzillaClient());
}

class BookzillaClient extends StatefulWidget {
  const BookzillaClient({super.key});

  @override
  State<BookzillaClient> createState() => _BookzillaClientState();
}

class _BookzillaClientState extends State<BookzillaClient> {
  final Future _init = Init.initialize();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: FutureBuilder(
            future: _init,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const IntroScreen();
              } else {
                return const Material(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }));
  }
}
