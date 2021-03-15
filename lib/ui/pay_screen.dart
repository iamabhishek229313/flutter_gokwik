import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_gokwik/models/payment_capture_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gokwik/flutter_gokwik.dart';
import 'package:flutter_gokwik/models/verify_model.dart';
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
  Timer timer;
  VerifyModel verifyModel;
  bool waitingForResponse = false;

  Future<http.Response> _paymentCapture(VerifyModel verifyModel) async {
    log("_paymentCapture");

    var response = await http.post('https://devapi.gokwik.co/v1/payment/capture',
        body: {"gokwik_oid": verifyModel.data.gokwikOid, "auth_token": verifyModel.data.authToken});

    log("Payment/capture : " + response.body.toString());

    PaymentResponse paymentResponse = PaymentResponse.fromJson(json.decode(response.body.toString()));

    log("payment_status " + paymentResponse.data.paymentStatus.toString());

    if (paymentResponse.data.paymentStatus == "SUCCESS") {
      Navigator.pop(context, paymentResponse);
      timer.cancel();
    }

    return response;
  }

  _initPaymentCapture(VerifyModel verifyModel) {
    timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!waitingForResponse) {
        waitingForResponse = true;
        await _paymentCapture(verifyModel);
        waitingForResponse = false;
      }
    });
  }

  Future<dynamic> _getVerified() async {
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

    if (widget.data.orderType == "upi") verifyModel = VerifyModel.fromJson(json.decode(response.body));

    /// [Initializing the payment/capture pooling, which trigger api in every 5 sec]
    _initPaymentCapture(verifyModel);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getVerified(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData && mounted)
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

        if (widget.data.orderType == "upi" && mounted)
          return UPIPayScreen(
            verifyModel: verifyModel,
          );
        else if (mounted)
          return CODPayScreen(
            verifyModel: verifyModel,
          );
      },
    );
  }
}
