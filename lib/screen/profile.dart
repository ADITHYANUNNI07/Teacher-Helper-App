// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:eduvista/Service/auth_service.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/usermodel.dart';
import 'package:eduvista/screen/dashboard.dart';
import 'package:eduvista/screen/login.dart';
import 'package:eduvista/screen/settings/editprofile.dart';
import 'package:eduvista/screen/settings/feedback.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScrn extends StatelessWidget {
  const ProfileScrn({super.key, this.userDetails});
  final UserDetails? userDetails;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.only(
        top: 15,
      ),
      color: const Color(0Xff188F79).withOpacity(0.05),
      child: ValueListenableBuilder(
        valueListenable: userdetailsvlauenotifiermain,
        builder: (context, user, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                user?.profilepic != null
                    ? CircleAvatar(
                        radius: size.width / 3,
                        backgroundImage: FileImage(File(user!.profilepic!)),
                      )
                    : CircleAvatar(
                        radius: size.width / 3,
                        backgroundImage:
                            const AssetImage('assets/images/signup.png')),
                const SizedBox(height: 10),
                Text(
                  user!.name,
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  user.email,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(7),
                  width: size.width - 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          blurRadius: 2,
                          spreadRadius: 1)
                    ],
                  ),
                  child: Column(
                    children: [
                      AccountListTileWidget(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfileScrn(user: user),
                                ));
                          },
                          title: 'Edit Profile',
                          leadingIcon: LineAwesomeIcons.user_edit,
                          trailingIcon: LineAwesomeIcons.angle_right),
                      AccountListTileWidget(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FeedbackScrn(),
                              ),
                            );
                          },
                          title: 'User feedback',
                          leadingIcon: Icons.feedback,
                          trailingIcon: LineAwesomeIcons.angle_right),
                      AccountListTileWidget(
                        onTap: () {
                          launchAppStore();
                        },
                        title: 'Share Application',
                        leadingIcon: Icons.share,
                      ),
                      AccountListTileWidget(
                        onTap: () async {
                          Uri url = Uri.parse(
                              'https://sites.google.com/view/edu-vista-privacy-policy/home');
                          if (!await launchUrl(url)) {
                            throw Exception('could not lauch');
                          }
                        },
                        title: 'Privacy Policy',
                        leadingIcon: Icons.privacy_tip,
                      ),
                      AccountListTileWidget(
                        onTap: () {
                          deleteaccount(context, userDetails!);
                        },
                        title: 'Delete Account',
                        leadingIcon: Icons.delete,
                      ),
                      const Divider(),
                      AccountListTileWidget(
                          onTap: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Logout"),
                                  content: const Text(
                                      "Are you sure you want to logout?"),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0Xff188F79)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("cancel"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0Xff188F79)),
                                      onPressed: () async {
                                        AuthService authService = AuthService();
                                        authService.signOut().whenComplete(
                                              () => Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                // the new route
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          const LoginScrn(),
                                                ),

                                                (Route route) => false,
                                              ),
                                            );
                                      },
                                      child: const Text("Yes"),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          title: 'Logout',
                          leadingIcon: Icons.logout,
                          trailingIcon: LineAwesomeIcons.angle_right),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

void deleteaccount(BuildContext context, UserDetails user) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete"),
        content: const Text("Are you sure you want to Delete your Account ?"),
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
              await deleteUserData(user.email);
              AuthService authService = AuthService();
              authService.signOut().whenComplete(
                    () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const LoginScrn(),
                      ),
                      (Route route) => false,
                    ),
                  );
            },
            child: const Text("Yes"),
          )
        ],
      );
    },
  );
}

Future<void> launchAppStore() async {
  const String packageName = 'com.example.eduvista';
  String url = 'amzn://apps/android?p=$packageName';

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch Amazon Appstore');
  }
}
