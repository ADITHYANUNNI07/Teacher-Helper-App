// ignore_for_file: use_build_context_synchronously

import 'package:eduvista/Helper/helper_function.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/usermodel.dart';
import 'package:eduvista/screen/dashboard.dart';
import 'package:eduvista/screen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScrn extends StatefulWidget {
  const SplashScrn({super.key});

  @override
  State<SplashScrn> createState() => _SplashScrnState();
}

bool issignedIn = false;
String email = '';

class _SplashScrnState extends State<SplashScrn> {
  @override
  void initState() {
    getUserLoggedInStatus();
    splashtime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF188F79),
      body: Container(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash.png'),
            Text("EDU VISTA",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: const Color(0XFFE0E0E0),
                  fontSize: 38,
                ))
          ],
        ),
      ),
    );
  }

  void splashtime() async {
    Future.delayed(
      const Duration(seconds: 4),
      () async {
        UserDetails? user;
        if (issignedIn) {
          user = await getUserDetailsByEmail(email);
          await getUserdetails(email);
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => issignedIn
                ? DashBoardScrn(userDetails: user)
                : const WelcomeScrn(),
          ),
        );
      },
    );
  }

  void getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          issignedIn = value;
        });
      }
    });
    await HelperFunction.getUserNameFromSF().then((value) {
      if (value != null) {
        setState(() {
          email = value;
        });
      }
    });
  }
}
