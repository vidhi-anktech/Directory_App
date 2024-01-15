import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _validateEmail = false;
  bool _validatePassword = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void clearScreen() {
    _emailController.clear();
    _passwordController.clear();
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
                  "Enter Your Credentials",
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
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Enter your Email",
                errorText: _validateEmail ? "Enter Valid email" : null,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                fillColor: const Color.fromARGB(255, 87, 88, 92).withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "Enter your Password",
                errorText: _validatePassword
                    ? "Password most conatin 1 Uppercase, 1 Lowercase, 1 Numeric and 1 Special characer"
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                fillColor: const Color.fromARGB(255, 87, 88, 92).withOpacity(0.1),
                filled: true,
                prefixIcon: const Icon(Icons.password),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                RegExp regex = RegExp(
                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
          
                setState(() {
                  _validateEmail = _emailController.text.isEmpty ||
                      !_emailController.text.contains("@");
                  _validatePassword = _passwordController.text.isEmpty ||
                      !regex.hasMatch(_passwordController.text);
                });
                if (_validateEmail || _validatePassword) {
                  print("Try again");
                } else {
                  Navigator.pushNamed(context, '/third');
                }
                clearScreen();
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                backgroundColor: const Color.fromARGB(255, 109, 158, 243),
                foregroundColor: Colors.white,
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
           const SizedBox(height:10),
            _registerNow(),
          ],
                ),
              ),
        ));
  }
   _registerNow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Not a Member?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/second');
            },
            child: const Text(
              "REGISTER NOW !",
              style: TextStyle(
                color: Color.fromARGB(255, 53, 51, 51),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ))
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// // import 'package:flutter_pw_validator/flutter_pw_validator.dart';

// class MySignUp extends StatefulWidget {
//   const MySignUp({super.key});

//   @override
//   State<MySignUp> createState() => _MySignUpState();
// }

// class _MySignUpState extends State<MySignUp> {
//   // final _key = GlobalKey<FormState>();

//   bool _validate = false;
//   bool _validateEmail = false;
//   bool _validatePassword = false;
//   bool _validateConfirmPass = false;
//   final _userNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPassController = TextEditingController();

//   @override
//   void dispose() {
//     _userNameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPassController.dispose();
//     super.dispose();
//   }

//   void clearScreen(){
//     _userNameController.clear();
//     _emailController.clear();
//     _passwordController.clear();
//     _confirmPassController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//             body: Container(
//                 margin: const EdgeInsets.all(20),
//                 child: SingleChildScrollView(
//                     child: Column(
//                   children: [
//                     const SizedBox(height: 30),
//                     _headerSignUp(),
//                     const SizedBox(height: 30),
//                     _inputSignUp(),
//                     const SizedBox(height: 20),
//                     const Center(
//                       child: Text(
//                         "Or",
//                         style: TextStyle(
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     _signInWithGoogle(),
//                     _backToLogin(),
//                   ],
//                 )))));
//   }

//   _headerSignUp() {
//     return Container(
//       child: Center(
//           child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 40),
//               child: const Column(children: [
//                 Text(
//                   "Sign Up",
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text("Create Your Account")
//               ]))),
//     );
//   }

//   _inputSignUp() {
//     return Center(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const SizedBox(height: 20),
//         TextField(
//           controller: _userNameController,
//           decoration: InputDecoration(
//             hintText: "UserName",
//             errorText: _validate ? "Value Can't Be Empty" : null,
//             border: OutlineInputBorder(
//               borderSide: BorderSide.none,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             fillColor: const Color.fromARGB(255, 87, 88, 92).withOpacity(0.1),
//             filled: true,
//             prefixIcon: const Icon(Icons.person),
//           ),
//         ),
//         const SizedBox(height: 10),
//         TextField(
//           controller: _emailController,
//           decoration: InputDecoration(
//             hintText: "Email",
//             errorText: _validateEmail ? "Enter Valid email" : null,
//             border: OutlineInputBorder(
//               borderSide: BorderSide.none,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             fillColor: const Color.fromARGB(255, 87, 88, 92).withOpacity(0.1),
//             filled: true,
//             prefixIcon: const Icon(Icons.email),
//           ),
//         ),
//         const SizedBox(height: 10),
//         TextField(
//           controller: _passwordController,
//           decoration: InputDecoration(
//             hintText: "Enter your Password",
//             errorText: _validatePassword
//                 ? "Password most conatin 1 Uppercase, 1 Lowercase, 1 Numeric and 1 Special characer"
//                 : null,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20),
//               borderSide: BorderSide.none,
//             ),
//             fillColor: const Color.fromARGB(255, 87, 88, 92).withOpacity(0.1),
//             filled: true,
//             prefixIcon: const Icon(Icons.password),
//           ),
//           obscureText: true,
//         ),
//         const SizedBox(height: 10),
//         TextField(
//           controller: _confirmPassController,
//           decoration: InputDecoration(
//             hintText: "Confirm your Password",
//             errorText:
//                 _validateConfirmPass ? "Either empty or not a match" : null,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20),
//               borderSide: BorderSide.none,
//             ),
//             fillColor: const Color.fromARGB(255, 87, 88, 92).withOpacity(0.1),
//             filled: true,
//             prefixIcon: const Icon(Icons.lock),
//           ),
//           obscureText: true,
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () {
            // RegExp regex = RegExp(
            //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

            // setState(() {
            //   _validate = _userNameController.text.isEmpty;
            //   _validateEmail = _emailController.text.isEmpty ||
            //       !_emailController.text.contains("@");
            //   _validatePassword = _passwordController.text.isEmpty ||
            //       !regex.hasMatch(_passwordController.text);
            //   _validateConfirmPass = _confirmPassController.text.isEmpty ||
            //       _confirmPassController.text != _passwordController.text;
            // });
            // if (_validate ||
            //     _validateEmail ||
            //     _validatePassword ||
            //     _validateConfirmPass) {
            //   print("Try again");
            // } else {
            //   Navigator.pushNamed(context, '/third');
            // }
            // clearScreen();
//           },
//           style: ElevatedButton.styleFrom(
//             shape: const StadiumBorder(),
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
//             backgroundColor: const Color.fromARGB(255, 51, 48, 51),
//             foregroundColor: Colors.white,
//           ),
//           child: const Text(
//             "Sign Up",
//             style: TextStyle(fontSize: 20),
//           ),
//         ),
//       ],
//     ));
//   }

//   _signInWithGoogle() {
//     return Container(
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             shape: const BeveledRectangleBorder(),
//             backgroundColor: Colors.white,
//           ),
//           onPressed: () {},
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Image.asset(
//                 'assets/images/Google_Logo.png',
//                 height: 30.0,
//               ),
//               TextButton(
//                 style: TextButton.styleFrom(
//                   padding: const EdgeInsets.all(16.0),
//                   textStyle: const TextStyle(fontSize: 20),
//                   shape: const BeveledRectangleBorder(),
//                   backgroundColor: const Color.fromARGB(255, 49, 113, 165),
//                 ),
//                 onPressed: () {},
//                 child: const Text(
//                   'Sign Up With Google',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }

//   _backToLogin() {
//   return Center(
//     child: Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       const Text("Already have an account?",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           )),
//       TextButton(
//           onPressed: () { Navigator.pop(context);},
//           child: const Text(
//             "LOG IN",
//             style: TextStyle(
//               color: Color.fromARGB(255, 53, 51, 51),
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ))
//     ],
//   )));
// }
// }

