import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/widgets/tag/tag_grid_widget.dart';
import 'beamer/location_builders.dart';
import 'utils/theme/theme_notifier.dart';

void main() {
  //Beamer.setPathUrlStrategy();
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: MyApp(),
  ));
}

Map<ShortcutActivator, Intent> getShortcut() {
  var shortcuts = WidgetsApp.defaultShortcuts;
  shortcuts[LogicalKeySet(LogicalKeyboardKey.space)] = const ActivateIntent();
  return shortcuts;
}

//Just for test
// void main() => runApp(VideoPlayerApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final routerDelegate = BeamerDelegate(
    initialPath: '/feed',
    locationBuilder: simpleLocationBuilder,
  );

  @override
  Widget build(BuildContext context) {
    // Map<ShortcutActivator, Intent> shortcuts =
    //     Map.from(WidgetsApp.defaultShortcuts);

    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      Map<ShortcutActivator, Intent> shortcuts = {
        ...WidgetsApp.defaultShortcuts
      };
      // shortcuts[LogicalKeySet(LogicalKeyboardKey.space)] = const ActivateIntent();
      shortcuts.remove(LogicalKeySet(LogicalKeyboardKey.space));
      return MaterialApp.router(
        shortcuts: shortcuts,
        debugShowCheckedModeBanner: false,
        theme: theme.getTheme(),
        routerDelegate: routerDelegate,
        routeInformationParser: BeamerParser(),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Hybrid Theme'),
        ),
        body: Row(
          children: [
            Container(
              color: Theme.of(context).colorScheme.secondary,
              child: TextButton(
                onPressed: () => {
                  print('Set Light Theme'),
                  theme.setLightMode(),
                },
                child: const Text('Set Light Theme'),
              ),
            ),
            TextButton(
              onPressed: () => {
                print('Set Dark theme'),
                theme.setDarkMode(),
                Beamer.of(context).beamToNamed('/whatch'),
              },
              child: const Text('Set Dark theme'),
            ),
            TextButton(
              onPressed: () => {
                print('openTagMenu'),
                showDialog(
                  context: context,
                  builder: (context) => const TagGridLargeScreen(),
                ).then((value) => print(value))
              },
              child: const Text('Open Tag Menu'),
            ),
            TextButton(
              onPressed: () => {
                print('uploadVideo'),
                Beamer.of(context).beamToNamed('uploadvideotest')
              },
              child: const Text('Upload Video'),
            ),
          ],
        ),
      ),
    );
  }
}
