import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gokwik/flutter_gokwik.dart';
import 'package:flutter_gokwik/ui/cod_pay_screen.dart';
import 'package:flutter_gokwik/ui/upi_pay_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class GoKwikPayScreen extends StatefulWidget {
  final GokwikData data;

  const GoKwikPayScreen({Key key, @required this.data}) : super(key: key);

  @override
  _GoKwikPayScreenState createState() => _GoKwikPayScreenState();
}

class _GoKwikPayScreenState extends State<GoKwikPayScreen> {
  Future<dynamic> _getVerified() async {
    /// [the dummy initialisation]

    log("get verified");
    log(widget.data.phone.toString());
    var url = 'https://devapi.gokwik.co/v1/order/verify';

    /// [Merchant response]
    var response = await http.post(url, body: {
      "request_id": widget.data.requestId,
      "gokwik_oid": widget.data.gokwikOid,
      "order_status": widget.data.orderStatus,
      "total": widget.data.total,
      "moid": widget.data.moid,
      "mid": widget.data.mid,
      "phone": widget.data.phone,
      "order_type": widget.data.orderType
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    print(response.body.toString());
    log("Here it is II ");

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getVerified(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: AlertDialog(
              elevation: 0.0,
              backgroundColor: Colors.grey.shade100,
              // constraints: BoxConstraints.expand(),
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SpinKitRing(
                        color: Colors.green,
                        lineWidth: 4.0,
                        size: 32.0,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "Initializing payment ...",
                        style: TextStyle(fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );

        if (widget.data.orderType == "upi")
          return UPIPayScreen(
            data: widget.data,
          );
        else
          return CODPayScreen();
      },
    );
  }
}
