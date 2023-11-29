// ignore_for_file: use_build_context_synchronously, implementation_imports, unnecessary_null_comparison

import 'dart:io';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/foldermodel.dart';
import 'package:eduvista/screen/Home/addclass.dart';
import 'package:eduvista/screen/welcome.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:awesome_snackbar_content/src/content_type.dart';
import 'package:open_file/open_file.dart';

class StudyMaterialScrn extends StatefulWidget {
  const StudyMaterialScrn(
      {super.key, required this.foldername, required this.email});
  final String foldername;
  final String email;
  @override
  State<StudyMaterialScrn> createState() => _StudyMaterialScrnState();
}

class _StudyMaterialScrnState extends State<StudyMaterialScrn> {
  @override
  void initState() {
    super.initState();
    createfolderModel();
  }

  final folderController = TextEditingController();
  File? image;
  PickedPdf? pdf;
  final fromKeyfolder = GlobalKey<FormState>();
  final GlobalKey<FutureBuilderclassState> futurebuilderkey =
      GlobalKey<FutureBuilderclassState>();
  void createfolderModel() async {
    bool isfolderNot = true;
    List<FolderModel> allFolder = await getFolderFromHive(widget.email);
    for (var folder in allFolder) {
      if (folder.folderName.trim() == widget.foldername.trim()) {
        isfolderNot = false;
      }
    }
    if (isfolderNot) {
      final newfoldermodel = FolderModel(
          createtime: DateTime.now(),
          updatetime: DateTime.now(),
          email: widget.email,
          folderName: widget.foldername,
          folderModel: []);
      print('createdddd....');
      final cr = await addFoldertoHive(newfoldermodel);
      print(cr);
      final did = await getFolderFromHive(widget.email);
      print(did.length);
    }
    final did = await getFolderFromHive(widget.email);
    print(did.length);
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
              widget.foldername == widget.email
                  ? 'Study Material'
                  : widget.foldername,
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
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: Column(
                children: [
                  FutureBuilderclass(
                    key: futurebuilderkey,
                    email: widget.email,
                    foldername: widget.foldername,
                  ),
                ],
              )),
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
                onTap: () async {
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
                                              context, ImageSource.gallery);
                                      setState(() {
                                        image = pickedImage;
                                      });
                                      imageupload(
                                          image,
                                          context,
                                          widget.foldername,
                                          futurebuilderkey,
                                          widget.email);
                                    },
                                  ),
                                  ImageUploadWidget(
                                    title: 'Camera',
                                    icon: Icons.camera_alt,
                                    onTap: () async {
                                      File? pickedImage =
                                          await selectImageFromGallery(
                                              context, ImageSource.camera);
                                      setState(() {
                                        image = pickedImage;
                                      });
                                      imageupload(
                                          image,
                                          context,
                                          widget.foldername,
                                          futurebuilderkey,
                                          widget.email);
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
                            key: fromKeyfolder,
                            child: TextFormWidget(
                              label: 'Folder Name',
                              icon: Icons.folder,
                              controller: folderController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter Your Folder Name";
                                } else {
                                  return RegExp(r'[!@#<>?:_`"~;[\]\\|=+)(*&^%]')
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
                              if (fromKeyfolder.currentState!.validate()) {
                                createFolder(
                                    widget.foldername,
                                    context,
                                    widget.email,
                                    folderController.text.trim(),
                                    futurebuilderkey);
                              }
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
                onTap: () async {
                  final file = await pickPdf();
                  if (file != null) {
                    setState(() {
                      pdf = file;
                    });
                    pdfUpload(pdf!, context, widget.foldername,
                        futurebuilderkey, widget.email);
                  }
                },
                label: 'Add PDF',
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FutureBuilderclass extends StatefulWidget {
  const FutureBuilderclass({
    Key? key,
    required this.email,
    required this.foldername,
  }) : super(key: key);
  final String email;
  final String foldername;

  @override
  FutureBuilderclassState createState() => FutureBuilderclassState();
}

class FutureBuilderclassState extends State<FutureBuilderclass> {
  late Future<List<FolderModel>> future;

  @override
  void initState() {
    super.initState();
    future = getFolderFromHive(widget.email);
  }

  void refresh() {
    future = getFolderFromHive(widget.email);
  }

  void refreshthefuture(String email) {
    future = getFolderFromHive(email);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FolderModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child:
                LottieBuilder.asset('assets/animation/animation_lo4efsbq.json'),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: LottieBuilder.asset('assets/animation/hkZtpfwq0R.json'),
          );
        } else {
          FolderModel? mainfoldermodel;
          List<FolderModel> foldermodellist = snapshot.data!;
          List<SubFolderModel> newlist = [];
          for (var element in foldermodellist) {
            if (element.folderName == widget.foldername) {
              mainfoldermodel = element;
              for (var i in element.folderModel) {
                newlist.add(i);
              }
            }
          }
          return newlist.isNotEmpty
              ? Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: newlist.length,
                    itemBuilder: (context, index) {
                      SubFolderModel subFolderModel = newlist[index];
                      if (subFolderModel.name == 'image') {
                        File imageFile = File(subFolderModel.path);

                        if (imageFile.existsSync()) {
                          return Image.file(imageFile);
                        } else {
                          return Text(
                            'Image is not found',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(),
                          );
                        }
                      } else if (subFolderModel.name == 'pdf') {
                        return InkWell(
                          onTap: () async {
                            try {
                              await OpenFile.open(subFolderModel.path);
                            } catch (e) {
                              print("Error opening file: $e");
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0Xff188F79),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  subFolderModel.pdfname!,
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (subFolderModel.name == 'folder') {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudyMaterialScrn(
                                      foldername: subFolderModel.path,
                                      email: widget.email),
                                ));
                          },
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                const SizedBox(width: 5),
                                SlidableAction(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue.shade300,
                                  label: 'Share',
                                  icon: Icons.share,
                                  spacing: 10,
                                  borderRadius: BorderRadius.circular(9),
                                  onPressed: (context) async {},
                                ),
                                const SizedBox(width: 5),
                                SlidableAction(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red.shade300,
                                  label: 'Delete',
                                  icon: Icons.delete,
                                  spacing: 10,
                                  borderRadius: BorderRadius.circular(9),
                                  onPressed: (context) {
                                    deleteFolder(
                                        context,
                                        subFolderModel.path,
                                        index,
                                        foldermodellist,
                                        widget.email,
                                        mainfoldermodel);
                                  },
                                )
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0Xff188F79),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.only(
                                  left: 20, top: 40, bottom: 40),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.folder,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    subFolderModel.path,
                                    style: GoogleFonts.poppins(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                )
              : Center(
                  child:
                      LottieBuilder.asset('assets/animation/PUyQfE9kMM.json'),
                );
        }
      },
    );
  }
}

