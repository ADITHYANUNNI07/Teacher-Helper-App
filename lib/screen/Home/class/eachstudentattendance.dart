// ignore_for_file: must_be_immutable

import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/studentattendance.dart';
import 'package:eduvista/model/studentattendancemodel.dart';
import 'package:eduvista/model/studentmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EachStudentAttendanceScrn extends StatefulWidget {
  const EachStudentAttendanceScrn({super.key, required this.studentModel});
  final StudentModel studentModel;
  @override
  State<EachStudentAttendanceScrn> createState() =>
      _EachStudentAttendanceScrnState();
}

List<StudentAttendenceModel> studentmonthlist = [];

ValueNotifier<int> absentCount = ValueNotifier<int>(0);
ValueNotifier<int> presentCount = ValueNotifier<int>(0);

class _EachStudentAttendanceScrnState extends State<EachStudentAttendanceScrn> {
  @override
  void initState() {
    getAttendance();
    super.initState();
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
              widget.studentModel.studentname,
              style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  FutureBuilder<Map<DateTime, int>>(
                    future: getEachStudentAttendanceMap(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        Map<DateTime, int> studentAttendanceMap =
                            snapshot.data!;

                        return HeatMapCalendar(
                          weekFontSize: 15,
                          weekTextColor: const Color(0XFF188F79),
                          showColorTip: false,
                          monthFontSize: 20,
                          fontSize: 15,
                          textColor: Colors.white,
                          initDate: DateTime.now(),
                          defaultColor:
                              const Color(0XFF188F79).withOpacity(0.4),
                          flexible: true,
                          colorMode: ColorMode.color,
                          datasets: studentAttendanceMap,
                          colorsets: {
                            1: Colors.green.shade400,
                            2: Colors.red.shade400,
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Total Attendance',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PresentOrAbsentCountWidget(
                        size: size,
                        title: 'Present',
                        count: presentCount.value.toString(),
                        color: Colors.green.shade400,
                      ),
                      PresentOrAbsentCountWidget(
                        size: size,
                        title: 'Absent',
                        count: absentCount.value.toString(),
                        color: Colors.red.shade400,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<Map<String, Map<String, int>>>(
                    stream: calculateMonthlyAttendance(studentmonthlist),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        Map<String, Map<String, int>> map = snapshot.data!;
                        return BarChartSample2(attendanceMap: map);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Stream<Map<String, Map<String, int>>> calculateMonthlyAttendance(
      List<StudentAttendenceModel> attendanceList) async* {
    Map<String, Map<String, int>> monthlyAttendance = {};

    for (var attendance in attendanceList) {
      String monthKey = '${attendance.date.year}-${attendance.date.month}';

      if (!monthlyAttendance.containsKey(monthKey)) {
        monthlyAttendance[monthKey] = {'present': 0, 'absent': 0};
      }

      if (attendance.ispresent) {
        monthlyAttendance[monthKey]?.update('present', (count) => count + 1);
      } else {
        monthlyAttendance[monthKey]?.update('absent', (count) => count + 1);
      }
    }
    print(monthlyAttendance);
    yield monthlyAttendance;
  }

  void getAttendance() async {
    final list = await getEachStudentAttendance(widget.studentModel);
    setState(() {
      studentmonthlist = list;
    });
    int presentcount = 0;
    int absentcount = 0;
    for (var i in studentmonthlist) {
      if (i.ispresent) {
        presentcount++;
      } else {
        absentcount++;
      }
    }
    presentCount.value = presentcount;
    absentCount.value = absentcount;
  }

  Future<Map<DateTime, int>> getEachStudentAttendanceMap() async {
    Map<DateTime, int> studentAttendanceMap = {};
    int presentInt = 0;
    for (StudentAttendenceModel i in studentmonthlist) {
      if (i.ispresent) {
        presentInt = 1;
      } else {
        presentInt = 2;
      }
      var formatter = DateFormat('dd MMM yyyy');
      String strdate = formatter.format(i.date);
      DateTime date = DateFormat('dd MMM yyyy').parse(strdate);
      studentAttendanceMap[date] = presentInt;
    }
    return studentAttendanceMap;
  }
}

class PresentOrAbsentCountWidget extends StatelessWidget {
  const PresentOrAbsentCountWidget({
    super.key,
    required this.size,
    required this.title,
    required this.count,
    required this.color,
  });
  final String title;
  final String count;
  final Size size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      width: size.width / 2 - 30,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 19),
          ),
          Text(
            count,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 25),
          )
        ],
      ),
    );
  }
}

