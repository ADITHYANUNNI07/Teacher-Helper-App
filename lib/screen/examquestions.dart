// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously, unnecessary_string_interpolations, prefer_const_constructors
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/questionsmodel.dart';
import 'package:eduvista/screen/examquestions/addandeditquestions.dart';
import 'package:eduvista/screen/examquestions/displayquestions.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:pdf/widgets.dart' as pw;

class PrepareExamQuestionsScrn extends StatefulWidget {
  const PrepareExamQuestionsScrn({super.key, required this.email});
  final String email;

  @override
  State<PrepareExamQuestionsScrn> createState() =>
      _PrepareExamQuestionsScrnState();
}

ValueNotifier<List<Questionsmodel>> questionlistnotifer =
    ValueNotifier<List<Questionsmodel>>([]);

class _PrepareExamQuestionsScrnState extends State<PrepareExamQuestionsScrn> {
  @override
  void initState() {
    getQuestionsFN(widget.email);
    super.initState();
  }

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
              'Prepare Exam Questions',
              style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(
            width: size.width,
            padding: const EdgeInsets.only(left: 10, right: 10),
            color: Color(0XFFF1FDFB),
            child: ValueListenableBuilder(
              valueListenable: questionlistnotifer,
              builder: (context, questionlist, child) {
                return questionlist.isEmpty
                    ? Center(
                        child: Container(
                          child: LottieBuilder.asset(
                              'assets/animation/PUyQfE9kMM.json'),
                        ),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: questionlist.length,
                        itemBuilder: (context, index) {
                          final questionmodel = questionlist[index];
                          return Slidable(
                            startActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green.shade300,
                                  label: 'Edit',
                                  icon: LineAwesomeIcons.edit,
                                  spacing: 10,
                                  borderRadius: BorderRadius.circular(9),
                                  onPressed: (context) async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddExamQuestionsScrn(
                                                  email: questionmodel.email,
                                                  questionsmodel:
                                                      questionmodel),
                                        ));
                                  },
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SizedBox(width: 5),
                                SlidableAction(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue.shade300,
                                  label: 'Share',
                                  icon: Icons.share,
                                  spacing: 10,
                                  borderRadius: BorderRadius.circular(9),
                                  onPressed: (context) async {
                                    generateQuestionsPDF(questionmodel);
                                  },
                                ),
                                SizedBox(width: 5),
                                SlidableAction(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red.shade300,
                                  label: 'Delete',
                                  icon: Icons.delete,
                                  spacing: 10,
                                  borderRadius: BorderRadius.circular(9),
                                  onPressed: (context) async {
                                    deleteQuestion(
                                        context, questionmodel.title, index);
                                  },
                                )
                              ],
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DisplayExamQuestionScrn(
                                              questionsmodel: questionmodel),
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
                                          questionmodel.title,
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd MMM yyyy')
                                              .format(questionmodel.examdate),
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      DateFormat.jm()
                                          .format(questionmodel.examtime),
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0Xff188F79),
            child: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddExamQuestionsScrn(email: widget.email),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void deleteQuestion(BuildContext context, String title, int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete $title Questions"),
          content: Text("Are you sure you want to delete class $title?"),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0Xff188F79)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0Xff188F79)),
              onPressed: () async {
                final value = await deleteQuestiondFromHive(index);
                if (value) {
                  newshowSnackbar(context, 'Successfully Deleted',
                      '$title  deleted successfully', ContentType.success);
                } else {
                  newshowSnackbar(context, '$title not delete',
                      'Error occur in Database ', ContentType.failure);
                }
                getQuestionsFN(widget.email);
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            )
          ],
        );
      },
    );
  }
}

Future<void> getQuestionsFN(String email) async {
  questionlistnotifer.value = await getExamQuestionsFromHive(email);
  questionlistnotifer.notifyListeners();
}

Future<void> generateQuestionsPDF(Questionsmodel questionmodel) async {
  final pdf = pw.Document();

  // Add a page to the PDF
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Add date and time in the top right
            pw.Align(
              alignment: pw.Alignment.topRight,
              child: pw.Text(
                '${DateFormat('dd MMM yyyy').format(questionmodel.examdate)}',
                style: pw.TextStyle(fontSize: 14),
              ),
            ),
            pw.Align(
              alignment: pw.Alignment.topRight,
              child: pw.Text(
                '${DateFormat.jm().format(questionmodel.examtime)}',
                style: pw.TextStyle(fontSize: 14),
              ),
            ),
            // Add header with class name
            pw.Header(
              level: 0,
              child: pw.Text(
                questionmodel.title.toUpperCase(),
                style:
                    pw.TextStyle(font: pw.Font.helveticaBold(), fontSize: 18),
              ),
            ),
            // Add student attendance data
            pw.ListView.separated(
              separatorBuilder: (context, index) => pw.SizedBox(height: 10),
              itemBuilder: (context, index) {
                String question = questionmodel.questionslist[index];
                return pw.Align(
                    alignment: pw.Alignment.topLeft,
                    child: pw.Text(
                      '${index + 1}. $question',
                      style: pw.TextStyle(font: pw.Font.times(), fontSize: 13),
                    ));
              },
              itemCount: questionmodel.questionslist.length,
            ),
          ],
        );
      },
    ),
  );

  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/${questionmodel.title}.pdf';
  final file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  OpenFile.open(filePath);
  Share.shareFiles(
    [filePath],
    text: questionmodel.title.toUpperCase(),
  );
}
