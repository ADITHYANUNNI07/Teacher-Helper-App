import 'package:eduvista/screen/Home/class/pdf.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';

class StudyMaterialScrn extends StatefulWidget {
  const StudyMaterialScrn({super.key});

  @override
  State<StudyMaterialScrn> createState() => _StudyMaterialScrnState();
}

final folderController = TextEditingController();
final fromKey = GlobalKey<FormState>();

class _StudyMaterialScrnState extends State<StudyMaterialScrn> {
  @override
  Widget build(BuildContext context) {
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
              'Study Material',
              style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Container(),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.add_event,
            animatedIconTheme: const IconThemeData(size: 22.0),
            backgroundColor: const Color(0Xff188F79),
            children: [
              SpeedDialChild(
                child: const Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                ),
                backgroundColor: Colors.green,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PDF(),
                  ));
                },
                label: 'Add Image',
              ),
              SpeedDialChild(
                child: const Icon(
                  Icons.create_new_folder,
                  color: Colors.white,
                ),
                backgroundColor: Colors.orange,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Create New Folder"),
                        actions: [
                          Form(
                            key: fromKey,
                            child: TextFormWidget(
                              label: 'Folder Name',
                              icon: Icons.folder,
                              controller: folderController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter Your Folder Name";
                                } else {
                                  return RegExp(
                                              r'[!@#<>?:_`"~;[\]\\|=+)(*&^%0-9-]')
                                          .hasMatch(value)
                                      ? "Please enter valid name"
                                      : null;
                                }
                              },
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0Xff188F79)),
                            onPressed: () {
                              if (fromKey.currentState!.validate()) {}
                            },
                            child: Text(
                              "CREATE",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                label: 'Create New Folder',
              ),
              SpeedDialChild(
                child: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
                onTap: () {},
                label: 'Add PDF',
              )
            ],
          ),
        ),
      ),
    );
  }
}
