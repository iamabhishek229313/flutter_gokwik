import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gokwik/ui/pay_screen.dart';

class Gokwik {
  // Response codes from platform
  static const _CODE_PAYMENT_SUCCESS = 0;
  static const _CODE_PAYMENT_ERROR = 1;
  static const _CODE_PAYMENT_EXTERNAL_WALLET = 2;

  // Event names
  static const EVENT_PAYMENT_SUCCESS = 'payment.success';
  static const EVENT_PAYMENT_ERROR = 'payment.error';
  static const EVENT_EXTERNAL_WALLET = 'payment.external_wallet';

  // Payment error codes
  static const NETWORK_ERROR = 0;
  static const INVALID_OPTIONS = 1;
  static const PAYMENT_CANCELLED = 2;
  static const TLS_ERROR = 3;
  static const INCOMPATIBLE_PLUGIN = 4;
  static const UNKNOWN_ERROR = 100;

  static const MethodChannel _channel = const MethodChannel('flutter_gokwik');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  void initPayment(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => GoKwikPayScreen()));
  }
}
