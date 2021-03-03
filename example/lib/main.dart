import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
        onPressed: () async {
          log("Payment");

          /// [Some Dummy Details]
          // String request_id = "95421d15-c62d-90c64-9673-ee6d37e35374";
          // String gokwik_oid = "KWIKOIO8WXO6013589";
          // String order_status = "Pending";
          // String total = "36.00";
          // String moid = "245";
          // String mid = "gh067jgklm4f5i2";
          // String phone = "9876543210";
          // String order_type = "upi";

          String request_id = "f438e03b-dfcb-409e-9703-311993d4680d";
          String gokwik_oid = "KWIK5QVNNILD8145353";
          String order_status = "Pending";
          String total = "1.02";
          String moid = "3884";
          String mid = "q0xc2ilkgjmaieu";
          String phone = "9891714838";
          String order_type = "upi";

          /// [Start the Payment]
          _gokwik.initPayment(context,
              data: GokwikData(request_id, gokwik_oid, order_status, total, moid, mid, phone, order_type));
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
