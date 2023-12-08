// ignore_for_file: use_build_context_synchronously, implementation_imports, unnecessary_null_comparison, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
import 'package:path/path.dart';
import 'dart:io';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/favoritesmodel.dart';
import 'package:eduvista/model/foldermodel.dart';
import 'package:eduvista/screen/Home/addclass.dart';
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
import 'package:share/share.dart';

class StudyMaterialScrn extends StatefulWidget {
  const StudyMaterialScrn(
      {super.key, required this.foldername, required this.email});
  final String foldername;
  final String email;
  @override
  State<StudyMaterialScrn> createState() => _StudyMaterialScrnState();
}

ValueNotifier<List<FavoritesModel>> favoritelistvaluenotifier =
    ValueNotifier<List<FavoritesModel>>([]);

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
                                      Map<String, dynamic>? imagemap =
                                          await selectImageFromGallery(
                                              context, ImageSource.gallery);
                                      if (imagemap != null) {
                                        setState(() {
                                          image = imagemap['file'];
                                        });
                                        imageupload(
                                            image,
                                            context,
                                            widget.foldername,
                                            futurebuilderkey,
                                            widget.email,
                                            imagemap['imageName']);
                                      }
                                    },
                                  ),
                                  ImageUploadWidget(
                                    title: 'Camera',
                                    icon: Icons.camera_alt,
                                    onTap: () async {
                                      Map<String, dynamic>? imagemap =
                                          await selectImageFromGallery(
                                              context, ImageSource.gallery);
                                      if (imagemap != null) {
                                        setState(() {
                                          image = imagemap['file'];
                                        });
                                        imageupload(
                                            image,
                                            context,
                                            widget.foldername,
                                            futurebuilderkey,
                                            widget.email,
                                            imagemap['imageName']);
                                      }
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

Future<void> getfaviourateList(String email) async {
  final favoritelist = await getFavoritesFromHive(email);
  favoritelistvaluenotifier.value = favoritelist;
  favoritelistvaluenotifier.notifyListeners();
}

int favoritemodelkey(FavoritesModel favoritesModel) {
  var box = Hive.box<FavoritesModel>('FavoritesDB');
  var key = box.keyAt(box.values.toList().indexOf(favoritesModel));
  return key;
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
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final editformkey = GlobalKey<FormState>();
  TextEditingController editFoldercontroller = TextEditingController();
  Future<List<FolderModel>> refreshTheFuture() async {
    return getFolderFromHive(widget.email);
  }

  @override
  void initState() {
    super.initState();
    future = getFolderFromHive(widget.email);
  }

  void refresh() {
    future = getFolderFromHive(widget.email);
    refreshKey.currentState?.show();
  }

  Future<void> refreshthefuture() async {
    future = getFolderFromHive(widget.email);
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          List<FolderModel> updatedData = await refreshTheFuture();
          setState(() {
            future = Future.value(updatedData);
          });
        },
        child: FutureBuilder<List<FolderModel>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LottieBuilder.asset(
                    'assets/animation/animation_lo4efsbq.json'),
              );
            } else if (snapshot.hasError) {
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
                          bool? isfavorite;
                          FavoritesModel? favoritesModel;
                          for (var element in favoritelistvaluenotifier.value) {
                            if (element.path == subFolderModel.path &&
                                element.foldername == widget.foldername) {
                              isfavorite = true;
                              favoritesModel = element;
                              break;
                            }
                            isfavorite = false;
                          }
                          if (subFolderModel.name == 'image') {
                            File imageFile = File(subFolderModel.path);
                            if (imageFile.existsSync()) {
                              return InkWell(
                                  onTap: () {
                                    showSelectedImageDialog(context, imageFile);
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
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          onPressed: (context) async {
                                            imagePdfShareFn(
                                                subFolderModel.path);
                                          },
                                        ),
                                        const SizedBox(width: 5),
                                        SlidableAction(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.red.shade300,
                                          label: 'Delete',
                                          icon: Icons.delete,
                                          spacing: 10,
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          onPressed: (context) async {
                                            await imagePdf(
                                                context,
                                                subFolderModel,
                                                mainfoldermodel!,
                                                subFolderModel.path);
                                            refreshKey.currentState?.show();
                                          },
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: const Color(0Xff188F79),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.all(20),
                                      child: AspectRatio(
                                        aspectRatio: 10 / 5,
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              child: Image.file(imageFile),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      subFolderModel.pdfname!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    IconButton(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      icon: Icon(
                                                        isfavorite == true
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_outline,
                                                        size: 30,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () async {
                                                        if (isfavorite ==
                                                            true) {
                                                          int key =
                                                              favoritemodelkey(
                                                                  favoritesModel!);
                                                          await deleteFavoritesFromHive(
                                                              key);
                                                        } else {
                                                          final favoritesModel =
                                                              FavoritesModel(
                                                            foldername: widget
                                                                .foldername,
                                                            email: widget.email,
                                                            path: subFolderModel
                                                                .path,
                                                            type: subFolderModel
                                                                .name,
                                                          );

                                                          await addFavoritetoHive(
                                                              favoritesModel);
                                                        }
                                                        refreshKey.currentState
                                                            ?.show();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            } else {
                              return Text(
                                'Image is not found',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(),
                              );
                            }
                          } else if (subFolderModel.name == 'pdf') {
                            return InkWell(
                              onLongPress: () async {
                                await imagePdf(context, subFolderModel,
                                    mainfoldermodel!, subFolderModel.path);
                                refreshKey.currentState?.show();
                              },
                              onTap: () async {
                                try {
                                  await OpenFile.open(subFolderModel.path);
                                } catch (e) {}
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
                                      onPressed: (context) async {
                                        imagePdfShareFn(subFolderModel.path);
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
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
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                          alignment: Alignment.bottomRight,
                                          icon: Icon(
                                            isfavorite == true
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            if (isfavorite == true) {
                                              int key = favoritemodelkey(
                                                  favoritesModel!);
                                              await deleteFavoritesFromHive(
                                                  key);
                                            } else {
                                              final favoritesModel =
                                                  FavoritesModel(
                                                      pdfname: subFolderModel
                                                          .pdfname,
                                                      foldername:
                                                          widget.foldername,
                                                      email: widget.email,
                                                      path: subFolderModel.path,
                                                      type:
                                                          subFolderModel.name);

                                              await addFavoritetoHive(
                                                  favoritesModel);
                                            }
                                            refreshKey.currentState?.show();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
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
                                startActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.green.shade300,
                                        label: 'Edit',
                                        icon: Icons.edit,
                                        spacing: 10,
                                        borderRadius: BorderRadius.circular(9),
                                        onPressed: (context) async {
                                          editFoldercontroller.text =
                                              subFolderModel.path;
                                          await editfolder(
                                              editformkey,
                                              editFoldercontroller,
                                              subFolderModel,
                                              context,
                                              widget.foldername,
                                              widget.email,
                                              mainfoldermodel!);
                                          refreshKey.currentState?.show();
                                        },
                                      ),
                                    ]),
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
                                      onPressed: (context) async {
                                        List<String> paths = [];
                                        FolderModel? existfolder;
                                        final allfolder =
                                            await getFolderFromHive(
                                                widget.email);
                                        for (var folder in allfolder) {
                                          if (folder.folderName ==
                                              subFolderModel.path) {
                                            existfolder = folder;
                                            for (var subfolder
                                                in existfolder.folderModel) {
                                              if (subfolder.name != 'folder') {
                                                paths.add(subfolder.path);
                                              }
                                            }
                                          }
                                        }
                                        shareFolderFn(paths, context);
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    SlidableAction(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red.shade300,
                                      label: 'Delete',
                                      icon: Icons.delete,
                                      spacing: 10,
                                      borderRadius: BorderRadius.circular(9),
                                      onPressed: (context) async {
                                        final mainfolderlist =
                                            await getFolderFromHive(
                                                widget.email);
                                        await deleteFolder(
                                            context,
                                            subFolderModel.path,
                                            index,
                                            mainfolderlist,
                                            widget.email,
                                            mainfoldermodel);
                                        refreshKey.currentState?.show();
                                      },
                                    )
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0Xff188F79),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 40, bottom: 40),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.folder,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          subFolderModel.path,
                                          style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isfavorite == true
                                              ? Icons.favorite
                                              : Icons.favorite_outline,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          if (isfavorite == true) {
                                            int key = favoritemodelkey(
                                                favoritesModel!);
                                            await deleteFavoritesFromHive(key);
                                          } else {
                                            final favoritesModel =
                                                FavoritesModel(
                                                    foldername:
                                                        widget.foldername,
                                                    email: widget.email,
                                                    path: subFolderModel.path,
                                                    type: subFolderModel.name);

                                            await addFavoritetoHive(
                                                favoritesModel);
                                          }
                                          refreshKey.currentState?.show();
                                        },
                                      )
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
                      child: LottieBuilder.asset(
                          'assets/animation/PUyQfE9kMM.json'),
                    );
            }
          },
        ),
      ),
    );
  }
}

