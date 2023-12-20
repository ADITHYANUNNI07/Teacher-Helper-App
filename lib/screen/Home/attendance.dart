// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/classmodel.dart';
import 'package:eduvista/screen/Home/addclass.dart';
import 'package:eduvista/screen/Home/classmenu.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class AttendanceScrn extends StatefulWidget {
  const AttendanceScrn({super.key, required this.email});
  final String email;

  @override
  State<AttendanceScrn> createState() => _AttendanceScrnState();
}

ValueNotifier<List<ClassModel>> classModelsNotifier =
    ValueNotifier<List<ClassModel>>([]);

class _AttendanceScrnState extends State<AttendanceScrn> {
  @override
  void initState() {
    super.initState();
    updateClassModels(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0Xff188F79),
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
            'Attendance',
            style: GoogleFonts.poppins(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: ValueListenableBuilder<List<ClassModel>>(
                  valueListenable: classModelsNotifier,
                  builder: (context, classModels, child) {
                    return classModels.isEmpty
                        ? Center(
                            child: LottieBuilder.asset(
                                'assets/animation/PUyQfE9kMM.json'),
                          )
                        : ListView.separated(
                            itemCount: classModels.length,
                            itemBuilder: (context, index) {
                              print(classModels[index].image);
                              return Slidable(
                                endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.red,
                                        label: 'Delete',
                                        icon: Icons.delete,
                                        spacing: 10,
                                        borderRadius: BorderRadius.circular(9),
                                        onPressed: (context) async {
                                          deleteClass(
                                              context,
                                              classModels[index].classname,
                                              index);
                                        },
                                      )
                                    ]),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ClassMenuScrn(
                                              cls: classModels[index]),
                                        ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9),
                                      color: const Color(0Xff188F79),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey, blurRadius: 2)
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        FutureBuilder<String>(
                                          future: getImageUrl(
                                              classModels[index].image),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircleAvatar(
                                                radius: 55,
                                                backgroundColor: Colors.white,
                                                child: LottieBuilder.asset(
                                                    'assets/animation/Animation-1703042156574.json'),
                                              );
                                            } else if (snapshot.hasError) {
                                              return CircleAvatar(
                                                radius: 55,
                                                backgroundColor: Colors.white,
                                                child: LottieBuilder.asset(
                                                    'assets/animation/animation_lo4efsbq.json'),
                                              );
                                            } else {
                                              return CircleAvatar(
                                                radius: 55,
                                                backgroundColor: Colors.white,
                                                backgroundImage: NetworkImage(
                                                    classModels[index].image),
                                              );
                                            }
                                          },
                                        ),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              classModels[index].classname,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              classModels[index].department,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 15),
                          );
                  },
                ),
              ),
            ),
          ],
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
                builder: (context) => AddClassScrn(email: widget.email),
              ),
            );
          },
        ),
      ),
    );
  }

  void deleteClass(BuildContext context, String classname, int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete $classname class"),
          content: Text("Are you sure you want to delete class $classname?"),
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
                final value = await deleteClassFromHive(index);
                if (value) {
                  newshowSnackbar(
                      context,
                      'Successfully Deleted',
                      '$classname class deleted successfully',
                      ContentType.success);
                } else {
                  newshowSnackbar(context, '$classname not delete',
                      'Error occur in Database ', ContentType.failure);
                }
                updateClassModels(widget.email);
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

Future<void> updateClassModels(String email) async {
  List<ClassModel> userClassModels = await getClassByEmail(email);
  classModelsNotifier.value = userClassModels;
  classModelsNotifier.notifyListeners();
}

Future<String> getImageUrl(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load image: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching image: $e');
    throw Exception('Failed to load image');
  }
}
