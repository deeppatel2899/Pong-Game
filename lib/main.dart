import 'package:flutter/material.dart';
import 'package:pong_game/pong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong Game',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pong Game'),
        ),
        body: SafeArea(
          child: Pong(),
        ),
      ),
    );
  }
}
