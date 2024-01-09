import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/usermodel.dart';
import 'package:eduvista/screen/favorites.dart';
import 'package:eduvista/screen/home.dart';
import 'package:eduvista/screen/notification.dart';
import 'package:eduvista/screen/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashBoardScrn extends StatefulWidget {
  const DashBoardScrn({super.key, this.user, this.userDetails});
  final User? user;
  final UserDetails? userDetails;
  @override
  State<DashBoardScrn> createState() => _DashBoardScrnState();
}

class _DashBoardScrnState extends State<DashBoardScrn> {
  int currentIndex = 0;

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();

    pages = [
      HomeScrn(userDetails: widget.userDetails),
      FavoritesScrn(user: widget.userDetails),
      ProfileScrn(userDetails: widget.userDetails),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0Xff188F79),
      child: SafeArea(
        child: Scaffold(
          body: pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            selectedLabelStyle:
                GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
            unselectedLabelStyle:
                GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
            fixedColor: const Color(0Xff188F79),
            unselectedItemColor: Colors.grey,
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

ValueNotifier<UserDetails?> userdetailsvlauenotifiermain = ValueNotifier(
    UserDetails(name: '', email: '', password: '', phonenumber: ''));
Future<void> getUserdetails(String email) async {
  userdetailsvlauenotifiermain.value = await getUserDetailsByEmail(email);
  print(userdetailsvlauenotifiermain.value!.name);
  userdetailsvlauenotifiermain.notifyListeners();
}
