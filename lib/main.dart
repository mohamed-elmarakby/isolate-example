import 'dart:developer';

import 'package:flutter/material.dart';
import 'constants.dart';
import 'service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isolates Usage Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Isolates Usage Demo'),
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
  int _counter = 0;
  TestingInterface? interface;
  bool withoutIsolatesEnabled = true;
  bool withIsolatesEnabled = true;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            const Text(
              'Total Sum',
              style: TextStyle(
                fontSize: 21,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              width: width * 0.75,
              child: ElevatedButton(
                onPressed: withoutIsolatesEnabled
                    ? () async {
                        setState(() {
                          _counter = 0;
                          withoutIsolatesEnabled = false;
                          log('Restarted Counter: $_counter');
                        });
                        interface = NoIsolate(
                            limit: 500000000, status: Status.noIsolate);
                        _counter = await interface!.calculate();
                        setState(() {
                          _counter = _counter;
                          withoutIsolatesEnabled = true;
                          log('without isolates sum finished: $_counter');
                        });
                      }
                    : null,
                child: const Text(
                  'Get Sum Without Isolates',
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width * 0.75,
              child: ElevatedButton(
                onPressed: withIsolatesEnabled
                    ? () async {
                        setState(() {
                          _counter = 0;
                          withIsolatesEnabled = false;
                          log('Restarted Counter: $_counter');
                        });
                        interface = WithIsolate(
                            limit: 500000000, status: Status.isolate);
                        _counter = await interface!.calculate();
                        setState(() {
                          _counter = _counter;
                          withIsolatesEnabled = true;
                        });
                      }
                    : null,
                child: const Text(
                  'Get Sum With Isolates',
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
