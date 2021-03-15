import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gokwik/const/app_colors.dart';
import 'package:flutter_gokwik/ui/upi_pay_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool _enabled = false;
  String otpText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0.0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.clear,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(
              flex: 2,
            ),
            SpinKitRing(
              color: Colors.green.shade500,
              lineWidth: 3.0,
              size: 48.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Order Processing...",
              style: TextStyle(color: Colors.green.shade500, fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              width: double.maxFinite,
              height: screenHeight * 0.085,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6.0)),
              child: Row(
                children: [
                  Image.network(
                    "https://cdn.gokwik.co/logo/whatsapp.png",
                    height: screenHeight * 0.05,
                    width: screenHeight * 0.05,
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Text(
                      "Get regular delivery updates on WhatsApp or SMS",
                      maxLines: 3,
                      style: TextStyle(color: Colors.green.shade500, fontSize: 14.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              height: screenHeight * 0.05,
              margin: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Enter the OTP sent to",
                    maxLines: 3,
                    style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "+917004883767",
                          maxLines: 3,
                          style: TextStyle(color: Colors.green.shade500, fontSize: 14.0, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Icon(
                          Icons.cached_rounded,
                          color: Colors.green.shade500,
                          size: 18.0,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            OTPTextField(
              length: 4,
              width: MediaQuery.of(context).size.width,
              textFieldAlignment: MainAxisAlignment.spaceEvenly,
              fieldWidth: 50.0,
              onChanged: (val) {
                setState(() {
                  if (val.length < 4) _enabled = false;
                  otpText = val;
                });
              },
              fieldStyle: FieldStyle.box,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.green.shade500),
              onCompleted: (pin) {
                log("Opt entered " + otpText);
                setState(() {
                  _enabled = true;
                });
              },
            ),
            Spacer(
              flex: 3,
            ),
            Container(
              height: screenHeight * 0.09,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Resend OTP in",
                        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "0:30",
                        style: TextStyle(fontSize: 14.0, color: Colors.amber, fontWeight: FontWeight.w600),
                      )
                    ],
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: double.maxFinite,
                      child: RaisedButton(
                        onPressed: _enabled
                            ? () {
                                log("Otp entered : " + otpText);
                              }
                            : null,
                        color: Colors.blue.shade700,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Confirm",
                              style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 22.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            BottomLogo(screenHeight: screenHeight)
          ],
        ),
      ),
    );
  }
}
