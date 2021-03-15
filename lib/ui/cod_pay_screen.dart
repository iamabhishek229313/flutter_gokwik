import 'package:flutter/material.dart';
import 'package:flutter_gokwik/models/verify_model.dart';
import 'package:flutter_gokwik/ui/otp_screen.dart';

class CODPayScreen extends StatefulWidget {
  final VerifyModel verifyModel;

  const CODPayScreen({Key key, @required this.verifyModel}) : super(key: key);
  @override
  _CODPayScreenState createState() => _CODPayScreenState();
}

class _CODPayScreenState extends State<CODPayScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.verifyModel.data.merchantUserVerified == true) return OTPScreen();
    return Container(
      constraints: BoxConstraints.expand(),
      color: Colors.blueAccent,
    );
  }
}
