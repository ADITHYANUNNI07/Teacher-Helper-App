// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/usermodel.dart';
import 'package:eduvista/screen/Home/addclass.dart';
import 'package:eduvista/screen/dashboard.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class EditProfileScrn extends StatefulWidget {
  const EditProfileScrn({super.key, required this.user});
  final UserDetails user;
  @override
  State<EditProfileScrn> createState() => _EditProfileScrnState();
}

final formkey = GlobalKey<FormState>();
File? image;
final nameeditingcontroller = TextEditingController();
final emaileditingcontroller = TextEditingController();
final phoneeditingcontroller = TextEditingController();
final subjecteditingcontroller = TextEditingController();
final institutionnameeditingcontroller = TextEditingController();
ValueNotifier<UserDetails> userdetailsvlauenotifier = ValueNotifier(
    UserDetails(name: '', email: '', password: '', phonenumber: ''));

class _EditProfileScrnState extends State<EditProfileScrn> {
  void getuserdetails() async {
    UserDetails? userdetails = await getUserDetailsByEmail(widget.user.email);
    if (userdetails != null) {
      nameeditingcontroller.text = userdetails.name;
      emaileditingcontroller.text = userdetails.email;
      phoneeditingcontroller.text = userdetails.phonenumber;
      subjecteditingcontroller.text = userdetails.subject ?? '';
      institutionnameeditingcontroller.text = userdetails.institutionname ?? '';
      if (userdetails.profilepic != null) {
        final imagesrc = userdetails.profilepic!;
        setState(() {
          image = File(imagesrc);
        });
      }
      userdetailsvlauenotifier.value = userdetails;
    }
  }

  @override
  void initState() {
    getuserdetails();
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
              'Edit Profile',
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
              padding: const EdgeInsets.all(10),
              width: size.width,
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                            radius: size.width / 4,
                            backgroundImage:
                                image != null ? FileImage(image!) : null,
                            child: image == null
                                ? const Icon(LineAwesomeIcons.user)
                                : null),
                        Positioned(
                            bottom: 0,
                            right: 10,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: size.height / 3.5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Select the Options',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ImageUploadWidget(
                                                  title: 'Gallery',
                                                  icon: Icons.photo_album,
                                                  onTap: () async {
                                                    File? pickedImage =
                                                        await selectImageFromGallery(
                                                            context,
                                                            ImageSource
                                                                .gallery);
                                                    setState(() {
                                                      image = pickedImage;
                                                    });
                                                  },
                                                ),
                                                ImageUploadWidget(
                                                  title: 'Camera',
                                                  icon: Icons.camera_alt,
                                                  onTap: () async {
                                                    File? pickedImage =
                                                        await selectImageFromGallery(
                                                            context,
                                                            ImageSource.camera);
                                                    setState(() {
                                                      image = pickedImage;
                                                    });
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const CircleAvatar(
                                radius: 27,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 25,
                                  child: Icon(Icons.camera),
                                ),
                              ),
                            ))
                      ],
                    ),
                    AddTextFeildWidget(
                      title: 'Full Name',
                      textlabel: 'Enter Full Name',
                      iconData: Icons.person_2,
                      controller: nameeditingcontroller,
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
                      title: 'Phone No',
                      controller: phoneeditingcontroller,
                      textlabel: 'Phone No',
                      iconData: Icons.phone,
                      validator: (val) {
                        return RegExp(r"(^(?:[+0]9)?[0-9]{10,12}$)")
                                .hasMatch(val!)
                            ? null
                            : "Please enter valid mobile number";
                      },
                    ),
                    AddTextFeildWidget(
                      title: 'Subject',
                      controller: subjecteditingcontroller,
                      textlabel: 'Enter Subject No',
                      iconData: Icons.phone,
                      validator: (val) {
                        return RegExp(r'[!@#<>?:_`"~;[\]\\|=+)(*&^%0-9-]')
                                .hasMatch(val!)
                            ? "Please enter valid Subject"
                            : null;
                      },
                    ),
                    const SizedBox(height: 15),
                    AddTextFeildWidget(
                      title: 'Institution',
                      controller: institutionnameeditingcontroller,
                      textlabel: 'Enter Institution',
                      iconData: LineAwesomeIcons.address_card,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Your Institution";
                        } else {
                          return RegExp(r'[!@#<>?:_`"~;[\]\\|=+)(*&^%0-9-]')
                                  .hasMatch(value)
                              ? "Please enter valid Institution"
                              : null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: size.width,
                      height: 50,
                      child: ElevatedBtnWidget(
                          onPressed: () {
                            saveUserDetails(userdetailsvlauenotifier.value);
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

  void saveUserDetails(UserDetails preUserdetails) async {
    if (formkey.currentState!.validate()) {
      int key = await getusermodelkey(preUserdetails);
      final updateduserdetails = UserDetails(
          name: nameeditingcontroller.text.trim(),
          email: emaileditingcontroller.text,
          password: preUserdetails.password,
          phonenumber: phoneeditingcontroller.text.trim(),
          institutionname: institutionnameeditingcontroller.text.trim(),
          subject: subjecteditingcontroller.text.trim(),
          profilepic: image?.path);
      await updateuserdetails(key, updateduserdetails);
      newshowSnackbar(context, 'Profile Updated', 'Successful updated profile',
          ContentType.success);
      await getUserdetails(updateduserdetails.email);
      Navigator.of(context).pop();
    }
  }
}

Future<int> getusermodelkey(UserDetails userDetails) async {
  final box = await Hive.openBox<UserDetails>('userDB');
  int key = box.keyAt(box.values.toList().indexOf(userDetails));
  return key;
}
