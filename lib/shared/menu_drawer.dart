import 'package:bookzilla_flutter/screens/explorer/explorer_screen.dart';
import 'package:flutter/material.dart';

import '../screens/collection/collections_screen.dart';
import '../screens/intro_screen.dart';
import '../screens/publication/publications_screen.dart';
import '../screens/synchro/synchro_screen.dart';
import '../screens/tome/tomes_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: buildMenuItems(context),
      ),
    );
  }

  List<Widget> buildMenuItems(BuildContext context) {
    final Map<String, Icon> menuTitles = {
      'Home': const Icon(Icons.home_rounded),
      'Explorer': const Icon(Icons.explore_rounded),
      'Collections': const Icon(Icons.my_library_books_rounded),
      'Publications': const Icon(Icons.collections_bookmark_rounded),
      'Tomes': const Icon(Icons.book_rounded),
      'Synchro': const Icon(Icons.sync_rounded)
    };

    List<Widget> menuItems = [];
    menuItems.add(const BookzillaDrawerHeader());
    // ignore: avoid_function_literals_in_foreach_calls
    menuTitles.forEach((String key, Icon value) {
      Widget screen = Container();
      menuItems.add(ListTile(
        title: Text(
          key,
          style: const TextStyle(fontSize: 18),
        ),
        leading: value,
        onTap: () {
          switch (key) {
            case 'Home':
              // Navigator.pop(context);
              // Navigator.pushNamed(context, '/');
              screen = const IntroScreen();
              break;
            case 'Explorer':
              // Navigator.pop(context);
              // Navigator.pushNamed(context, '/');
              screen = const ExplorerScreen();
              break;
            case 'Collections':
              // Navigator.pop(context);
              // Navigator.pushNamed(context, '/Collections');
              screen = const CollectionScreen();
              break;
            case 'Publications':
              // Navigator.pop(context);
              // Navigator.pushNamed(context, '/Publications');
              screen = const PublicationScreen();
              break;
            case 'Tomes':
              // Navigator.pop(context);
              // Navigator.pushNamed(context, '/Tomes');
              screen = const TomeScreen();
              break;
            case 'Synchro':
              // Navigator.pop(context);
              // Navigator.pushNamed(context, '/Synchro');
              screen = const SynchroScreen();
              break;
            default:
          }
          Navigator.of(context).pop();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => screen));
        },
      ));
    });
    return menuItems;
  }
}

class BookzillaDrawerHeader extends StatelessWidget {
  const BookzillaDrawerHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.blue),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          const Text('Bookzilla',
              style: TextStyle(color: Colors.white, fontSize: 28)),
        ],
      ),
    );
    // return const DrawerHeader(
    //   decoration: BoxDecoration(color: Colors.blueGrey),
    //   child: Text('Bookzilla',
    //       style: TextStyle(color: Colors.white, fontSize: 28)),
    // );
  }
}
