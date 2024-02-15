import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/show_data.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String phoneNo;
  const VerifyOtpScreen({
    Key? key,
    required this.verificationId,
    required this.phoneNo
  }) : super(key: key);

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen>
    with CodeAutoFill {
  TextEditingController otpController = TextEditingController();
  String _verificationId = "";
  int? _resendToken;
  String codeValue = "";
  bool _loading = false;
  String svgString =
      '''<svg xmlns="http://www.w3.org/2000/svg" height="14" width="17.5" viewBox="0 0 640 512"><!--!Font Awesome Free 6.5.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path fill="#FFD43B" d="M351.2 4.8c3.2-2 6.6-3.3 10-4.1c4.7-1 9.6-.9 14.1 .1c7.7 1.8 14.8 6.5 19.4 13.6L514.6 194.2c8.8 13.1 13.4 28.6 13.4 44.4v73.5c0 6.9 4.4 13 10.9 15.2l79.2 26.4C631.2 358 640 370.2 640 384v96c0 9.9-4.6 19.3-12.5 25.4s-18.1 8.1-27.7 5.5L431 465.9c-56-14.9-95-65.7-95-123.7V224c0-17.7 14.3-32 32-32s32 14.3 32 32v80c0 8.8 7.2 16 16 16s16-7.2 16-16V219.1c0-7-1.8-13.8-5.3-19.8L340.3 48.1c-1.7-3-2.9-6.1-3.6-9.3c-1-4.7-1-9.6 .1-14.1c1.9-8 6.8-15.2 14.3-19.9zm-62.4 0c7.5 4.6 12.4 11.9 14.3 19.9c1.1 4.6 1.2 9.4 .1 14.1c-.7 3.2-1.9 6.3-3.6 9.3L213.3 199.3c-3.5 6-5.3 12.9-5.3 19.8V304c0 8.8 7.2 16 16 16s16-7.2 16-16V224c0-17.7 14.3-32 32-32s32 14.3 32 32V342.3c0 58-39 108.7-95 123.7l-168.7 45c-9.6 2.6-19.9 .5-27.7-5.5S0 490 0 480V384c0-13.8 8.8-26 21.9-30.4l79.2-26.4c6.5-2.2 10.9-8.3 10.9-15.2V238.5c0-15.8 4.7-31.2 13.4-44.4L245.2 14.5c4.6-7.1 11.7-11.8 19.4-13.6c4.6-1.1 9.4-1.2 14.1-.1c3.5 .8 6.9 2.1 10 4.1z"/></svg>''';

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
  }

  void listenOtp() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  void verifyOTP() async {
    String otp = codeValue;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        print('GREAT SUCCESS!');
        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setBool(MyAppState.KEYLOGIN, true);
        sharedPref.setString(MyAppState.PHONENUM, widget.phoneNo);
        var checkNum = sharedPref.getString(MyAppState.PHONENUM);
        print("CHECKING NUMBER AT VERIFY OTP $checkNum");

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShowData()));
      }
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }
  }

  void resendOTP(String phone) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (credential) {},
        verificationFailed: (ex) {
          print(ex.code.toString());
        },
        codeSent: (verificationId, resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;

          print("Resending OTP: $verificationId");
        },
        codeAutoRetrievalTimeout: (verificationId) {
          verificationId = _verificationId;
        },
        timeout: const Duration(seconds: 30),
      );
      print("_verificationId: $_verificationId");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP Resent Successfully"),
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        height: 50,
        color: Colors.transparent,
        elevation: 0,
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "अहिंसा परमो धर्मः",
                style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              SvgPicture.string(
                svgString,
                width: 15,
                height: 15,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(5, 111, 146, 1).withOpacity(0.8),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        titleSpacing: 0,
        title: const FittedBox(
          fit: BoxFit.contain,
          child: Text(
            "Palliwal Jain Association",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color.fromRGBO(5, 111, 146, 1),
          rightDotColor: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Please Enter Your OTP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(
                        color: Theme.of(context).colorScheme.primary,
                        blurRadius: 7.0,
                        offset: const Offset(-2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/images/logo.jpeg'),
                ),
                const SizedBox(height: 30),
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
                    print("onCodeSubmitted $val");
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _loading = true;
                    });
                    verifyOTP();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    backgroundColor:
                        const Color.fromRGBO(5, 111, 146, 1).withOpacity(0.8),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "Verify",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    var sharedPref = await SharedPreferences.getInstance();
                    var checkNum = sharedPref.getString(MyAppState.PHONENUM);
                    resendOTP(checkNum!);
                  },
                  child: const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          indent: 20.0,
                          endIndent: 10.0,
                          thickness: 1,
                        ),
                      ),
                      Text(
                        "Resend OTP",
                        style: TextStyle(
                            color: Color.fromRGBO(5, 111, 146, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Expanded(
                        child: Divider(
                          indent: 10.0,
                          endIndent: 20.0,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
