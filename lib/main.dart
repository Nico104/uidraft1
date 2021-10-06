import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/theme/theme_notifier.dart';

void main() {
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => MaterialApp(
        theme: theme.getTheme(),
        //debugShowCheckedModeBanner: false,
        home: const MyHomePage(
          title: "test",
        ),
      ),
    );
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
              },
              child: const Text('Set Dark theme'),
            ),
          ],
        ),
      ),
    );
  }
}
