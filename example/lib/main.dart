import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tink_plugin/tink_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _authResult = 'None';
  String _tinkBody = 'None';


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> authenticate() async {
    final result =  await TinkPlugin.authenticateWithURL("tinkurl");
    if (!mounted) return;

    setState(() {
      _authResult = result.state.toString();
      _tinkBody = result.data.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tink auth example app'),
        ),
        body:  Builder(
          builder: (BuildContext context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(onPressed: this.authenticate, child: Text("Authenticate"),),
                  SizedBox(height: 30.0,),
                  Text('Tink auth result $_authResult\n'),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(_tinkBody),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
