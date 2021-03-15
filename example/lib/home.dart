import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gokwik/flutter_gokwik.dart';
import 'package:flutter_gokwik/models/payment_capture_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Gokwik _gokwik;

  Map<String, String> _dataSheet = {
    "request_id": "a18c9b7b-1f66-4c73-a17d-813a5578d099",
    "gokwik_oid": "KWIKDGWYVKYC4065151",
    "order_status": "Pending",
    "total": "54.00",
    "moid": "12234444552",
    "mid": "gh045c8klhx3oya",
    "phone": "9899764754",
    "order_type": "upi"
  };

  @override
  void initState() {
    super.initState();
    _gokwik = Gokwik();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () async {
          log("Payment");

          /// [Some Dummy Details]
          String request_id = "a18c9b7b-1f66-4c73-a17d-813a5578d099";
          String gokwik_oid = "KWIKDGWYVKYC4065151";
          String order_status = "Pending";
          String total = "1.02";
          String moid = "12234444552";
          String mid = "gh045c8klhx3oya";
          String phone = "9899764754";
          String order_type = "upi";

          /// [Start the Payment]
          _gokwik.initPayment(context,
              data: GokwikData(request_id, gokwik_oid, order_status, total, moid, mid, phone, order_type));

          void _handleSuccess(PaymentResponse reponse) {
            log("main.dart == CALLBACK SUCCESS");
          }

          void _handleError(PaymentResponse reponse) {
            log("main.dart == CALLBACK SUCCESS");
          }

          void _handleNetworkIssue(PaymentResponse reponse) {
            log("main.dart == CALLBACK SUCCESS");
          }

          _gokwik.on(Gokwik.EVENT_PAYMENT_SUCCESS, _handleSuccess);
          _gokwik.on(Gokwik.EVENT_PAYMENT_ERROR, _handleError);
          _gokwik.on(Gokwik.NETWORK_ERROR, _handleNetworkIssue);
        },
        child: Container(
          color: Colors.deepOrange,
          height: MediaQuery.of(context).size.height * 0.08,
          child: Center(
              child: Text(
            "CONTINUE PAYMENT",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          )),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        elevation: 10.0,
        title: const Text('GoKwik Flutter SDK'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Demo Application for Payment Gateway",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text("<Data to be provided by the merchant/>"),
            SizedBox(
              height: 16.0,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _dataSheet.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          _dataSheet.entries.elementAt(index).key,
                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          _dataSheet.entries.elementAt(index).value,
                          style: TextStyle(fontSize: 12.0, color: Colors.black45),
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
