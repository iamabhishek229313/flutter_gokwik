import 'dart:async';
import 'dart:developer';

import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gokwik/models/payment_capture_model.dart';
import 'package:flutter_gokwik/ui/pay_screen.dart';
import 'package:http/http.dart' as http;

class Gokwik {
  // Event names
  static const EVENT_PAYMENT_SUCCESS = 'payment.success';
  static const EVENT_PAYMENT_ERROR = 'payment.error';
  static const NETWORK_ERROR = 'payment.newtwork.issue';

  // Method Channels
  static const MethodChannel _channel = const MethodChannel('flutter_gokwik');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  EventEmitter _eventEmitter;

  Gokwik() {
    _eventEmitter = EventEmitter();
  }

  // Constructor.
  void initPayment(BuildContext context, {@required GokwikData data}) async {
    final PaymentResponse paymentResponse = await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GoKwikPayScreen(
              data: data,
            )));

    if (paymentResponse == null) return;

    log("GOKWIK: Payment Reponse : " + paymentResponse.toString());

    if (paymentResponse.data.paymentStatus == Gokwik.EVENT_PAYMENT_SUCCESS) {
      _eventEmitter.emit(Gokwik.EVENT_PAYMENT_SUCCESS);
    } else if (paymentResponse.data.paymentStatus == Gokwik.EVENT_PAYMENT_ERROR) {
      _eventEmitter.emit(Gokwik.EVENT_PAYMENT_SUCCESS);
    } else if (paymentResponse.data.paymentStatus == Gokwik.NETWORK_ERROR) {
      _eventEmitter.emit(Gokwik.NETWORK_ERROR);
    }
  }

  /// Registers event listeners for payment events
  void on(String event, Function handler) {
    EventCallback cb = (event, cont) {
      handler(event.eventData);
    };
    _eventEmitter.on(event, null, cb);
  }
}

class GokwikData {
  final String requestId;
  final String gokwikOid;
  final String orderStatus;
  final String total;
  final String moid;
  final String mid;
  final String phone;
  final String orderType;

  GokwikData(
      this.requestId, this.gokwikOid, this.orderStatus, this.total, this.moid, this.mid, this.phone, this.orderType);
}
