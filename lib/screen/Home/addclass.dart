// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/classmodel.dart';
import 'package:eduvista/screen/Home/attendance.dart';
import 'package:eduvista/screen/dashboard.dart';
import 'package:eduvista/screen/studymaterial.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class AddClassScrn extends StatefulWidget {
  const AddClassScrn({super.key, required this.email});
  final String email;
  @override
  State<AddClassScrn> createState() => _AddClassScrnState();
}

final classnameController = TextEditingController();
final departmentController = TextEditingController();
final collegenameController = TextEditingController();
File? image;
final fromKey = GlobalKey<FormState>();
Uint8List? webImage;
ValueNotifier<bool> isloadingvaluenotifier = ValueNotifier<bool>(false);

class _AddClassScrnState extends State<AddClassScrn> {
  @override
  void initState() {
    getUserdetails(widget.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
        color: const Color(0Xff188F79),
        child: ValueListenableBuilder(
            valueListenable: isloadingvaluenotifier,
            builder: (context, isloading, child) {
              return isloading
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
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
                            'Create Class',
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
                            width: size.width,
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10),
                            color: const Color(0Xff188F79).withOpacity(0.05),
                            child: Form(
                              key: fromKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AddTextFeildWidget(
                                    title: 'Class Name',
                                    textlabel: 'Enter the Class Name',
                                    controller: classnameController,
                                    iconData: Icons.class_,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Your Class Name";
                                      } else {
                                        return RegExp(
                                                    r'[!@#<>?:_`"~;[\]\\|=+)(*&^%]')
                                                .hasMatch(value)
                                            ? "Please enter valid name"
                                            : null;
                                      }
                                    },
                                  ),
                                  AddTextFeildWidget(
                                    title: 'Department',
                                    textlabel: 'Enter the Department',
                                    controller: departmentController,
                                    iconData: Icons.business_outlined,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Your Department";
                                      } else {
                                        return RegExp(
                                                    r'[!@#<>?:_`"~;[\]\\|=+)(*&^%0-9-]')
                                                .hasMatch(value)
                                            ? "Please enter valid name"
                                            : null;
                                      }
                                    },
                                  ),
                                  AddTextFeildWidget(
                                    title: 'College Name',
                                    textlabel: 'Enter the College Name',
                                    controller: collegenameController,
                                    iconData: LineAwesomeIcons.university,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter Your College Name";
                                      } else {
                                        return RegExp(
                                                    r'[!@#<>?:_`"~;[\]\\|=+)(*&^%0-9-]')
                                                .hasMatch(value)
                                            ? "Please enter valid name"
                                            : null;
                                      }
                                    },
                                  ),
                                  Text(
                                    'Upload Image',
                                    style: GoogleFonts.poppins(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        context: context,
                                        builder: (context) {
                                          return SizedBox(
                                            height: size.height / 3.5,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Select the Options',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 19,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      ImageUploadWidget(
                                                        title: 'Gallery',
                                                        icon: Icons.photo_album,
                                                        onTap: () async {
                                                          if (kIsWeb) {
                                                            Uint8List?
                                                                webimage =
                                                                await selectImageFromGalleryWeb(
                                                                    context,
                                                                    ImageSource
                                                                        .gallery);
                                                            setState(() {
                                                              webImage =
                                                                  webimage;
                                                            });
                                                          } else {
                                                            File? pickedImage =
                                                                await selectImageFromGallery(
                                                                    context,
                                                                    ImageSource
                                                                        .gallery);
                                                            setState(() {
                                                              image =
                                                                  pickedImage;
                                                            });
                                                          }
                                                        },
                                                      ),
                                                      ImageUploadWidget(
                                                        title: 'Camera',
                                                        icon: Icons.camera_alt,
                                                        onTap: () async {
                                                          File? pickedImage =
                                                              await selectImageFromGallery(
                                                                  context,
                                                                  ImageSource
                                                                      .camera);
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                21),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.6),
                                              blurRadius: 2,
                                              spreadRadius: 1)
                                        ],
                                      ),
                                      child: kIsWeb
                                          ? webImage == null
                                              ? Image.asset(
                                                  'assets/images/Image upload-bro.png')
                                              : Image.memory(webImage!)
                                          : image == null
                                              ? Image.asset(
                                                  'assets/images/Image upload-bro.png')
                                              : Image.file(image!),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  SizedBox(
                                      width: size.width,
                                      child: ElevatedBtnWidget(
                                          onPressed: () {
                                            createClass(context, webImage);
                                          },
                                          title: 'CREATE'))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
            }));
  }

  File? savedImageFile;
  void createClass(BuildContext context, Uint8List? webImage) async {
    if (fromKey.currentState!.validate()) {
      if (image != null || webImage != null) {
        String? weborphoneimageurl;
        if (kIsWeb) {
          weborphoneimageurl =
              await uploadImageForWebAndStoreURL(webImage!, context);
        } else {
          weborphoneimageurl = await uploadImageAndStoreURL(image!, context);
        }
        if (weborphoneimageurl != null) {
          final classvalue = ClassModel(
              email: widget.email,
              classname: classnameController.text,
              department: departmentController.text,
              collegename: collegenameController.text,
              image: weborphoneimageurl);
          dynamic value = await addClasstoHive(classvalue);

          if (value == true) {
            newshowSnackbar(
                context,
                'Create Class Successfully',
                '${classnameController.text} create successfully',
                ContentType.success);
            updateClassModels(widget.email);
            classnameController.clear();
            departmentController.clear();
            collegenameController.clear();
            setState(() {
              image = null;
            });
          }
        } else {
          newshowSnackbar(context, 'Class is Not Create',
              '${classnameController.text} not create', ContentType.failure);
        }
      } else {
        newshowSnackbar(
            context, 'Image', 'Please select Image', ContentType.failure);
      }
    }
  }
}

class ImageUploadWidget extends StatelessWidget {
  const ImageUploadWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
  });
  final void Function()? onTap;
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(21),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 2,
                spreadRadius: 1)
          ],
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color(0Xff188F79).withOpacity(0.09),
              ),
              child: Icon(
                icon,
                size: 30,
                color: const Color(0Xff188F79),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

Future<File?> selectImageFromGallery(
    BuildContext context, ImageSource option) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: option);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    __showSnackBar(context, e.toString());
  }
  return image;
}

Future<Uint8List?> selectImageFromGalleryWeb(
    BuildContext context, ImageSource option) async {
  Uint8List? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: option);
    if (pickedImage != null) {
      var f = await pickedImage.readAsBytes();
      image = f;
    }
  } catch (e) {
    __showSnackBar(context, e.toString());
  }
  return image;
}

void __showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

void snackBarFunction(BuildContext context, String content, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
    backgroundColor: color,
  ));
}

Future<String?> uploadImageForWebAndStoreURL(
    Uint8List imageBytes, BuildContext context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    Reference storageReference = FirebaseStorage.instance.ref().child(
        'images/${user!.email}/${DateTime.now().millisecondsSinceEpoch}.jpg');

    UploadTask uploadTask = storageReference.putData(imageBytes);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  } catch (e) {
    newshowSnackbar(
        context, 'Error uploading image: ', '$e', ContentType.failure);
    print(e);
  }
  return null;
}
