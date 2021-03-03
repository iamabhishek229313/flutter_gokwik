import 'package:flutter/material.dart';
import 'package:flutter_gokwik/const/app_colors.dart';

class GoKwikPayScreen extends StatefulWidget {
  @override
  _GoKwikPayScreenState createState() => _GoKwikPayScreenState();
}

class _GoKwikPayScreenState extends State<GoKwikPayScreen> {
  @override
  Widget build(BuildContext context) {
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
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10.0)),
                    child: ExpansionTile(
                      title: Text("datata"),
                      children: [Text("SDFSDFSDFSF")],
                    ))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Select Any UPI Option",
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );
  }
}
