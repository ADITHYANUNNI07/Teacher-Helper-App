import 'package:eduvista/Service/auth_service.dart';
import 'package:eduvista/model/usermodel.dart';
import 'package:eduvista/screen/login.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

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
      child: SingleChildScrollView(
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
            CircleAvatar(
              radius: size.width / 4,
              backgroundImage: const AssetImage('assets/images/signup.png'),
            ),
            const SizedBox(height: 10),
            Text(
              userDetails!.name,
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              userDetails!.email,
              style: GoogleFonts.poppins(
                fontSize: 15,
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
                  const AccountListTileWidget(
                      title: 'Message',
                      leadingIcon: Icons.message,
                      trailingIcon: LineAwesomeIcons.angle_right),
                  const AccountListTileWidget(
                      title: 'Change Password',
                      leadingIcon: Icons.fingerprint_outlined,
                      trailingIcon: LineAwesomeIcons.angle_right),
                  const AccountListTileWidget(
                      title: 'User feedback',
                      leadingIcon: Icons.feedback,
                      trailingIcon: LineAwesomeIcons.angle_right),
                  const AccountListTileWidget(
                    title: 'Share Application',
                    leadingIcon: Icons.share,
                  ),
                  const AccountListTileWidget(
                    title: 'Rate Us',
                    leadingIcon: Icons.star,
                  ),
                  const AccountListTileWidget(
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
                                    AuthService authService = AuthService();
                                    authService.signOut().whenComplete(
                                          () => Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            // the new route
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
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
      ),
    );
  }
}
