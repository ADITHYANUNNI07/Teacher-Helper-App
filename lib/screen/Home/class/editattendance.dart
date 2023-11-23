// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/classmodel.dart';
import 'package:eduvista/model/studentattendance.dart';
import 'package:eduvista/model/studentattendancemodel.dart';
import 'package:eduvista/model/studentmodel.dart';
import 'package:eduvista/screen/Home/classmenu.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class EditAttendanceScrn extends StatefulWidget {
  const EditAttendanceScrn(
      {super.key,
      required this.classname,
      required this.editdate,
      required this.previousdateattendance});
  final String classname;
  final DateTime editdate;
  final AllStudentAttendanceModel previousdateattendance;
  @override
  State<EditAttendanceScrn> createState() => _EditAttendanceScrnState();
}

class _EditAttendanceScrnState extends State<EditAttendanceScrn> {
  ValueNotifier<List<StudentModel>> studentlist =
      ValueNotifier<List<StudentModel>>([]);
  @override
  void initState() {
    super.initState();
    studentlistFunction();
  }

  AllStudentAttendanceModel? editdateattendancemodel;
  void studentlistFunction() async {
    List<StudentModel> list = await getStudentFromHive(widget.classname);
    list.sort((a, b) => a.studentname.compareTo(b.studentname));
    List<AllStudentAttendanceModel> allStudentattendance =
        await getStudentAttendanceFromHive(widget.classname);
    for (var i in allStudentattendance) {
      if (i.date!.day == widget.editdate.day &&
          i.date!.month == widget.editdate.month) {
        setState(() {
          editdateattendancemodel = i;
          print(i);
        });
      }
    }
    setState(() {
      studentlist.value = list;
      listCount.value = studentlist.value.length;
    });
  }

  ValueNotifier<int> listCount = ValueNotifier<int>(0);
  List<StudentAttendenceModel> stuAtteList = [];
  bool selectAllstudentbool = false;
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
              'Edit Attendance',
              style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
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
                      itemCount: studentlist.value.length,
                      itemBuilder: (context, index) {
                        final student = studentlist.value[index];
                        final eachStudent = StudentAttendenceModel(
                            date: widget.editdate,
                            ispresent: index <
                                    editdateattendancemodel!
                                        .allstudentlist.length
                                ? editdateattendancemodel!
                                    .allstudentlist[index].ispresent
                                : false,
                            studentname: student.studentname,
                            admissionNo: student.addmissionno);
                        print(editdateattendancemodel!.allstudentlist.length);
                        if (listCount.value != 0) {
                          stuAtteList.add(eachStudent);
                          listCount.value--;
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
                        editattendance(widget.classname);
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

  void editattendance(String clsname) async {
    for (var i in stuAtteList) {
      print('${i.studentname}:-${i.ispresent}:-${i.date}');
    }
    int key = getKeyOfStudentAttendance(widget.previousdateattendance);
    AllStudentAttendanceModel studentAttendanceModel =
        AllStudentAttendanceModel(
            classname: clsname,
            date: widget.editdate,
            allstudentlist: stuAtteList);
    updateStudentAttendanceInHive(studentAttendanceModel, key);
    newshowSnackbar(
        context,
        'Attendance Upload',
        '${formatter.format(displaydate!)} Attendance Successfully Updated.',
        ContentType.success);
  }
}

int getKeyOfStudentAttendance(AllStudentAttendanceModel previousattendance) {
  var box = Hive.box<AllStudentAttendanceModel>('studentattendanceDB');
  var key = box.keyAt(box.values.toList().indexOf(previousattendance));
  return key;
}

class ShowBottumSheetScrn extends StatefulWidget {
  const ShowBottumSheetScrn(
      {super.key, required this.classname, required this.cls});
  final String classname;
  final ClassModel cls;
  static show(BuildContext context, String classname, ClassModel cls) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      builder: (context) {
        return ShowBottumSheetScrn(
          classname: classname,
          cls: cls,
        );
      },
    );
  }

  @override
  State<ShowBottumSheetScrn> createState() => _ShowBottumSheetScrnState();
}

DateTime? displaydate;
var formatter = DateFormat('dd MMM yyyy');

class _ShowBottumSheetScrnState extends State<ShowBottumSheetScrn> {
  @override
  void initState() {
    super.initState();

    var now = DateTime.now();
    displaydate = now;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 4,
      padding: const EdgeInsets.all(20),
      child: InkWell(
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
        child: Column(
          children: [
            Container(
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
            const SizedBox(height: 30),
            SquareElevatedBtnWidget(
              size: size,
              title: 'Search',
              onpress: () async {
                final studentattendancelist =
                    await getStudentAttendanceFromHive(widget.classname);
                for (AllStudentAttendanceModel i in studentattendancelist) {
                  if (i.date!.day == displaydate!.day &&
                      i.date!.month == displaydate!.month &&
                      i.classname == widget.classname) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAttendanceScrn(
                              previousdateattendance: i,
                              classname: widget.classname,
                              editdate: displaydate!),
                        ));
                    return;
                  }
                }
                newshowSnackbar(
                    context,
                    'Attendance is not marked',
                    '${formatter.format(displaydate!)} Attendance is not marked.',
                    ContentType.failure);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
