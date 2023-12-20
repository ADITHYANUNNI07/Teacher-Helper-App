// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, deprecated_member_use

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/classmodel.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentToMessageScrn extends StatefulWidget {
  const ParentToMessageScrn({super.key, required this.email});
  final String email;
  @override
  State<ParentToMessageScrn> createState() => _ParentToMessageScrnState();
}

bool isselect = true;
TextEditingController subjectcontroller = TextEditingController();
TextEditingController messagecontroller = TextEditingController();
String selectedValue = 'Select Class Name';
bool selectAllstudentbool = false;
ValueNotifier<List<StudentForMessagedetails>> messagelistvaluenotifer =
    ValueNotifier<List<StudentForMessagedetails>>([]);
final formkeyparent = GlobalKey<FormState>();

class _ParentToMessageScrnState extends State<ParentToMessageScrn> {
  @override
  void initState() {
    selectedValue = 'Select Class Name';
    messagelistvaluenotifer = ValueNotifier<List<StudentForMessagedetails>>([]);
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
              'Message Send to Parent',
              style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: size.width,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: const Color(0Xff188F79),
                    borderRadius: BorderRadius.circular(10)),
                child: Form(
                  key: formkeyparent,
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Subject',
                              style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0Xff188F79)),
                            ),
                            const SizedBox(height: 7),
                            TextFormWidget(
                                controller: subjectcontroller,
                                label: 'Subject',
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter the Message';
                                  }
                                  return null;
                                },
                                icon: Icons.subject),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Message',
                              style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0Xff188F79)),
                            ),
                            const SizedBox(height: 7),
                            TextFormFieldAreaWidget(
                                labelText: 'Message',
                                controller: messagecontroller,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter the Message';
                                  } else if (value.length < 50) {
                                    return 'please Enter 50 words';
                                  } else {
                                    return null;
                                  }
                                },
                                icon: Icons.message),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Class',
                              style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0Xff188F79)),
                            ),
                            const SizedBox(height: 7),
                            FutureBuilder<List<ClassModel>>(
                              future: getClassByEmail(widget.email),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      color: Colors.white,
                                      child: FractionallySizedBox(
                                        widthFactor: 0.4,
                                        heightFactor: 0.4,
                                        child: Lottie.asset(
                                          'assets/animation/animation_lo4efsbq.json',
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  List<String> selectedlist = [
                                    'Select Class Name'
                                  ];

                                  List<ClassModel>? classmodellist =
                                      snapshot.data;
                                  if (classmodellist != null) {
                                    for (var cls in classmodellist) {
                                      selectedlist.add(cls.classname);
                                    }
                                  }
                                  return Container(
                                    width: size.width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(10),
                                      value: selectedValue,
                                      onChanged: (String? newValue) {
                                        messagelistvaluenotifer = ValueNotifier<
                                            List<StudentForMessagedetails>>([]);
                                        setState(() {
                                          selectedValue = newValue!;
                                          selectAllstudentbool = false;
                                        });
                                        messagevaluenotifierFN(selectedValue);
                                      },
                                      items: [
                                        for (var i in selectedlist)
                                          DropdownMenuItem<String>(
                                            value: i,
                                            child: Text(
                                              i,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student Names',
                              style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0Xff188F79)),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: size.width,
                              padding: const EdgeInsets.only(left: 8, right: 2),
                              decoration: BoxDecoration(
                                  color: const Color(0Xff188F79),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Select all Students',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                  Checkbox(
                                    value: selectAllstudentbool,
                                    onChanged: (value) {
                                      setState(() {
                                        selectAllstudentbool = value!;
                                        allStudentmessagegetboolFn(value,
                                            messagelistvaluenotifer.value);
                                      });
                                    },
                                    activeColor: Colors.white,
                                    checkColor: const Color(0Xff188F79),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            ValueListenableBuilder<
                                List<StudentForMessagedetails>>(
                              valueListenable: messagelistvaluenotifer,
                              builder: (context, messagelist, child) {
                                return SizedBox(
                                  height: 300,
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 10),
                                    itemCount: messagelist.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  messagelist[index]
                                                      .studentname,
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
                                              value:
                                                  messagelist[index].ismessage,
                                              onChanged: (value) {
                                                setState(() {
                                                  messagelist[index].ismessage =
                                                      value!;
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                                width: size.width,
                                child: ElevatedBtnWidget(
                                    onPressed: () => sendmessagetoparent(
                                        context, messagelistvaluenotifer.value),
                                    title: 'SEND'))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void allStudentmessagegetboolFn(
      bool value, List<StudentForMessagedetails> messagelist) {
    for (StudentForMessagedetails i in messagelist) {
      i.ismessage = value;
    }
  }
}

Future<void> sendEmail(
    List<String> emailRecipients, String subject, String body) async {
  String emailUrl =
      'mailto:${emailRecipients.join(', ')}?subject=$subject&body=$body';

  if (await canLaunch(emailUrl)) {
    await launch(emailUrl);
  } else {
    // Handle error
    print('Could not launch $emailUrl');
  }
}

void sendmessagetoparent(
    BuildContext context, List<StudentForMessagedetails> messagelist) {
  if (formkeyparent.currentState!.validate()) {
    if (selectedValue != 'Select Class Name') {
      List<String> emaillist = [];
      for (var element in messagelist) {
        if (element.ismessage == true) {
          emaillist.add(element.email);
        }
      }
      if (emaillist.isNotEmpty) {
        sendEmail(emaillist, subjectcontroller.text.trim(),
            messagecontroller.text.trim());
      }
    } else {
      newshowSnackbar(context, 'Please Select Class', 'Please select the class',
          ContentType.failure);
    }
  }
}

Future<void> messagevaluenotifierFN(String classname) async {
  final studentlist = await getStudentFromHive(classname);

  messagelistvaluenotifer.value = studentlist.map((student) {
    return StudentForMessagedetails(
      classname: selectedValue,
      email: student.email,
      studentname: student.studentname,
      parentnumber: student.phoneno,
    );
  }).toList();

  messagelistvaluenotifer.notifyListeners();
}

class StudentForMessagedetails {
  final String studentname;
  bool ismessage;
  final String parentnumber;
  final String email;
  final String classname;
  StudentForMessagedetails({
    required this.classname,
    required this.studentname,
    this.ismessage = false,
    required this.parentnumber,
    required this.email,
  });
}
