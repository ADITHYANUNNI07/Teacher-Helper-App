// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/studentattendance.dart';
import 'package:eduvista/model/studentattendancemodel.dart';
import 'package:eduvista/model/studentmodel.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StudentAttendenceScrn extends StatefulWidget {
  const StudentAttendenceScrn({Key? key, required this.classname})
      : super(key: key);
  final String classname;

  @override
  State<StudentAttendenceScrn> createState() => _StudentAttendenceScrnState();
}

class _StudentAttendenceScrnState extends State<StudentAttendenceScrn> {
  DateTime? displaydate;
  List<StudentModel> studentlist = [];
  @override
  void initState() {
    super.initState();
    studentlistFunction();
    var now = DateTime.now();
    displaydate = now;
  }

  void studentlistFunction() async {
    List<StudentModel> list = await getStudentFromHive(widget.classname);
    list.sort((a, b) => a.studentname.compareTo(b.studentname));
    setState(() {
      studentlist = list;
      listCount = studentlist.length;
    });
  }

  int listCount = 0;
  List<StudentAttendenceModel> stuAtteList = [];
  bool selectAllstudentbool = false;
  var now = DateTime.now();
  var formatter = DateFormat('dd MMM yyyy');

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
              'Student Attendance',
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        displaydate = date;
                      });
                    }
                  },
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        color: const Color(0Xff188F79),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            formatter.format(displaydate!),
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                        Text(
                          'Choose Another Date',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0Xff188F79),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select all Students',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                          Checkbox(
                            value: selectAllstudentbool,
                            onChanged: (value) {
                              setState(() {
                                selectAllstudentbool = value!;
                                allStudentgetboolFn(value, stuAtteList);
                              });
                            },
                            activeColor: Colors.white,
                            checkColor: const Color(0Xff188F79),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0Xff188F79),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: studentlist.length,
                      itemBuilder: (context, index) {
                        final student = studentlist[index];
                        final eachStudent = StudentAttendenceModel(
                            date: displaydate!,
                            studentname: student.studentname,
                            admissionNo: student.addmissionno);
                        if (listCount != 0) {
                          stuAtteList.add(eachStudent);
                          listCount--;
                        }
                        return Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              Checkbox(
                                value: stuAtteList[index].ispresent,
                                onChanged: (value) {
                                  setState(() {
                                    stuAtteList[index].ispresent = value!;
                                  });
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: size.width,
                  height: 50,
                  child: ElevatedBtnWidget(
                      onPressed: () {
                        attendance(widget.classname);
                      },
                      title: 'ADD'),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void allStudentgetboolFn(bool value, List<StudentAttendenceModel> list) {
    for (StudentAttendenceModel i in list) {
      i.ispresent = value;
    }
  }

  void studentDateFn(DateTime displaydate, List<StudentAttendenceModel> list) {
    for (StudentAttendenceModel i in list) {
      i.date = displaydate;
    }
  }

  void attendance(String clsname) async {
    final studentattendancelist = await getStudentAttendanceFromHive(clsname);
    for (AllStudentAttendanceModel i in studentattendancelist) {
      if (i.date!.day == displaydate!.day &&
          i.date!.month == displaydate!.month &&
          i.classname == clsname) {
        newshowSnackbar(context, 'Today Attendance',
            'Today Attendance already marked.', ContentType.failure);
        return;
      }
    }
    studentDateFn(displaydate!, stuAtteList);
    final todayattendance = AllStudentAttendanceModel(
        classname: clsname, date: displaydate, allstudentlist: stuAtteList);
    for (var i in stuAtteList) {
      print('${i.studentname}:-${i.ispresent}:-${i.date}');
    }
    bool value = await addStudentAttendanceToHive(todayattendance);
    if (value) {
      newshowSnackbar(
          context,
          'Attendance Upload',
          '${formatter.format(displaydate!)} Attendance Successfully Updated.',
          ContentType.success);
    } else {
      newshowSnackbar(
          context,
          'Attendance Upload Failed',
          '${formatter.format(displaydate!)} Attendance Failed to Updated.',
          ContentType.failure);
    }
  }
}
