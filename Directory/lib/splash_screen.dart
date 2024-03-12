import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_directory_app/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
   @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage())));
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(child: CircleAvatar(
          radius: 50,
          child: Image.asset('assets/images/logo.jpeg'))),
      ),
    );
  }
}