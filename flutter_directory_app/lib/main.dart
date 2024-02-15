import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/firebase_options.dart';
import 'package:flutter_directory_app/home_page.dart';
import 'package:flutter_directory_app/login_page.dart';
import 'package:flutter_directory_app/phone_number_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {

  const MyApp({super.key });

  @override
  ConsumerState<MyApp> createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {
   static const String KEYLOGIN = 'login';
   static const String PHONENUM = '';
  @override
  Widget build(BuildContext context) {
     hello() async {
      var sharedPref = await SharedPreferences.getInstance();
      var checkNum = sharedPref.getString(MyAppState.PHONENUM);
      print("SHARED PREFERENCE CALLED AT BUILD CONTEXT OF MAIN.DART $checkNum");
    }

    hello();
    return MaterialApp(
      title: 'Directory App',
      initialRoute: '/',
      routes: {
        '/first': (context) =>  HomePage(),
        '/second': (context) => const LoginPage(),
        // '/third': (context) =>  ShowData(phoneNo: ,),
      },
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          prefixIconColor: Color.fromRGBO(119, 119, 119, 1),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            titleMedium: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            bodySmall: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
      home: HomePage(),
    );
  }
}
