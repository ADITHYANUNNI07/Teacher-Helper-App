// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:eduvista/Helper/helper_function.dart';
import 'package:eduvista/Service/auth_service.dart';
import 'package:eduvista/db/hive.dart';
import 'package:eduvista/model/usermodel.dart';
import 'package:eduvista/screen/dashboard.dart';
import 'package:eduvista/screen/welcome.dart';
import 'package:eduvista/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SignupScrn extends StatefulWidget {
  const SignupScrn({super.key});

  @override
  State<SignupScrn> createState() => _SignupScrnState();
}

final nameController = TextEditingController();
final emailController = TextEditingController();
final phoneController = TextEditingController();
final passController = TextEditingController();
bool passbool = true;
final fromKey = GlobalKey<FormState>();
bool _isLoding = false;

class _SignupScrnState extends State<SignupScrn> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return _isLoding
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
        : Container(
            color: const Color(0Xff188F79),
            child: SafeArea(
                child: GestureDetector(
              onTap: () {
                FocusNode currentfocus = FocusScope.of(context);
                if (!currentfocus.hasPrimaryFocus) {
                  currentfocus.unfocus();
                }
              },
              child: Scaffold(
                backgroundColor: Colors.white,
                body: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
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
                                          'Create your account',
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
                            const EdgeInsets.only(left: 15, right: 10, top: 20),
                        child: Form(
                          key: fromKey,
                          child: Column(
                            children: [
                              TextFormWidget(
                                label: 'Name',
                                icon: Icons.person_outline,
                                controller: nameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Your Name";
                                  } else {
                                    return RegExp(
                                                r'[!@#<>?:_`"~;[\]\\|=+)(*&^%0-9-]')
                                            .hasMatch(value)
                                        ? "Please enter valid name"
                                        : null;
                                  }
                                },
                              ),
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
                              const SizedBox(height: 15),
                              TextFormWidget(
                                  icon: Icons.phone_outlined,
                                  label: 'Phone No',
                                  controller: phoneController,
                                  validator: (val) {
                                    return RegExp(r"(^(?:[+0]9)?[0-9]{10,12}$)")
                                            .hasMatch(val!)
                                        ? null
                                        : "Please enter valid mobile number";
                                  }),
                              const SizedBox(height: 15),
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
                              const SizedBox(height: 15),
                              SizedBox(
                                width: size.width,
                                height: 50,
                                child: ElevatedBtnWidget(
                                    onPressed: () {
                                      submit();
                                    },
                                    title: 'CREATE AN ACCOUNT'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 21),
                    ],
                  ),
                ),
              ),
            )));
  }

  void controllerClean() {
    nameController.clear();
    emailController.clear();
    passController.clear();
    phoneController.clear();
  }

  void submit() async {
    if (fromKey.currentState!.validate()) {
      setState(() {
        _isLoding = true;
      });
      final user = UserDetails(
          name: nameController.text,
          email: emailController.text,
          password: passController.text,
          phonenumber: phoneController.text);
      await addUserDetails(user);
      AuthService authService = AuthService();
      bool value = await authService.createUserAccount(user);

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
        newshowSnackbar(context, 'Signup Warning',
            'Your account already created please sign in', ContentType.failure);
        controllerClean();
        setState(() {
          _isLoding = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _isLoding = false;
    super.dispose();
  }
}
