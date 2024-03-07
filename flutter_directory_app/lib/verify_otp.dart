import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/login_page.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/show_data.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String phoneNo;
  const VerifyOtpScreen(
      {Key? key, required this.verificationId, required this.phoneNo})
      : super(key: key);

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen>
    with CodeAutoFill {
  TextEditingController otpController = TextEditingController();
  String _verificationId = "";
  int? _resendToken = 0;
  String codeValue = "";
  bool _loading = false;
  Timer? _timer;
  int _countDown = 30;
  bool canResend = false;

  @override
  void codeUpdated() {
    setState(() {
      codeValue = code!;
    });
  }

  @override
  void initState() {
    super.initState();
    listenOtp();
    startTimer();
  }

  void listenOtp() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDown > 0) {
          _countDown--;
        } else {
          canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void verifyOTP() async {
    String otp = codeValue;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setBool(MyAppState.KEYLOGIN, true);
        sharedPref.setString(MyAppState.PHONENUM, widget.phoneNo);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShowData()));
      }
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }
  }

 void resendOTP(String phone) async {
  try {
    print("RESEND OTP FUNCTION CALLED");
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) {},
      verificationFailed: (ex) {
        print(ex.code.toString());
      },
      codeSent: (verificationId, resendToken) {
        setState(() {
          _verificationId = verificationId; 
          _resendToken = resendToken;
        });
        print("Resending OTP: $verificationId");
      },
       timeout: const Duration(seconds: 30),
       forceResendingToken: _resendToken,
      codeAutoRetrievalTimeout: (verificationId) {
        setState(() {
          _verificationId = verificationId; // Corrected this line
        });
        print("Auto Retrieval Timeout: $verificationId");
      },
     
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("OTP Resent Successfully"),
      ),
    );
  //  startTimer();
  } catch (e) {
    print(e.toString());
  }
}


  @override
  Widget build(BuildContext context) {
    check() async {
      var sharedPref = await SharedPreferences.getInstance();
      var test = sharedPref.getString(MyAppState.PHONENUM);
      print("VALUE OF SHARED PREFERENCE PHONE NUMBER AT Verify otp IS $test");
    }

    check();
      print("VALUE OF constructor PHONE NUMBER AT Verify otp IS ${widget.phoneNo}");
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color.fromRGBO(5, 111, 146, 1),
          rightDotColor: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "Verify with OTP",
                    style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "Sent via SMS to ${widget.phoneNo}",
                    style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color.fromRGBO(122, 122, 122, 1),
                    )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              PinFieldAutoFill(
                decoration: UnderlineDecoration(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  colorBuilder: const FixedColorBuilder(Colors.transparent),
                  bgColorBuilder:
                      FixedColorBuilder(Colors.grey.withOpacity(0.2)),
                ),
                currentCode: codeValue,
                codeLength: 6,
                onCodeChanged: (code) {
                  setState(() {
                    codeValue = code.toString();
                  });
                },
                onCodeSubmitted: (val) {
                  setState(() {
                    _loading = true;
                  });
                  verifyOTP();
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Row(
                    children: [
                      canResend
                          ? InkWell(
                              onTap: () async {
                                print("RESENDING OTP ON PHONE NUMBER : ${widget.phoneNo}");
                                resendOTP(widget.phoneNo);
                              },
                              child: Text("Resend",
                                  style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ))),
                            )
                          : Text(
                              "Resend",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Color.fromRGBO(122, 122, 122, 1),
                                ),
                              ),
                            )
                    ],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "OTP in",
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color.fromRGBO(122, 122, 122, 1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "00:${_countDown.toString()}",
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color.fromRGBO(122, 122, 122, 1),
                      ),
                    ),
                  ),
                ],
              ),
             
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
