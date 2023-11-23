import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ParentToMessageScrn extends StatefulWidget {
  const ParentToMessageScrn({super.key});

  @override
  State<ParentToMessageScrn> createState() => _ParentToMessageScrnState();
}

class _ParentToMessageScrnState extends State<ParentToMessageScrn> {
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
              'Message Send to Parent',
              style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
