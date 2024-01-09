import 'dart:io';

import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/favoritesmodel.dart';
import 'package:eduvista/model/foldermodel.dart';
import 'package:eduvista/model/usermodel.dart';
import 'package:eduvista/screen/studymaterial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';

class FavoritesScrn extends StatefulWidget {
  const FavoritesScrn({super.key, required this.user});
  final UserDetails? user;

  @override
  State<FavoritesScrn> createState() => _FavoritesScrnState();
}

GlobalKey<RefreshIndicatorState> refreshFavKey =
    GlobalKey<RefreshIndicatorState>();
ValueNotifier<List<FavoritesModel>> favlist = ValueNotifier([]);

class _FavoritesScrnState extends State<FavoritesScrn> {
  @override
  void initState() {
    getfav();
    super.initState();
  }

  void getfav() async {
    final list = await getFavoritesFromHive(widget.user!.email);
    favlist.value = list;
    favlist.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: size.width,
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
          child: Column(
            children: [
              Text(
                'Favorites',
                style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: RefreshIndicator(
                  key: refreshFavKey,
                  child: ValueListenableBuilder(
                      valueListenable: favlist,
                      builder: (context, flist, child) {
                        return flist.isNotEmpty
                            ? ListView.separated(
                                itemBuilder: (context, index) {
                                  FavoritesModel subFolderModel = flist[index];
                                  bool isfavorite = true;

                                  if (subFolderModel.type == 'image') {
                                    File imageFile = File(subFolderModel.path);
                                    if (imageFile.existsSync()) {
                                      return InkWell(
                                          onTap: () {
                                            imagePdfShareFn(
                                                subFolderModel.path);
                                          },
                                          child: Stack(
                                            children: [
                                              Image.file(imageFile),
                                              Positioned(
                                                right: 20,
                                                top: 10,
                                                child: IconButton(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  icon: Icon(
                                                    isfavorite == true
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_outline,
                                                    size: 30,
                                                    color:
                                                        const Color(0Xff188F79),
                                                  ),
                                                  onPressed: () async {
                                                    if (isfavorite == true) {
                                                      int key =
                                                          favoritemodelkey(
                                                              subFolderModel);
                                                      await deleteFavoritesFromHive(
                                                          key);
                                                    }
                                                    refreshFavKey.currentState
                                                        ?.show();
                                                  },
                                                ),
                                              )
                                            ],
                                          ));
                                    } else {
                                      return Text(
                                        'Image is not found',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(),
                                      );
                                    }
                                  } else if (subFolderModel.type == 'pdf') {
                                    return InkWell(
                                      onTap: () async {
                                        try {
                                          await OpenFile.open(
                                              subFolderModel.path);
                                        } catch (e) {}
                                      },
                                      child: Slidable(
                                        endActionPane: ActionPane(
                                          motion: const StretchMotion(),
                                          children: [
                                            const SizedBox(width: 5),
                                            SlidableAction(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                                  Colors.blue.shade300,
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
                                          ],
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: const Color(0Xff188F79),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
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
                                                    if (isfavorite == true) {
                                                      int key =
                                                          favoritemodelkey(
                                                              subFolderModel);
                                                      await deleteFavoritesFromHive(
                                                          key);
                                                    }
                                                    refreshFavKey.currentState
                                                        ?.show();
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (subFolderModel.type == 'folder') {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StudyMaterialScrn(
                                                      foldername:
                                                          subFolderModel.path,
                                                      email:
                                                          widget.user!.email),
                                            ));
                                      },
                                      child: Slidable(
                                        endActionPane: ActionPane(
                                          motion: const StretchMotion(),
                                          children: [
                                            const SizedBox(width: 5),
                                            SlidableAction(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                                  Colors.blue.shade300,
                                              label: 'Share',
                                              icon: Icons.share,
                                              spacing: 10,
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                              onPressed: (context) async {
                                                List<String> paths = [];
                                                FolderModel? existfolder;
                                                final allfolder =
                                                    await getFolderFromHive(
                                                        widget.user!.email);
                                                for (var folder in allfolder) {
                                                  if (folder.folderName ==
                                                      subFolderModel.path) {
                                                    existfolder = folder;
                                                    for (var subfolder
                                                        in existfolder
                                                            .folderModel) {
                                                      if (subfolder.name !=
                                                          'folder') {
                                                        paths.add(
                                                            subfolder.path);
                                                      }
                                                    }
                                                  }
                                                }
                                                shareFolderFn(paths, context);
                                              },
                                            ),
                                            const SizedBox(width: 5),
                                          ],
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: const Color(0Xff188F79),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          padding: const EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 40,
                                              bottom: 40),
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
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              Expanded(
                                                child: IconButton(
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
                                                    if (isfavorite == true) {
                                                      int key =
                                                          favoritemodelkey(
                                                              subFolderModel);
                                                      await deleteFavoritesFromHive(
                                                          key);
                                                    }
                                                    refreshFavKey.currentState
                                                        ?.show();
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 7),
                                itemCount: favlist.value.length)
                            : Center(
                                child: LottieBuilder.asset(
                                    'assets/animation/PUyQfE9kMM.json'),
                              );
                      }),
                  onRefresh: () async {
                    favlist.value =
                        await getFavoritesFromHive(widget.user!.email);
                    favlist.notifyListeners();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
