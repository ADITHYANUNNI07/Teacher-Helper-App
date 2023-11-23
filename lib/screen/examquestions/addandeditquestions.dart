// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/questionsmodel.dart';
import 'package:eduvista/screen/examquestions.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class AddExamQuestionsScrn extends StatefulWidget {
  const AddExamQuestionsScrn(
      {super.key, required this.email, this.questionsmodel});
  final String email;
  final Questionsmodel? questionsmodel;
  @override
  State<AddExamQuestionsScrn> createState() => _AddExamQuestionsScrnState();
}

DateTime? examdate;
DateTime? examtime;
TextEditingController timecontroller = TextEditingController();
TextEditingController dateController = TextEditingController();
List<TextEditingController> controllers = [];
final fromKey = GlobalKey<FormState>();
TextEditingController titlecontroller = TextEditingController();

class _AddExamQuestionsScrnState extends State<AddExamQuestionsScrn> {
  @override
  void initState() {
    geteditmodel();

    super.initState();
  }

  void geteditmodel() {
    if (widget.questionsmodel != null) {
      titlecontroller =
          TextEditingController(text: widget.questionsmodel!.title);
      examdate = widget.questionsmodel!.examdate;
      examtime = widget.questionsmodel!.examtime;
      dateController.text = DateFormat('dd MMM yyyy').format(examdate!);
      timecontroller.text = DateFormat.jm().format(examtime!);
      for (var element in widget.questionsmodel!.questionslist) {
        controllers.add(TextEditingController(text: element));
      }
    } else {
      controllers.add(TextEditingController());
    }
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
              'Create Exam Questions',
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
              color: const Color(0Xff188F79).withOpacity(0.05),
              child: Form(
                key: fromKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddTextFeildWidget(
                      title: 'Title',
                      textlabel: 'Enter the title',
                      iconData: Icons.title,
                      controller: titlecontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Title";
                        } else {
                          return RegExp(r'[!@#<>?:_`"~;[\]\\|=+)(*&^%0-9-]')
                                  .hasMatch(value)
                              ? "Please enter valid name"
                              : null;
                        }
                      },
                    ),
                    Text(
                      'Questions',
                      style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Column(children: [
                      for (int i = 0; i < controllers.length; i++)
                        TextFormFieldAreaWidget(
                          labelText: 'Question ${i + 1}',
                          controller: controllers[i],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Questions ";
                            } else {
                              return RegExp(r'[!@#<>:_`"~;[\]\\|=+)(*&^%0-9-]')
                                      .hasMatch(value)
                                  ? "Please enter valid Question"
                                  : null;
                            }
                          },
                          icon: Icons.question_answer,
                        ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedBtnWidget(
                            onPressed: () {
                              controllers.add(TextEditingController());
                              setState(() {});
                            },
                            title: 'ADD QUESTIONS'),
                        ElevatedBtnWidget(
                          onPressed: () {
                            if (controllers.isNotEmpty) {
                              controllers.last.clear();
                              controllers.removeLast();
                              setState(() {});
                            }
                          },
                          title: 'CLEAR',
                        ),
                      ],
                    ),
                    Text(
                      'Exam Date',
                      style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: dateController,
                      initialValue: null,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Exam Date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      onTap: () async {
                        var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2030));
                        if (date != null) {
                          examdate = date;
                          dateController.text =
                              DateFormat('dd MMM yyyy').format(date);
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty || examdate == null) {
                          return "Please Select Exam";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Exam Time",
                      style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: null,
                      readOnly: true,
                      controller: timecontroller,
                      decoration: InputDecoration(
                        hintText: 'Exam Time',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onTap: () async {
                        var time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          final now = DateTime.now();
                          final selectedTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            time.hour,
                            time.minute,
                          );
                          examtime = selectedTime;
                          timecontroller.text =
                              DateFormat.jm().format(selectedTime);
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Select Exam Time";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      width: size.width,
                      child: ElevatedBtnWidget(
                          onPressed: () {
                            if (widget.questionsmodel == null) {
                              createQuestions();
                            } else {
                              editQuestions();
                            }
                          },
                          title: 'CREATE'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  clearFn() {
    titlecontroller.clear();
    timecontroller.clear();
    dateController.clear();
    controllers.clear();
  }

  void createQuestions() async {
    if (fromKey.currentState!.validate()) {
      List<String> stringList =
          controllers.map((controller) => controller.text).toList();
      final questionsmodel = Questionsmodel(
          email: widget.email,
          title: titlecontroller.text.trim(),
          examdate: examdate!,
          examtime: examtime!,
          questionslist: stringList);
      bool value = await addExamQuestionsToHive(questionsmodel);
      if (value) {
        newshowSnackbar(context, 'Questions Added',
            'Succeessfully added the Questions', ContentType.success);
        clearFn();
        Navigator.pop(context);
      } else {
        newshowSnackbar(context, 'Questions not Added',
            'Not added the Questions', ContentType.failure);
        clearFn();
      }
    }
  }

  int getKeyOfQuestionmodel(Questionsmodel questionsmodel) {
    var box = Hive.box<Questionsmodel>('questionsDB');
    var key = box.keyAt(box.values.toList().indexOf(questionsmodel));
    return key;
  }

  void editQuestions() async {
    int key = getKeyOfQuestionmodel(widget.questionsmodel!);
    List<String> stringList =
        controllers.map((controller) => controller.text).toList();
    final questionsmodel = Questionsmodel(
        email: widget.email,
        title: titlecontroller.text.trim(),
        examdate: examdate!,
        examtime: examtime!,
        questionslist: stringList);
    updateQuestionsInHive(questionsmodel, key);
    newshowSnackbar(context, 'Questions Updated',
        'Succeessfully Updated the Questions', ContentType.success);
    getQuestionsFN(questionsmodel.email);
    clearFn();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    controllers.clear();
    super.dispose();
  }
}
