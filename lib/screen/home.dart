import 'dart:io';

import 'package:eduvista/model/usermodel.dart';
import 'package:eduvista/screen/Home/attendance.dart';
import 'package:eduvista/screen/Home/messagetoparent.dart';
import 'package:eduvista/screen/dashboard.dart';
import 'package:eduvista/screen/examquestions.dart';
import 'package:eduvista/screen/splash.dart';
import 'package:eduvista/screen/studymaterial.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScrn extends StatefulWidget {
  const HomeScrn({super.key, required this.userDetails});
  final UserDetails? userDetails;

  @override
  State<HomeScrn> createState() => _HomeScrnState();
}

class _HomeScrnState extends State<HomeScrn> {
  @override
  void initState() {
    getUserdetails(widget.userDetails!.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int currentHour = now.hour;
    String? greeting;
    if (currentHour >= 0 && currentHour < 12) {
      greeting = 'Good Morning';
    } else if (currentHour >= 12 && currentHour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    final size = MediaQuery.of(context).size;
    return Container(
      color: const Color(0Xff188F79).withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
        child: ValueListenableBuilder<UserDetails?>(
          valueListenable: userdetailsvlauenotifiermain,
          builder: (context, user, child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting!,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              user!.name,
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: user.profilepic == null
                            ? const CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage('assets/images/signup.png'),
                              )
                            : CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    FileImage(File(user.profilepic!)),
                              ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 315,
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/signup.png'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Categories',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CategoriesWidget(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AttendanceScrn(email: widget.userDetails!.email),
                        ),
                      );
                    },
                    size: size,
                    imagsrc: 'assets/images/attendance.png',
                    title: 'Attendance',
                  ),
                  const SizedBox(height: 10),
                  CategoriesWidget(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PrepareExamQuestionsScrn(email: email),
                        ),
                      );
                    },
                    size: size,
                    imagsrc: 'assets/images/Academic.png',
                    title: 'Prepare Exam Questions',
                  ),
                  const SizedBox(height: 10),
                  CategoriesWidget(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudyMaterialScrn(
                              foldername: widget.userDetails!.email,
                              email: widget.userDetails!.email,
                            ),
                          ));
                    },
                    size: size,
                    imagsrc: 'assets/images/contactas.png',
                    title: 'Study Material',
                  ),
                  const SizedBox(height: 10),
                  CategoriesWidget(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ParentToMessageScrn(
                                email: widget.userDetails!.email),
                          ));
                    },
                    size: size,
                    imagsrc: 'assets/images/examination.png',
                    title: 'Message to Parents',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
