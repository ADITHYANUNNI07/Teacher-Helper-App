// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eduvista/Helper/helper_function.dart';
import 'package:eduvista/Service/auth_service.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/usermodel.dart';
import 'package:eduvista/screen/dashboard.dart';
import 'package:eduvista/screen/signup.dart';
import 'package:eduvista/screen/welcome.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginScrn extends StatefulWidget {
  const LoginScrn({super.key});

  @override
  State<LoginScrn> createState() => _LoginScrnState();
}

final emailController = TextEditingController();
final passController = TextEditingController();
bool passbool = true;
final fromKey = GlobalKey<FormState>();
bool _isLoding = false;

class _LoginScrnState extends State<LoginScrn> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        color: const Color(0Xff188F79),
        child: _isLoding
            ? Container(
                height: 300, // set the height of the container to 300
                width: 300, // set the width of the container to 300
                color: Colors.white,
                child: FractionallySizedBox(
                  widthFactor:
                      0.4, // set the width factor to 0.8 to take 80% of the container's width
                  heightFactor:
                      0.4, // set the height factor to 0.8 to take 80% of the container's height
                  child: Lottie.asset(
                    'assets/animation/animation_lo4efsbq.json',
                  ),
                ),
              )
            : SafeArea(
                child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.asset('assets/images/signup.png',
                              width: size.width, fit: BoxFit.fill),
                          Positioned(
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const WelcomeScrn(),
                                    ));
                              },
                              icon: const Icon(Icons.arrow_back,
                                  color: Color(0Xff188F79), size: 45),
                            ),
                          ),
                          Positioned(
                            top: size.height / 2.8,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              width: size.width,
                              height: size.height / 4,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Login ',
                                          style: GoogleFonts.poppins(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon:
                                            const Icon(Icons.cancel, size: 26),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 10, top: 30),
                        child: Form(
                          key: fromKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              TextFormWidget(
                                label: 'Email',
                                icon: Icons.email_outlined,
                                controller: emailController,
                                validator: (val) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val!)
                                      ? null
                                      : "Please enter a valid email";
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormWidget(
                                obscurebool: passbool,
                                suffixicon: passbool
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                suffixOnpress: () {
                                  setState(() {
                                    passbool = !passbool;
                                  });
                                },
                                icon: Icons.fingerprint_outlined,
                                label: 'Password',
                                controller: passController,
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return "Password must be at least 6 characters";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: size.width,
                                height: 50,
                                child: ElevatedBtnWidget(
                                    onPressed: () {
                                      submit();
                                    },
                                    title: 'CREATE AN ACCOUNT'),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupScrn(),
                                      ));
                                },
                                child: Text.rich(
                                  TextSpan(
                                    text: "Don't have an Account? ",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                    children: [
                                      TextSpan(
                                        text: 'Signup',
                                        style: GoogleFonts.poppins(
                                            color: Colors.blue),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )));
  }

  void controllerClean() {
    emailController.clear();
    passController.clear();
  }

  void submit() async {
    if (fromKey.currentState!.validate()) {
      AuthService authService = AuthService();
      dynamic value = await authService.loginUserAccount(
          emailController.text, passController.text);
      if (value == true) {
        await HelperFunction.saveUserLoggedInStatus(true);
        await HelperFunction.saveUserNameSF(emailController.text);
        UserDetails? user = await getUserDetailsByEmail(emailController.text);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashBoardScrn(userDetails: user),
          ),
        );
        controllerClean();
      } else {
        newshowSnackbar(context, 'Login Failure',
            'Email and password is incorrect', ContentType.failure);
        controllerClean();
        setState(() {
          _isLoding = false;
        });
      }
    }
  }
}
