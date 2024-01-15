import 'package:flutter/material.dart';
import 'package:flutter_directory_app/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Directory App',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          prefixIconColor: Color.fromRGBO(119, 119, 119, 1),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            titleMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            bodySmall: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(254, 206, 1, 1),
          primary: const Color.fromRGBO(254, 206, 1, 1),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