Future<void> editfolder(
    GlobalKey<FormState> editformkey,
    TextEditingController folderEditingcontroller,
    SubFolderModel folderModel,
    BuildContext context,
    String foldername,
    String email,
    FolderModel mainFoldermodel) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Folder Name"),
        actions: [
          Form(
            key: editformkey,
            child: TextFormWidget(
              label: 'Folder Name',
              icon: Icons.folder,
              controller: folderEditingcontroller,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter Your Folder Name";
                } else {
                  return RegExp(r'[!@#<>?:_`"~;[\]\\|=+)(*&^%]').hasMatch(value)
                      ? "Please enter valid name"
                      : null;
                }
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0Xff188F79)),
            onPressed: () async {
              if (editformkey.currentState!.validate()) {
                bool isalready = false;
                FolderModel? previousfolderModel;
                final allfolder = await getFolderFromHive(email);

                for (var folder in allfolder) {
                  if (folder.folderName == foldername) {
                    for (var subfolder in folder.folderModel) {
                      if (subfolder.path == folderEditingcontroller.text) {
                        isalready = true;
                      }
                    }
                  }
                  if (folder.folderName == folderModel.path) {
                    previousfolderModel = folder;
                    print(previousfolderModel);
                  }
                  if (folder.folderName == folderEditingcontroller.text) {
                    isalready = true;
                  }
                }
                if (isalready == false) {
                  List<SubFolderModel> newmodels = [];
                  int key = getKeyOfFoldermodel(mainFoldermodel);
                  for (var subfolder in mainFoldermodel.folderModel) {
                    if (subfolder.path == folderModel.path) {
                      newmodels.add(
                        SubFolderModel(
                            path: folderEditingcontroller.text,
                            name: subfolder.name,
                            pdfname: subfolder.pdfname),
                      );
                    } else {
                      newmodels.add(subfolder);
                    }
                  }
                  final updateFoldermodel = FolderModel(
                      email: mainFoldermodel.email,
                      folderName: mainFoldermodel.folderName,
                      folderModel: newmodels,
                      createtime: mainFoldermodel.createtime,
                      updatetime: DateTime.now());
                  await updateFolderInHive(updateFoldermodel, key);
                  if (previousfolderModel != null) {
                    final updateFoldermodel = FolderModel(
                        email: mainFoldermodel.email,
                        folderName: folderEditingcontroller.text,
                        folderModel: mainFoldermodel.folderModel,
                        createtime: mainFoldermodel.createtime,
                        updatetime: DateTime.now());
                    await updateFolderInHive(updateFoldermodel, key);
                  }
                } else {
                  newshowSnackbar(context, 'Folder name Already existing',
                      'please create another folder name', ContentType.failure);
                }
              }
              Navigator.pop(context);
            },
            child: Text(
              "UPDATE",
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
}