void createFolder(
    String foldername,
    BuildContext context,
    String email,
    String newfoldername,
    GlobalKey<FutureBuilderclassState> futurebuilderkey) async {
  bool isalready = false;
  FolderModel? existfolder;
  print(email);
  final allfolder = await getFolderFromHive(email);
  print(allfolder.length);
  for (var folder in allfolder) {
    print('${folder.folderName}:::::$foldername');
    if (folder.folderName == foldername) {
      existfolder = folder;
      for (var subfolder in existfolder.folderModel) {
        if (subfolder.path == newfoldername) {
          isalready = true;
        }
      }
    }
    if (folder.folderName == newfoldername) {
      isalready = true;
    }
  }
  if (isalready == false) {
    if (existfolder != null) {
      int key = getKeyOfFoldermodel(existfolder);
      final foldermodel = FolderModel(
        createtime: DateTime.now(),
        updatetime: DateTime.now(),
        email: email,
        folderName: foldername,
        folderModel: List<SubFolderModel>.from(existfolder.folderModel)
          ..add(
            SubFolderModel(
                path: newfoldername.trim(), name: 'folder', pdfname: ''),
          ),
      );
      await updateFolderInHive(foldermodel, key);
      final futureBuilderState = futurebuilderkey.currentState;
      if (futureBuilderState != null) {
        futureBuilderState.refresh();
      }
      Navigator.pop(context);
      newshowSnackbar(context, 'Successfully create Folder',
          'Successfully create Folder $foldername', ContentType.success);
    } else {
      print('dafgjhdguhdfsgj.........................');
    }
  } else {
    newshowSnackbar(context, 'Folder name Already existing',
        'please create another folder name', ContentType.failure);
    Navigator.pop(context);
  }
}

