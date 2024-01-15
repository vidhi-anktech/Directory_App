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

