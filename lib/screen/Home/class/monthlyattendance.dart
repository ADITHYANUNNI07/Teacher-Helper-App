// ignore_for_file: avoid_unnecessary_containers

import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/studentmodel.dart';
import 'package:eduvista/screen/Home/class/eachstudentattendance.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MonthlyattendanceScrn extends StatefulWidget {
  const MonthlyattendanceScrn({super.key, required this.classname});
  final String classname;

  @override
  State<MonthlyattendanceScrn> createState() => _MonthlyattendanceScrnState();
}

List<StudentModel> studentlist = [];

class _MonthlyattendanceScrnState extends State<MonthlyattendanceScrn> {
  @override
  void initState() {
    super.initState();
    studentlistFunction();
  }

  void studentlistFunction() async {
    List<StudentModel> list = await getStudentFromHive(widget.classname);
    list.sort((a, b) => a.studentname.compareTo(b.studentname));
    setState(() {
      studentlist = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
              'Mouthly Attendance',
              style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(
            color: const Color(0xffF1FDFB),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: studentlist.isEmpty
                      ? Center(
                          child: Container(
                            child: LottieBuilder.asset(
                                'assets/animation/PUyQfE9kMM.json'),
                          ),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemCount: studentlist.length,
                          itemBuilder: (context, index) {
                            final student = studentlist[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(seconds: 1),
                                      transitionsBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double> secAnimation,
                                          Widget child) {
                                        animation = CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.bounceInOut);
                                        return ScaleTransition(
                                          alignment: Alignment.center,
                                          scale: animation,
                                          child: child,
                                        );
                                      },
                                      pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double> secAnimation) {
                                        return EachStudentAttendanceScrn(
                                          studentModel: student,
                                        );
                                      },
                                    ));
                              },
                              child: Container(
                                width: size.width,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0Xff188F79).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.studentname,
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Roll No :- ${index + 1}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