void imageupload(File? image, BuildContext context, String foldername,
    GlobalKey<FutureBuilderclassState> futurebuilderkey, String email) async {
  FolderModel? existfolder;
  List<FolderModel> allFolder = await getFolderFromHive(email);
  for (var folder in allFolder) {
    if (folder.folderName == foldername) {
      existfolder = folder;
    }
  }
  if (image != null) {
    List<SubFolderModel> listpath = [];
    listpath.add(SubFolderModel(path: image.path, name: 'image', pdfname: ''));
    if (existfolder != null) {
      int key = getKeyOfFoldermodel(existfolder);
      final foldermodel = FolderModel(
          createtime: existfolder.createtime,
          updatetime: DateTime.now(),
          email: existfolder.email,
          folderName: existfolder.folderName,
          folderModel: List<SubFolderModel>.from(existfolder.folderModel)
            ..add(
                SubFolderModel(path: image.path, name: 'image', pdfname: '')));
      await updateFolderInHive(foldermodel, key);
      final futureBuilderState = futurebuilderkey.currentState;
      if (futureBuilderState != null) {
        futureBuilderState.refresh();
      }
      Navigator.pop(context);
      newshowSnackbar(context, 'Successfully upload Image',
          'Successfully upload the image', ContentType.success);
    }
  } else {
    newshowSnackbar(context, 'Image Not support', 'Please select another image',
        ContentType.success);
  }
}

void pdfUpload(PickedPdf pickedPdf, BuildContext context, String foldername,
    GlobalKey<FutureBuilderclassState> futurebuilderkey, String email) async {
  FolderModel? existfolder;
  List<FolderModel> allFolder = await getFolderFromHive(email);
  for (var folder in allFolder) {
    if (folder.folderName == foldername) {
      existfolder = folder;
    }
  }
  List<SubFolderModel> listpath = [];
  listpath.add(
    SubFolderModel(
        path: pickedPdf.file.path, name: 'pdf', pdfname: pickedPdf.fileName),
  );
  if (existfolder != null) {
    int key = getKeyOfFoldermodel(existfolder);
    final foldermodel = FolderModel(
        createtime: existfolder.createtime,
        updatetime: DateTime.now(),
        email: existfolder.email,
        folderName: existfolder.folderName,
        folderModel: List<SubFolderModel>.from(existfolder.folderModel)
          ..add(SubFolderModel(
              path: pickedPdf.file.path,
              name: 'pdf',
              pdfname: pickedPdf.fileName)));
    await updateFolderInHive(foldermodel, key);
    final futureBuilderState = futurebuilderkey.currentState;
    if (futureBuilderState != null) {
      futureBuilderState.refresh();
    }
    newshowSnackbar(context, 'Successfully upload PDF',
        'Successfully upload the PDF', ContentType.success);
  }
}

int getKeyOfFoldermodel(FolderModel folderModel) {
  var box = Hive.box<FolderModel>('folderDB');
  var key = box.keyAt(box.values.toList().indexOf(folderModel));
  return key;
}

void deleteFolder(
    BuildContext context,
    String foldername,
    int index,
    List<FolderModel> userfolderlist,
    String email,
    FolderModel? mainfolderModel) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Delete $foldername Folder"),
        content: Text("Are you sure you want to delete folder $foldername?"),
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
              List<SubFolderModel> subfolderlist = [];
              if (mainfolderModel != null) {
                for (var element in mainfolderModel.folderModel) {
                  if (element.path != foldername) {
                    subfolderlist.add(element);
                  }
                }
                final updatedmodel = FolderModel(
                    email: mainfolderModel.email,
                    folderName: mainfolderModel.folderName,
                    folderModel: subfolderlist,
                    createtime: mainfolderModel.createtime,
                    updatetime: DateTime.now());
                int key = getKeyOfFoldermodel(mainfolderModel);
                await updateFolderInHive(updatedmodel, key);
                bool value = false;
                FolderModel? exitfolder;
                for (var element in userfolderlist) {
                  if (element.folderName == foldername) {
                    exitfolder = element;
                  }
                }
                if (exitfolder != null) {
                  print('object');
                  int key = getKeyOfFoldermodel(exitfolder);
                  value = await deleteFolderFromHive(key);
                } else {
                  final newfoldermodel = FolderModel(
                      createtime: DateTime.now(),
                      updatetime: DateTime.now(),
                      email: email,
                      folderName: foldername,
                      folderModel: []);
                  await addFoldertoHive(newfoldermodel);
                  int key = getKeyOfFoldermodel(newfoldermodel);
                  value = await deleteFolderFromHive(key);
                  print(value);
                }
                if (value) {
                  newshowSnackbar(context, 'Successfully Deleted',
                      '$foldername  deleted successfully', ContentType.success);
                } else {
                  newshowSnackbar(context, '$foldername not delete',
                      'Error occur in Database ', ContentType.failure);
                }
              }
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          )
        ],
      );
    },
  );
}
