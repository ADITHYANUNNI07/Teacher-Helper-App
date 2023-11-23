import 'package:eduvista/screen/login.dart';
import 'package:eduvista/screen/signup.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScrn extends StatefulWidget {
  const WelcomeScrn({super.key});

  @override
  State<WelcomeScrn> createState() => _WelcomeScrnState();
}

final liqController = LiquidController();

int currentPage = 0;

class _WelcomeScrnState extends State<WelcomeScrn> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: const Color(0Xff188F79),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Stack(
              children: [
                LiquidSwipe(
                  onPageChangeCallback: onPageChangedCallback,
                  liquidController: liqController,
                  pages: [
                    Container(
                      color: Colors.white,
                      width: size.width,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height / 8.9),
                          Image.asset(
                            'assets/images/welcome1.png',
                            height: size.height / 2.8,
                          ),
                          SizedBox(height: size.height / 8.9),
                          Column(
                            children: [
                              Text(
                                "Welcome to Edu Vista",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "Teacher's application",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "Welcome to a world of knowledge and possibilities.",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0XFF4b4b4b),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: size.width,
                      child: Column(
                        children: [
                          SizedBox(height: size.height / 8.9),
                          Image.asset(
                            'assets/images/welcome2.png',
                            height: size.height / 2.8,
                          ),
                          SizedBox(height: size.height / 8.9),
                          Column(
                            children: [
                              Text(
                                "\"Embrace the journey of learning.\"",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "\"Education is the foundation upon which we build our future.\"",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0XFF4b4b4b),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: size.width,
                      child: Column(
                        children: [
                          SizedBox(height: size.height / 8.9),
                          Image.asset(
                            'assets/images/welcome3.png',
                            height: size.height / 2.8,
                          ),
                          SizedBox(height: size.height / 8.9),
                          Column(
                            children: [
                              Text(
                                "\"Discover, Learn, Achieve.\"",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "\"Education is the most powerful weapon you can use to change the world.\" – Nelson Mandela",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0XFF4b4b4b),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                currentPage != 2
                    ? Positioned(
                        top: 40,
                        right: 10,
                        child: TextButton(
                          onPressed: () {
                            int nextPage = liqController.currentPage + 2;
                            liqController.animateToPage(page: nextPage);
                          },
                          child: Text(
                            'Skip',
                            style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 16, 16, 16),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                Positioned(
                  bottom: size.height / 6,
                  left: 0,
                  right: 0,
                  child: FractionallySizedBox(
                    widthFactor: 0.2,
                    child: AnimatedSmoothIndicator(
                      activeIndex: liqController.currentPage,
                      count: 3,
                      effect: const WormEffect(
                        dotColor: Color.fromARGB(255, 238, 230, 230),
                        activeDotColor: Color(0Xff188F79),
                        dotHeight: 5,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height / 1.3,
                  child: SizedBox(
                    width: size.width - 40,
                    height: 50,
                    child: ElevatedBtnWidget(
                      title: currentPage != 2 ? 'NEXT' : 'CREATE AN ACCOUNT',
                      onPressed: () {
                        if (currentPage != 2) {
                          int nextPage = liqController.currentPage + 1;
                          liqController.animateToPage(page: nextPage);
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScrn()));
                        }
                      },
                    ),
                  ),
                ),
                currentPage == 2
                    ? Positioned(
                        top: size.height / 1.18,
                        child: SizedBox(
                          width: size.width - 40,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScrn()));
                            },
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                  side: const BorderSide(
                                      color: Color(0XFF188F79)),
                                ),
                                foregroundColor: const Color(0XFF188F79)),
                            child: Text(
                              'LOGIN',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPageChangedCallback(int activePageIndex) {
    setState(() {
      currentPage = activePageIndex;
    });
    print(currentPage);
  }
}
