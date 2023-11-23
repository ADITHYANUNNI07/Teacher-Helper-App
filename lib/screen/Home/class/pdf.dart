import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PDF extends StatelessWidget {
  const PDF({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Mouthly Attendance',
          style: GoogleFonts.poppins(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
