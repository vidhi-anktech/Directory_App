import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/phone_number_notifier.dart';
import 'package:flutter_directory_app/verify_otp.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  bool _validateNumber = false;
  String svgString =
      '''<svg xmlns="http://www.w3.org/2000/svg" height="14" width="17.5" viewBox="0 0 640 512"><!--!Font Awesome Free 6.5.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path fill="#FFD43B" d="M351.2 4.8c3.2-2 6.6-3.3 10-4.1c4.7-1 9.6-.9 14.1 .1c7.7 1.8 14.8 6.5 19.4 13.6L514.6 194.2c8.8 13.1 13.4 28.6 13.4 44.4v73.5c0 6.9 4.4 13 10.9 15.2l79.2 26.4C631.2 358 640 370.2 640 384v96c0 9.9-4.6 19.3-12.5 25.4s-18.1 8.1-27.7 5.5L431 465.9c-56-14.9-95-65.7-95-123.7V224c0-17.7 14.3-32 32-32s32 14.3 32 32v80c0 8.8 7.2 16 16 16s16-7.2 16-16V219.1c0-7-1.8-13.8-5.3-19.8L340.3 48.1c-1.7-3-2.9-6.1-3.6-9.3c-1-4.7-1-9.6 .1-14.1c1.9-8 6.8-15.2 14.3-19.9zm-62.4 0c7.5 4.6 12.4 11.9 14.3 19.9c1.1 4.6 1.2 9.4 .1 14.1c-.7 3.2-1.9 6.3-3.6 9.3L213.3 199.3c-3.5 6-5.3 12.9-5.3 19.8V304c0 8.8 7.2 16 16 16s16-7.2 16-16V224c0-17.7 14.3-32 32-32s32 14.3 32 32V342.3c0 58-39 108.7-95 123.7l-168.7 45c-9.6 2.6-19.9 .5-27.7-5.5S0 490 0 480V384c0-13.8 8.8-26 21.9-30.4l79.2-26.4c6.5-2.2 10.9-8.3 10.9-15.2V238.5c0-15.8 4.7-31.2 13.4-44.4L245.2 14.5c4.6-7.1 11.7-11.8 19.4-13.6c4.6-1.1 9.4-1.2 14.1-.1c3.5 .8 6.9 2.1 10 4.1z"/></svg>''';
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void clearScreen() {
    _phoneController.clear();
  }

  String? _validatePhoneNumber(value) {
    // Phone number validation regex (customize as needed)
    final RegExp phoneRegex = RegExp(r'^\d{10}$');

    if (!phoneRegex.hasMatch(value)) {
      setState(() {
        _validateNumber = false;
      });
      return 'Enter a valid 10-digit phone number';
    } else {
      return null;
    }
    // return null;
  }

  void _sendOTP() async {
    String phone = "+91" + _phoneController.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) {},
      verificationFailed: (ex) {
        print(ex.code.toString());
      },
      codeSent: (verificationId, resendToken) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyOtpScreen(
                      verificationId: verificationId,
                      phoneNo: phone,
                    )));
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: Duration(seconds: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phoneNoProvider);
    print("LETS NACHO ${state.phoneNum}");

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
                  "Verify Your Mobile Number",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(
                        color: Theme.of(context).colorScheme.primary,
                        blurRadius: 7.0,
                        offset: Offset(-2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/images/logo.jpeg')),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter your Phone number",
                    errorText: _validateNumber
                        ? _validatePhoneNumber(_phoneController.text)
                        : null,
                    errorStyle: const TextStyle(
                      fontSize: 15,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    fillColor:
                        const Color.fromARGB(255, 87, 88, 92).withOpacity(0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.call),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async{
                     String phone = "+91" + _phoneController.text.trim();
                      var sharedPref = await SharedPreferences.getInstance();
                    final notifier = ref.read(phoneNoProvider.notifier);
                    notifier.setPhoneNo(phoneNo: phone);

                    final state = ref.read(phoneNoProvider);
                    final phone1 = state.phoneNum;

                    print("phone1111111: $phone1");
                    await sharedPref.setString(MyAppState.PHONENUM, state.phoneNum);
                    setState(() {
                      _validateNumber =
                          _validatePhoneNumber(_phoneController.text) != null;
                    });

                    if (!_validateNumber) {
                      setState(() {
                        _loading = true;
                      });
                      _sendOTP();
                      clearScreen();
                    }
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
                    "Send OTP",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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
