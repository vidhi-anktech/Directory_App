import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/register_details_page.dart';
import 'package:flutter_directory_app/verify_otp.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  bool _validateNumber = false;

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
      return 'Enter a valid 10-digit phone number';
    }

    return null;
  }

void _sendOTP() async{
 String phone = "+91" + _phoneController.text.trim();

 await FirebaseAuth.instance.verifyPhoneNumber(
  phoneNumber: phone,
  verificationCompleted: (credential){}, 
  verificationFailed: (ex){
    print(ex.code.toString());
  }, 
  codeSent: (verificationId, resendToken){
    Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOtpScreen(verificationId: verificationId,)));
  }, 
  codeAutoRetrievalTimeout: (verificationId){},
  timeout: Duration(seconds: 30),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
             
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "Verify Your Mobile Number",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Theme.of(context).colorScheme.primary,
                            blurRadius: 4.0,
                            offset: const Offset(-2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                
              const SizedBox(height: 50),
              TextFormField(
                controller: _phoneController,
                focusNode: _phoneFocusNode,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter your Phone number",
                  errorText: _validateNumber
                      ? "Enter a valid 10-digit phone number"
                      : null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor:
                      const Color.fromARGB(255, 87, 88, 92).withOpacity(0.1),
                  filled: true,
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: _validatePhoneNumber,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _validateNumber = !_phoneFocusNode.hasFocus &&
                        _validatePhoneNumber(_phoneController.text) != null;
                  });

                  if (!_validateNumber) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VerifyOtpScreen(verificationId: '',)),
                    );
                  }
                  _sendOTP();
                  clearScreen();
                },
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  backgroundColor: const Color.fromRGBO(5, 111, 146, 1),
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
              _registerNow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerNow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Not a Member?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationPage()),
            );
          },
          child: const Text(
            "REGISTER NOW !",
            style: TextStyle(
              color: Color.fromARGB(255, 53, 51, 51),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
