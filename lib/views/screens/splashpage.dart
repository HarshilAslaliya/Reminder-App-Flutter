import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 4),
      () => Get.toNamed("/"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(
              flex: 4,
            ),
            Image.asset(
              "assets/images/icon1.png",
              height: 90,
              width: 90,
            ),
            Spacer(
              flex: 3,
            ),
            Text(
              "Reminder",
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 30, color: Colors.grey.shade400)),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
