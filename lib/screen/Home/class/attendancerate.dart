// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, deprecated_member_use

import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/studentattendancemodel.dart';
import 'package:eduvista/model/studentmodel.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';

class AttendanceRate extends StatefulWidget {
  const AttendanceRate({super.key, required this.classname});
  final String classname;

  @override
  State<AttendanceRate> createState() => _AttendanceRateState();
}

ValueNotifier<TextEditingController> searchTexteditingController =
    ValueNotifier<TextEditingController>(TextEditingController());

class _AttendanceRateState extends State<AttendanceRate> {
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
              'Attendance Rate',
              style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                AddTextFeildWidget(
                  controller: searchTexteditingController.value,
                  textlabel: 'Enter Student Name',
                  title: 'Attendance Rate (%)',
                  onChanged: (searchText) {
                    print(searchText);
                    filterStudents(searchText!, widget.classname);
                  },
                  iconData: Icons.search,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child:
                      FutureBuilder<ValueNotifier<List<Map<String, dynamic>>>>(
                    future: getEachstudentattendance(widget.classname),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error:-');
                      } else {
                        final listvalue = snapshot.data!;

                        listvalue.value
                            .sort((a, b) => a['name'].compareTo(b['name']));
                        final filteredList = listvalue.value
                            .where((student) => student['name']
                                .toLowerCase()
                                .contains(searchTexteditingController.value.text
                                    .toLowerCase()))
                            .toList();

                        filteredList
                            .sort((a, b) => a['name'].compareTo(b['name']));
                        return filteredList.isEmpty
                            ? Center(
                                child: LottieBuilder.asset(
                                    'assets/animation/PUyQfE9kMM.json'),
                              )
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  int foundIndex = -1;
                                  for (int i = 0;
                                      i < listvalue.value.length;
                                      i++) {
                                    if (listvalue.value[i]['name'] ==
                                        filteredList[index]['name']) {
                                      foundIndex = i;
                                      break;
                                    }
                                  }
                                  int attendancerate;
                                  if (filteredList[index]['totalday'] != 0) {
                                    attendancerate = ((filteredList[index]
                                                    ['totalpresent'] /
                                                filteredList[index]
                                                    ['totalday']) *
                                            100)
                                        .toInt();
                                  } else {
                                    // Handle the case where totalday is zero (e.g., set attendancerate to a default value)
                                    attendancerate =
                                        0; // Or any other default value you want
                                  }
                                  return Container(
                                    width: size.width,
                                    decoration: BoxDecoration(
                                      color: const Color(0Xff188F79)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  filteredList[index]['name'],
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Roll No :- ${foundIndex + 1}',
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
                                        Text(
                                          '${attendancerate.toString()}%',
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            color: attendancerate < 75
                                                ? Colors.red
                                                : Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemCount: filteredList.length);
                      }
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

  void filterStudents(String searchText, String cls) {
    searchTexteditingController.value.text = searchText;
    setState(() {
      searchTexteditingController.notifyListeners();
    });
    getEachstudentattendance(cls);
  }
}

Future<void> generatePDF(
    List<Map<String, dynamic>> studentData, String className) async {
  final pdf = pw.Document();

  // Add a page to the PDF
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          children: [
            // Add header with class name
            pw.Header(
              level: 0,
              child: pw.Text('Attendance Report - $className'),
            ),
            // Add student attendance data
            pw.Table.fromTextArray(
              headers: ['Student Name', 'Attendance Rate'],
              data: List<List<String>>.generate(
                studentData.length,
                (index) => [
                  studentData[index]['name'],
                  calculateAttendanceRate(
                    studentData[index]['totalpresent'],
                    studentData[index]['totalday'],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/attendance_report.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  OpenFile.open(filePath);
  Share.shareFiles([filePath], text: 'Attendance Report - $className');
}

String calculateAttendanceRate(int totalPresent, int totalDay) {
  if (totalDay != 0) {
    final attendanceRate = ((totalPresent / totalDay) * 100).toInt();
    return '$attendanceRate%';
  } else {
    return 'N/A';
  }
}

Future<ValueNotifier<List<Map<String, dynamic>>>> getEachstudentattendance(
    String classname) async {
  ValueNotifier<List<Map<String, dynamic>>> attendanceratelist =
      ValueNotifier<List<Map<String, dynamic>>>([]);
  List<StudentModel> classatudentlist = await getStudentFromHive(classname);
  for (var student in classatudentlist) {
    attendanceratelist.value
        .add({'name': student.studentname, 'totalpresent': 0, 'totalday': 0});
  }
  List<AllStudentAttendanceModel> allstudentdetails =
      await getStudentAttendanceFromHive(classname);

  for (var map in attendanceratelist.value) {
    int total = 0;
    int present = 0;
    for (var element in allstudentdetails) {
      for (var i = 0; i < element.allstudentlist.length; i++) {
        if (map['name'] == element.allstudentlist[i].studentname) {
          total++;
          if (element.allstudentlist[i].ispresent == true) {
            present++;
          }
        }
      }
      map['totalpresent'] = present;
      map['totalday'] = total;
    }
  }
  attendanceratelist.notifyListeners();

  return attendanceratelist;
}