void createFolder(
    String foldername,
    BuildContext context,
    String email,
    String newfoldername,
    GlobalKey<FutureBuilderclassState> futurebuilderkey) async {
  bool isalready = false;
  FolderModel? existfolder;

  final allfolder = await getFolderFromHive(email);

  for (var folder in allfolder) {
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
    } else {}
  } else {
    newshowSnackbar(context, 'Folder name Already existing',
        'please create another folder name', ContentType.failure);
    Navigator.pop(context);
  }
}

void imageupload(
    File? image,
    BuildContext context,
    String foldername,
    GlobalKey<FutureBuilderclassState> futurebuilderkey,
    String email,
    String imagename) async {
  FolderModel? existfolder;
  List<FolderModel> allFolder = await getFolderFromHive(email);
  for (var folder in allFolder) {
    if (folder.folderName == foldername) {
      existfolder = folder;
    }
  }
  if (image != null) {
    List<SubFolderModel> listpath = [];
    listpath.add(
        SubFolderModel(path: image.path, name: 'image', pdfname: imagename));
    if (existfolder != null) {
      int key = getKeyOfFoldermodel(existfolder);
      final foldermodel = FolderModel(
          createtime: existfolder.createtime,
          updatetime: DateTime.now(),
          email: existfolder.email,
          folderName: existfolder.folderName,
          folderModel: List<SubFolderModel>.from(existfolder.folderModel)
            ..add(SubFolderModel(
                path: image.path, name: 'image', pdfname: imagename)));
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
        ..add(
          SubFolderModel(
            path: pickedPdf.file.path,
            name: 'pdf',
            pdfname: pickedPdf.fileName,
          ),
        ),
    );
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

Future<void> deleteFolder(
    BuildContext context,
    String foldername,
    int index,
    List<FolderModel> userfolderlist,
    String email,
    FolderModel? mainfolderModel) async {
  await showDialog(
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
                  int key = getKeyOfFoldermodel(exitfolder);
                  value = await deleteFolderFromHive(key);
                } else {
                  final newfoldermodel = FolderModel(
                    createtime: DateTime.now(),
                    updatetime: DateTime.now(),
                    email: email,
                    folderName: foldername,
                    folderModel: [],
                  );
                  await addFoldertoHive(newfoldermodel);
                  int key = getKeyOfFoldermodel(newfoldermodel);
                  value = await deleteFolderFromHive(key);
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

Future<void> imagePdf(BuildContext context, SubFolderModel subFolderModel,
    FolderModel mainfolderModel, String path) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Delete ${subFolderModel.name}"),
        content: Text(
            "Are you sure you want to delete folder ${subFolderModel.name} ?"),
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
                  if (element.path != path) {
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

void imagePdfShareFn(String path) async {
  final filePath = path;
  OpenFile.open(filePath);
  Share.shareFiles([filePath], text: 'image');
}

void shareFolderFn(List<String> paths, BuildContext context) async {
  if (paths.isEmpty) {
    newshowSnackbar(context, 'Folder is Empty', 'Please add pdf and image ',
        ContentType.failure);
    return;
  }

  try {
    await Share.shareFiles(paths, text: 'Share Files');
  } catch (e) {}
}

Future<Map<String, dynamic>?> selectImageFromGallery(
  BuildContext context,
  ImageSource option,
) async {
  Map<String, dynamic>? result;
  try {
    final pickedImage = await ImagePicker().pickImage(source: option);
    if (pickedImage != null) {
      final image = File(pickedImage.path);
      final imageName = basename(image.path);
      result = {'file': image, 'imageName': imageName};
    }
  } catch (e) {
    __showSnackBar(context, e.toString());
  }
  return result;
}

void __showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

void showSelectedImageDialog(BuildContext context, File imageFile) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.file(imageFile),
        ),
      );
    },
  );
}