Future<List<StudentAttendenceModel>> getEachStudentAttendance(
    StudentModel studentModel) async {
  List<AllStudentAttendanceModel> classlist =
      await getStudentAttendanceFromHive(studentModel.classname);
  List<StudentAttendenceModel> studentmonthlist = [];
  for (AllStudentAttendanceModel i in classlist) {
    for (var j in i.allstudentlist) {
      if (j.studentname == studentModel.studentname) {
        studentmonthlist.add(j);
      }
    }
  }
  return studentmonthlist;
}

class BarChartSample2 extends StatefulWidget {
  BarChartSample2({super.key, required this.attendanceMap});
  Map<String, Map<String, int>> attendanceMap;

  final Color leftBarColor = Colors.green.shade400;
  final Color rightBarColor = Colors.red.shade400;
  final Color avgColor = Colors.green;
  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 5;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    final barGroup1 = makeGroupData(
        0,
        (widget.attendanceMap['2023-1']?['present'] ?? 0).toDouble(),
        (widget.attendanceMap['2023-1']?['absent'] ?? 0).toDouble());
    final barGroup2 = makeGroupData(
        1,
        (widget.attendanceMap['2023-2']?['present'] ?? 0).toDouble(),
        (widget.attendanceMap['2023-2']?['absent'] ?? 0).toDouble());
    final barGroup3 = makeGroupData(
        2,
        (widget.attendanceMap['2023-3']?['present'] ?? 0).toDouble(),
        (widget.attendanceMap['2023-3']?['absent'] ?? 0).toDouble());
    final barGroup4 = makeGroupData(
        3,
        (widget.attendanceMap['2023-4']?['present'] ?? 0).toDouble(),
        (widget.attendanceMap['2023-4']?['absent'] ?? 0).toDouble());
    final barGroup5 = makeGroupData(
        4,
        (widget.attendanceMap['2023-5']?['present'] ?? 0).toDouble(),
        (widget.attendanceMap['2023-5']?['absent'] ?? 0).toDouble());
    final barGroup6 = makeGroupData(
        5,
        (widget.attendanceMap['2023-6']?['present'] ?? 0).toDouble(),
        (widget.attendanceMap['2023-6']?['absent'] ?? 0).toDouble());
    final barGroup7 = makeGroupData(
        6,
        (widget.attendanceMap['2023-7']?['present'] ?? 0).toDouble(),
        (widget.attendanceMap['2023-7']?['absent'] ?? 0).toDouble());
    final barGroup8 = makeGroupData(
        7,
        (widget.attendanceMap['2023-8']?['present'] ?? 0).toDouble(),
        (widget.attendanceMap['2023-8']?['absent'] ?? 0).toDouble());
    final barGroup9 = makeGroupData(
        8,
        (widget.attendanceMap['2023-9']?['present'] ?? 0).toDouble(),
        (widget.attendanceMap['2023-9']?['absent'] ?? 0).toDouble());
    final barGroup10 = makeGroupData(
        9,
        (widget.attendanceMap['2023-10']?['present'] ?? 0).toDouble(),
        (widget.attendanceMap['2023-10']?['absent'] ?? 0).toDouble());
    final barGroup11 = makeGroupData(
        10,
        (widget.attendanceMap['2023-11']?['present'] ?? 0).toDouble(),
        (widget.attendanceMap['2023-11']?['absent'] ?? 0).toDouble());
    final barGroup12 = makeGroupData(
        11,
        (widget.attendanceMap['2023-12']?['present'] ?? 0).toDouble(),
        (widget.attendanceMap['2023-12']?['absent'] ?? 0).toDouble());
    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
      barGroup8,
      barGroup9,
      barGroup10,
      barGroup11,
      barGroup12,
    ];
    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 26,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod
                              in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                            barRods: showingBarGroups[touchedGroupIndex]
                                .barRods
                                .map((rod) {
                              return rod.copyWith(
                                  toY: avg, color: widget.avgColor);
                            }).toList(),
                          );
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 15) {
      text = '14';
    } else if (value == 25) {
      text = '24';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 20, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }
}
