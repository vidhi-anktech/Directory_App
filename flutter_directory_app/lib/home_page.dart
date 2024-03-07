import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_directory_app/location_notifier.dart';
import 'package:flutter_directory_app/login_page.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/providers.dart';
import 'package:flutter_directory_app/show_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>  {
  int currentPage = 0;
  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    final stateLoc = ref.watch(locationNotifier.select((value) => value.state));
    print("VALUE DEKHTE HE $stateLoc");
    final cityLoc = ref.watch(locationNotifier.select((value) => value.city));
    print("VALUE DEKHTE HE CITY $cityLoc");
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(243, 242, 250, 1),
        body: IndexedStack(
          index: currentPage,
          children: [
            homeContent(),
          ],
        ),
      ),
    );
  }

  homeContent() {
    print(
        "VALUE OF COUNTRY, STATE, CITY $countryValue , $stateValue , $cityValue");
    final notifier = ref.read(locationNotifier.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 70),
                    Text(
                      "Telephone",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Text(
                      "Directory",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              
              
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 330,
                      height: 370,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/Ellipse.png"),
                            fit: BoxFit.fill),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 50,
                            child: SizedBox(
                                child: ClipOval(
                              child: Image.asset(
                                "assets/images/logo.jpeg",
                              ),
                            ))),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              backgroundColor: Colors.transparent,
                              foregroundColor: Theme.of(context).colorScheme.primary,
                              elevation: 0),
                          onPressed: () async {
                            var sharedPref = await SharedPreferences.getInstance();
                            var isLoggedIn =
                                sharedPref.getBool(MyAppState.KEYLOGIN);
                            if (isLoggedIn != null) {
                              if (isLoggedIn == true) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowData()));
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              }
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Get Started",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                 
                 ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
