import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: ShowCaseWidget(
          builder: Builder(
              builder: (context) =>
                  const MyHomePage(title: 'Stream Controller with Showcase')),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey reset = GlobalKey();
  final GlobalKey increament = GlobalKey();
  final GlobalKey decreament = GlobalKey();
  final GlobalKey search = GlobalKey();
  final GlobalKey numberDisplay = GlobalKey();
  int counter = 0;
  final StreamController<int> streamController = StreamController<int>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowCaseWidget.of(context).startShowCase(
          [reset, search, numberDisplay, increament, decreament]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Showcase(
              key: search,
              description: 'Tap to search item',
              overlayOpacity: 0.5,
              targetShapeBorder: const CircleBorder(),
              targetPadding: const EdgeInsets.all(8),
              child: const Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
                initialData: 0,
                stream: streamController.stream,
                builder: (context, snapshot) {
                  return Showcase(
                    key: numberDisplay,
                    description:
                        'It displays the number after increment and decrement',
                    overlayOpacity: 0.5,
                    child: Text(
                      'Number: ${snapshot.data} ',
                      style: const TextStyle(fontSize: 30, color: Colors.green),
                    ),
                  );
                }),
            Showcase(
              key: increament,
              description: 'Tap to Increase the number',
              overlayOpacity: 0.5,
              child: ElevatedButton(
                  onPressed: () {
                    streamController.sink.add(++counter);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  child: const Text(
                    "Increase Number",
                  )),
            ),
            Showcase(
              key: decreament,
              description: 'Tap to Decrease the number',
              overlayOpacity: 0.5,
              child: ElevatedButton(
                  onPressed: () {
                    streamController.sink.add(--counter);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  child: const Text(
                    "decrease Number",
                  )),
            ),
          ],
        ),
      ),
      floatingActionButton: Showcase(
        key: reset,
        description: 'Tap to reset the number',
        overlayOpacity: 0.5,
        targetShapeBorder: const CircleBorder(),
        child: FloatingActionButton(
          onPressed: () {
            streamController.sink.add(counter = 0);
          },
          tooltip: 'Increment',
          child: const Text(
            'Reset',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
