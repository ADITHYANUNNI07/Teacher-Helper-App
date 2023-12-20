import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FeedbackScrn extends StatefulWidget {
  const FeedbackScrn({super.key});

  @override
  State<FeedbackScrn> createState() => _FeedbackScrnState();
}

final formKey = GlobalKey<FormState>();
int feedbackRating = 0;
String suggestion = '';

class _FeedbackScrnState extends State<FeedbackScrn> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF04FBC3),
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Give feedback',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                        width: 40,
                        height: 40,
                        child: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/signup.png'))),
                  ],
                ),
              ),
              Image.asset(
                'assets/images/Feedback-bro.png',
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(5, 10),
                          blurRadius: 28,
                          color: Colors.black87,
                        )
                      ]),
                  padding: const EdgeInsets.only(
                      top: 9, left: 5, right: 5, bottom: 9),
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        'Tell us what can improved ?',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 5),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              maxLines: 9,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(LineAwesomeIcons.accusoft),
                                labelText: 'Suggestion',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                suggestion = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Suggestion';
                                } else if (value.length <= 6) {
                                  return 'invalid your Suggestion';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide.none,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 13),
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0Xff188F79)),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      sendEmail('unniadithyan81@gmail.com',
                                          'FEEDBACK', suggestion);
                                    }
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.send_outlined),
                                      SizedBox(width: 9),
                                      Text('SEND FEEDBACK'),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

Future<void> sendEmail(
    String emailRecipients, String subject, String body) async {
  String emailUrl = 'mailto:$emailRecipients?subject=$subject&body=$body';

  if (await canLaunchUrlString(emailUrl)) {
    await launchUrlString(emailUrl);
  } else {}
}
