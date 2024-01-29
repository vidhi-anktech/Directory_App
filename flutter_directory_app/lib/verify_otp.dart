
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/home_page.dart';
import 'package:flutter_directory_app/register_details_page.dart';


class VerifyOtpScreen extends StatefulWidget {
  final String verificationId;
  const VerifyOtpScreen({ Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {

  TextEditingController otpController = TextEditingController();

 void verifyOTP() async{
  String otp = otpController.text.trim();

  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: otp);

  try{
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    if(userCredential.user != null){
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }on FirebaseAuthException catch(ex){
    print(ex.code.toString());
  }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Please Enter OTP",
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
                ],
              ),
              const SizedBox(height: 50),
              TextField(
                controller: otpController,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: "Enter your 6 digit OTP",
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor:
                      const Color.fromARGB(255, 87, 88, 92).withOpacity(0.1),
                  filled: true,
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                 verifyOTP();
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