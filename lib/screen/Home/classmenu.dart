import 'package:eduvista/model/classmodel.dart';
import 'package:eduvista/screen/Home/class/addstudent.dart';
import 'package:eduvista/screen/Home/class/addstudentattendence.dart';
import 'package:eduvista/screen/Home/class/attendancerate.dart';
import 'package:eduvista/screen/Home/class/editattendance.dart';
import 'package:eduvista/screen/Home/class/monthlyattendance.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassMenuScrn extends StatelessWidget {
  const ClassMenuScrn({super.key, required this.cls});
  final ClassModel cls;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      color: const Color(0Xff188F79),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 32,
                color: Color(0Xff188F79),
              ),
            ),
            title: Text(
              cls.classname,
              style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            color: const Color(0Xff188F79).withOpacity(0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SquareElevatedBtnWidget(
                  title: 'ADD STUDENT',
                  size: size,
                  onpress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddStudentScrn(classname: cls.classname),
                        ));
                  },
                ),
                SquareElevatedBtnWidget(
                  title: 'STUDENT ATTENDANCE',
                  size: size,
                  onpress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StudentAttendenceScrn(classname: cls.classname),
                        ));
                  },
                ),
                SquareElevatedBtnWidget(
                  title: 'MONTHLY ATTENDANCE',
                  size: size,
                  onpress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MonthlyattendanceScrn(classname: cls.classname),
                        ));
                  },
                ),
                SquareElevatedBtnWidget(
                  title: 'EDIT ATTENDANCE',
                  size: size,
                  onpress: () {
                    ShowBottumSheetScrn.show(context, cls.classname, cls);
                  },
                ),
                SquareElevatedBtnWidget(
                  title: 'ATTENDANCE RATE',
                  size: size,
                  onpress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AttendanceRate(classname: cls.classname)));
                  },
                ),
                SquareElevatedBtnWidget(
                  title: 'SHARE',
                  size: size,
                  onpress: () async {
                    ValueNotifier<List<Map<String, dynamic>>>
                        eachstudentattendancelist =
                        await getEachstudentattendance(cls.classname);
                    await generatePDF(
                        eachstudentattendancelist.value, cls.classname);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SquareElevatedBtnWidget extends StatelessWidget {
  const SquareElevatedBtnWidget({
    super.key,
    required this.size,
    required this.title,
    required this.onpress,
  });

  final Size size;
  final String title;
  final void Function()? onpress;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: 60,
      child: ElevatedButton(
        onPressed: onpress,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0XFF188F79),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
