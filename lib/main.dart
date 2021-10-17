import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uidraft1/tests/video_player_with_quality_test.dart';
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

//Just for test
// void main() => runApp(VideoPlayerApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final routerDelegate = BeamerDelegate(
    initialPath: '/',
    locationBuilder: simpleLocationBuilder,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) =>
            // MaterialApp(
            //   theme: theme.getTheme(),
            //   debugShowCheckedModeBanner: false,
            //   // home: const MyHomePage(
            //   //   title: "test",
            //   // ),
            //   initialRoute: '/feed',
            //   routes: {
            //     // '/': (context) => SignUpScreen(),
            //     // '/login': (context) => LoginScreen(),
            //     // '/video': (context) => ChapterVideoPlayer(),
            //     // '/welcome': (context) => WelcomeScreen(),
            //     // '/responsive': (context) => ResponsiveTestScreen(),
            //     // '/isauth': (context) => const ShowUserData(),
            //     '/feed': (context) => const FeedScreen(),
            //     // '/uploadvideo': (context) => const UploadVideoScreen(),
            //   },
            // ),
            MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: theme.getTheme(),
              routerDelegate: routerDelegate,
              routeInformationParser: BeamerParser(),
            ));
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
          ],
        ),
      ),
    );
  }
}
