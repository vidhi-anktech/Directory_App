import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/data.dart';
import 'package:flutter_directory_app/home_page.dart';
import 'package:flutter_directory_app/login_page.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/phone_number_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends ConsumerStatefulWidget {
  const MyProfile({super.key});

  @override
  ConsumerState<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends ConsumerState<MyProfile> {
  final textController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          _profileView(),
        ],
        )
      ),
    );
  }

  void logout() async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(MyAppState.KEYLOGIN, false);
    final notifier = ref.read(phoneNoProvider.notifier);
    notifier.setPhoneNo(phoneNo: '');
    sharedPref.setString(MyAppState.PHONENUM, '');
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  Widget _profileView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 0.5,
                semanticContainer: true,
                child: Column(
                  children: [
                    ListTile(
                      leading: GestureDetector(
                        child: Image.asset('assets/images/support.png'),
                      ),
                      title: const Text(
                        "Customer Support",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 20,
                          )),
                    ),
                    const Divider(
                      color: Color.fromRGBO(222, 220, 220, 1),
                      thickness: 0.5,
                    ),
                    ListTile(
                      leading: GestureDetector(
                        child: Image.asset('assets/images/account.png'),
                      ),
                      title: const Text(
                        "Account",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 20,
                          )),
                    ),
                    const Divider(
                      color: Color.fromRGBO(222, 220, 220, 1),
                      thickness: 0.5,
                    ),
                    ListTile(
                      leading: GestureDetector(
                        child: Image.asset('assets/images/support.png'),
                      ),
                      title: const Text(
                        "Sponsors",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 20,
                          )),
                    ),
                    const Divider(
                      color: Color.fromRGBO(222, 220, 220, 1),
                      thickness: 0.5,
                    ),
                    const SizedBox(height: 80)
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          logout();
                        },
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0),
                        child: const Text(
                          "Log out",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
