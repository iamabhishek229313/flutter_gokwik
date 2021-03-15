import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_gokwik/const/app_colors.dart';
import 'package:flutter_gokwik/models/verify_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:upi_pay/upi_pay.dart';

class UPIPayScreen extends StatefulWidget {
  final VerifyModel verifyModel;

  const UPIPayScreen({Key key, @required this.verifyModel}) : super(key: key);

  @override
  _UPIPayScreenState createState() => _UPIPayScreenState();
}

class _UPIPayScreenState extends State<UPIPayScreen> {
  Future<List<ApplicationMeta>> _appsFuture;
  Uint8List _bytesImage;

  @override
  void initState() {
    super.initState();
    _appsFuture = UpiPay.getInstalledUpiApplications();
    _bytesImage = Base64Decoder().convert(widget.verifyModel.data.qrCode.split('base64,')[1]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onTap(ApplicationMeta app) async {
    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");

    String receiverUpiAddress = widget.verifyModel.data.uLink.split('pa=')[1].split('&')[0];

    dev.log("Receiver UPI Address " + receiverUpiAddress.toString());

    final a = await UpiPay.initiateTransaction(
      amount: widget.verifyModel.data.total,
      app: app.upiApplication,
      receiverName: 'Gokwik',
      receiverUpiAddress: receiverUpiAddress,
      transactionRef: transactionRef,
      merchantCode: widget.verifyModel.data.transactionId.toString(),
    );

    dev.log("Payement output " + a.toString());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.background,
        title: Text(
          "Pay",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: screenHeight * 0.06,
                        width: double.maxFinite,
                        padding: EdgeInsets.only(left: 16.0),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              text: 'Pay ',
                              style: TextStyle(color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w300),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '₹' + widget.verifyModel.data.total,
                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Select Any UPI Option",
                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  color: AppColors.white,
                  child: Column(
                    children: [
                      FutureBuilder<List<ApplicationMeta>>(
                        future: _appsFuture,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Container(
                              height: screenHeight * 0.4,
                              child: Center(
                                  child: SpinKitRing(
                                color: Colors.green,
                                size: 24.0,
                                lineWidth: 2.0,
                              )),
                            );
                          else if (snapshot.data.length == 0)
                            return Container(
                              height: screenHeight * 0.3,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.memory(
                                    _bytesImage,
                                    fit: BoxFit.contain,
                                  ),
                                  Text(
                                    "Scan this QR Code",
                                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                                  )
                                ],
                              )),
                            );

                          return ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 24.0),
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                final it = snapshot.data[index];

                                if (!widget.verifyModel.data.uapp
                                    .contains(it.upiApplication.getAppName().toLowerCase())) return SizedBox();

                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  height: screenHeight * 0.08,
                                  child: Material(
                                    elevation: 20.0,
                                    color: AppColors.greyShade,
                                    shadowColor: AppColors.shadow,
                                    animationDuration: Duration(milliseconds: 200),
                                    type: MaterialType.canvas,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                    key: ObjectKey(it.upiApplication),
                                    child: InkWell(
                                      onTap: () => _onTap(it),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.memory(
                                                it.icon,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(vertical: 8.0).copyWith(left: 24.0),
                                              child: Text(
                                                it.upiApplication.getAppName(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                      CustomDivider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "You will get a payment link on",
                                    style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
                                  ),
                                  Text(
                                    widget.verifyModel.data.phone,
                                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green),
                                  )
                                ],
                              ),
                            ),
                            OutlineButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                              borderSide: BorderSide(color: Colors.lightBlue.shade600, width: 1.2),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Text(
                                    "Send",
                                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.lightBlue.shade600),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Icon(
                                    Icons.send,
                                    color: Colors.lightBlue.shade600,
                                    size: 18.0,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Spacer(),
              ],
            ),
          ),
          BottomLogo(screenHeight: screenHeight)
        ],
      ),
    );
  }
}

class BottomLogo extends StatelessWidget {
  const BottomLogo({
    Key key,
    @required this.screenHeight,
  }) : super(key: key);

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "POWERED BY ",
            style: TextStyle(fontSize: 8.0, color: Colors.grey),
          ),
          Image.network(
            "https://s3.ap-south-1.amazonaws.com/cdn.gokwik.co/logo/gokwik-cod-logo.gif",
            height: screenHeight * 0.02,
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
              child: Divider(
            height: 0.0,
            color: Colors.grey.shade300,
            endIndent: 16.0,
          )),
          Text(
            "Or",
            style: TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
          Expanded(
              child: Divider(
            height: 0.0,
            color: Colors.grey.shade300,
            indent: 16.0,
          )),
        ],
      ),
    );
  }
}
