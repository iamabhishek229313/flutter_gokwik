import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_gokwik/flutter_gokwik.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoKwik Payment Gateway',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Gokwik _gokwik;

  @override
  void initState() {
    super.initState();
    _gokwik = Gokwik();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: () {
          _gokwik.initPayment(context);
        },
        label: Text(
          "Pay",
          style: TextStyle(color: Colors.white),
        ),
      ),
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Text("Demo Application for Payment Gateway"),
      ),
    );
  }
}
