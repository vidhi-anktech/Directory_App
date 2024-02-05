import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/register_details_page.dart';
import 'package:flutter_directory_app/show_data.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final adminEmailController = TextEditingController();
  final adminPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                   const SizedBox(height: 30),
             
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "Enter Admin Credentials",
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
                  TextField(
                    controller: adminEmailController,
                    decoration: InputDecoration(
                      hintText: "Enter Email Address",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: const Color.fromARGB(255, 87, 88, 92)
                          .withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: adminPasswordController,
                    decoration: InputDecoration(
                      hintText: "Enter Your Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      fillColor: const Color.fromARGB(255, 87, 88, 92)
                          .withOpacity(0.1),
                      filled: true,
                      prefixIcon: const Icon(Icons.password),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      adminLogin();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      backgroundColor: const Color.fromRGBO(5, 111, 146, 1),
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
                  const SizedBox(
                    height: 10,
                  ),
                  _registerNow(),
                ],
              ),
            ),
          ],
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

  void adminLogin() async {
    final adminEmail = adminEmailController.text.trim();
    final adminPass = adminPasswordController.text.trim();

    if (adminEmail != "" && adminPass != "") {
      await FirebaseFirestore.instance
          .collection("admin")
          .doc("admin-credential")
          .snapshots()
          .forEach((element) {
        if (element.data()?['adminEmail'] == adminEmail &&
            element.data()?['adminPassword'] == adminPass) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ShowData()));
        }
      });
    }
  }
}
