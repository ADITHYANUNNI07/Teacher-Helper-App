// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/studentmodel.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AddStudentScrn extends StatefulWidget {
  const AddStudentScrn({super.key, required this.classname});
  final String classname;
  @override
  State<AddStudentScrn> createState() => _AddStudentScrnState();
}

final namecontoller = TextEditingController();
final emaileditingcontroller = TextEditingController();
final phoneeditingcontroller = TextEditingController();
final parentphoneeditingcontroller = TextEditingController();
final admissionnoeditingcontroller = TextEditingController();
final addresseditingcontroller = TextEditingController();
final fromKey = GlobalKey<FormState>();
String? rollno;
bool isAdmission = true;

class _AddStudentScrnState extends State<AddStudentScrn> {
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
              'Add Student',
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AddTextFeildWidget(
                      title: 'Full Name',
                      textlabel: 'Enter Full Name',
                      iconData: Icons.person_2,
                      controller: namecontoller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Full Name";
                        } else {
                          return RegExp(r'[!@#<>?:_`"~;[\]\\|=+)(*&^%0-9-]')
                                  .hasMatch(value)
                              ? "Please enter valid name"
                              : null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    AddTextFeildWidget(
                      title: 'Email Address',
                      textlabel: 'Enter Email Address',
                      controller: emaileditingcontroller,
                      iconData: Icons.email,
                      validator: (val) {
                        return RegExp(r"^[a-z0-9]+@gmail+\.com+").hasMatch(val!)
                            ? null
                            : "Please enter a valid email";
                      },
                    ),
                    const SizedBox(height: 15),
                    AddTextFeildWidget(
                      title: 'Parent Phone No',
                      controller: parentphoneeditingcontroller,
                      textlabel: 'Enter Phone No',
                      iconData: Icons.phone,
                      validator: (val) {
                        return RegExp(r"(^(?:[+0]9)?[0-9]{10,12}$)")
                                .hasMatch(val!)
                            ? null
                            : "Please enter valid mobile number";
                      },
                    ),
                    AddTextFeildWidget(
                      title: 'Phone No',
                      controller: phoneeditingcontroller,
                      textlabel: 'Enter Phone No',
                      iconData: Icons.phone,
                      validator: (val) {
                        return RegExp(r"(^(?:[+0]9)?[0-9]{10,12}$)")
                                .hasMatch(val!)
                            ? null
                            : "Please enter valid mobile number";
                      },
                    ),
                    const SizedBox(height: 15),
                    AddTextFeildWidget(
                      title: 'Address',
                      controller: addresseditingcontroller,
                      textlabel: 'Enter Address',
                      iconData: LineAwesomeIcons.address_card,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Address";
                        } else {
                          return RegExp(r'[!@#<>?:_`"~;[\]\\|=+)(*&^%0-9-]')
                                  .hasMatch(value)
                              ? "Please enter valid Address"
                              : null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    AddTextFeildWidget(
                      title: 'Admission No',
                      controller: admissionnoeditingcontroller,
                      textlabel: 'Enter Roll No',
                      iconData: Icons.numbers,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Admission No";
                        } else {
                          int? rollNo = int.tryParse(value);
                          if (rollNo != null && rollNo > 1000) {
                            return null;
                          } else {
                            return "Admission No should be greter than 1000";
                          }
                        }
                      },
                      onChanged: (value) async {
                        int? rollNo =
                            int.tryParse(admissionnoeditingcontroller.text);
                        if (rollNo != null) {
                          bool value = await validateadmission(rollNo);
                          setState(() {
                            isAdmission = value;
                            print(isAdmission);
                          });
                        }
                      },
                    ),
                    !isAdmission
                        ? const Text(
                            'Admission No is already exist.',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.red),
                          )
                        : const Text(''),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: size.width,
                      height: 50,
                      child: ElevatedBtnWidget(
                          onPressed: () {
                            addStudent();
                          },
                          title: 'ADD STUDENT'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  addStudent() async {
    if (isAdmission) {
      if (fromKey.currentState!.validate()) {
        final studentdetails = StudentModel(
            studentname: namecontoller.text,
            email: emaileditingcontroller.text,
            parentphone: parentphoneeditingcontroller.text,
            phoneno: phoneeditingcontroller.text,
            address: addresseditingcontroller.text,
            addmissionno: int.parse(admissionnoeditingcontroller.text),
            classname: widget.classname);
        final value = await addStudentToHive(studentdetails);
        if (value) {
          newshowSnackbar(context, 'Student Details',
              'student details add sucessfully', ContentType.success);
          clearFeild();
        } else {
          newshowSnackbar(context, 'Student Details', 'student details not add',
              ContentType.failure);
          clearFeild();
        }
      }
    } else {
      newshowSnackbar(context, 'Student Details',
          'Admission Number already existing', ContentType.failure);
    }
  }

  void clearFeild() {
    namecontoller.clear();
    emaileditingcontroller.clear();
    parentphoneeditingcontroller.clear();
    phoneeditingcontroller.clear();
    addresseditingcontroller.clear();
    admissionnoeditingcontroller.clear();
  }

  Future<bool> validateadmission(int admissionno) async {
    final studentBox = await Hive.openBox<StudentModel>('studentDB');
    final List<StudentModel> allstudentlist = studentBox.values.toList();

    for (StudentModel student in allstudentlist) {
      if (student.addmissionno == admissionno) {
        return false;
      }
    }
    return true;
  }
}
