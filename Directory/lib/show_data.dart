import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/home_page.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/phone_number_notifier.dart';
import 'package:flutter_directory_app/profile.dart';
import 'package:flutter_directory_app/register_details_page.dart';
import 'package:flutter_directory_app/sponsors.dart';
import 'package:flutter_directory_app/user-details-page.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowData extends ConsumerStatefulWidget {
  const ShowData({
    super.key,
  });

  @override
  ConsumerState<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends ConsumerState<ShowData> {
  List _allResults = [];
  List resultList = [];
  late Stream<dynamic> dataStream;
  var checkNum;
  bool searchClick = false;
  var searchCityController = TextEditingController();
  var selectedCity;
  bool _toggle = true;
  // var checkNumber;

  void _doToggle() => setState(() => _toggle = !_toggle);

  int _currentIndex = 0;
  _onTap(int index) {
    if (index < _children.length) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => _children[index]));
    }
  }

  final List<Widget> _children = [
    ShowData(),
    RegistrationPage(),
    Sponsors(),
    MyProfile(),
  ];

  Future check() async {
    var sharedPref = await SharedPreferences.getInstance();
    checkNum = sharedPref.getString(MyAppState.PHONENUM);
    checkNum = await checkNum;
    print("VALUE OF CHECK NUM IN CHECK() $checkNum");
    return checkNum;
  }

  checkLoggedIn() async {
    var sharedPref = await SharedPreferences.getInstance();
    var loggedIn = sharedPref.getBool(MyAppState.KEYLOGIN);
    print(" VALUE OF IS LOGGED IN in build context: $loggedIn");
    return loggedIn;
  }

  final TextEditingController searchController = TextEditingController();
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    dataStream = FirebaseFirestore.instance
        .collection("directory-users")
        .snapshots()
        .asBroadcastStream();
    searchController.addListener(onSearchChanged);
    _controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        checkNum = await check();

        setState(() {});
      },
    );
  }

  onSearchChanged() {
    searchResultList(_allResults);
  }

  searchResultList(List<dynamic> allResults) {
    var showResults = [];

    if (searchController.text != "") {
      for (var clientSnapShot in allResults) {
        var hName = clientSnapShot['hName'].toString().toLowerCase();
        var wName = clientSnapShot['wName'].toString().toLowerCase();
        var hCurrentAddress =
            clientSnapShot['hCurrentAddress'].toString().toLowerCase();
        var wCurrentAddress =
            clientSnapShot['wCurrentAddress'].toString().toLowerCase();
        var hOccupation =
            clientSnapShot['hOccupation'].toString().toLowerCase();
        var wOccupation =
            clientSnapShot['wOccupation'].toString().toLowerCase();
        var hGotra = clientSnapShot['hGotra'].toString().toLowerCase();
        var wGotra = clientSnapShot['wGotra'].toString().toLowerCase();
        var hContact = clientSnapShot['hContact'].toString();
        var wContact = clientSnapShot['wContact'].toString();

        if (hName.contains(searchController.text.toLowerCase()) ||
            wName.contains(searchController.text.toLowerCase()) ||
            hCurrentAddress.contains(searchController.text.toLowerCase()) ||
            wCurrentAddress.contains(searchController.text.toLowerCase()) ||
            hOccupation.contains(searchController.text.toLowerCase()) ||
            wOccupation.contains(searchController.text.toLowerCase()) ||
            hGotra.contains(searchController.text.toLowerCase()) ||
            wGotra.contains(searchController.text.toLowerCase()) ||
            wContact.contains(searchController.text) ||
            hContact.contains(searchController.text)) {
          showResults.add(clientSnapShot);
        }
      }
    }
    setState(() {
      resultList = showResults;
    });
  }

  getClientStream() async {
    searchResultList(_allResults);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  String maskLastThreeDigits(String phoneNumber) {
    if (phoneNumber.length == 13) {
      String maskedNumber = '***-***-${phoneNumber.substring(10)}';
      return maskedNumber;
    } else {
      print("GRAND FAILURE");
      return phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    check();
    checkLoggedIn();

    print("VALUE OF CHECK NUMBER INSIDE BUILD $checkNum");
    print("value of checkNum $checkNum");
    print("VALUE OF SEARCH CITY CONTROLLER TEXT ${searchCityController.text}");

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
        // floatingActionButton: FloatingActionButton(
        //   shape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        //   backgroundColor: Theme.of(context).colorScheme.primary,
        //   onPressed: () async {
        //     var sharedPref = await SharedPreferences.getInstance();
        //     var isLoggedIn = sharedPref.getBool(MyAppState.KEYLOGIN);
        //     print(" VALUE OF IS LOGGED IN : $isLoggedIn");
        //     if (isLoggedIn != null) {
        //       if (isLoggedIn == true) {
        //         Navigator.pushNamed(context, '/fourth');
        //       } else {
        //         Navigator.pushNamed(context, '/second');
        //       }
        //     } else {
        //       Navigator.pushNamed(context, '/second');
        //     }
        //   },
        //   child: const Icon(
        //     Icons.add,
        //     color: Colors.white,
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(255, 64, 121, 1),
          ),
          unselectedLabelStyle: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 10,
              fontWeight: FontWeight.w400),
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/home.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/add.png')),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/sponsors_icon.png')),
              label: 'Sponsors',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/images/more.png')),
              label: 'About',
            )
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _onTap(index);
          },
        ),
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<dynamic>(
                stream: dataStream,
                builder: (context, snapshot) {
                  return TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromRGBO(246, 246, 246, 1),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          hintText: "Search",
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(225, 225, 225, 1),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(225, 225, 225, 1),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          prefixIcon: Image.asset('assets/images/search.png'),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 35,
                            minHeight: 30,
                          ),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                searchController.clear();
                              },
                              child: Image.asset('assets/images/cross.png'))),
                      onChanged: (searchController) {
                        _allResults = snapshot.data!.docs;
                        searchResultList(_allResults);
                      });
                }),
          ),
        ),

        drawer: FutureBuilder(
            future: check(),
            builder: (context, snapshot) {
              print("VALUE OF CHECK NUMBE INSIDE DRAWER $checkNum");
              if (snapshot.hasData) {
                return Drawer(
                  child: ListView(
                    children: [
                      DrawerHeader(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(217, 217, 217, 1)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Jai-Jinendra!",
                              style: TextStyle(
                                // color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (checkNum == null || checkNum.isEmpty) ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Have you not logged in yet?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/second');
                                    },
                                    child: const Text(
                                      "Log in now.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ] else
                              Text(
                                "$checkNum",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              )
                          ],
                        ),
                      ),
                      checkNum == null || checkNum.isEmpty
                          ? ListTile(
                              title: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/second');
                              },
                            )
                          : ListTile(
                              title: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () async {
                                var sharedPref =
                                    await SharedPreferences.getInstance();
                                sharedPref.setBool(MyAppState.KEYLOGIN, false);
                                final notifier =
                                    ref.read(phoneNoProvider.notifier);
                                notifier.setPhoneNo(phoneNo: '');
                                sharedPref.setString(MyAppState.PHONENUM, '');
                                await FirebaseAuth.instance.signOut();
                                // ignore: use_build_context_synchronously
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              },
                            ),
                      const Divider(
                        thickness: 0.5,
                      ),
                      ListTile(
                        title: const Text(
                          "Add yourself",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () async {
                          var sharedPref =
                              await SharedPreferences.getInstance();
                          var isLoggedIn =
                              sharedPref.getBool(MyAppState.KEYLOGIN);
                          print(
                              " VALUE OF IS LOGGED IN in userdetails: $isLoggedIn");
                          if (isLoggedIn != null) {
                            if (isLoggedIn == true) {
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationPage()));
                            } else {
                              Navigator.pushNamed(context, '/second');
                            }
                          } else {
                            Navigator.pushNamed(context, '/second');
                          }
                        },
                      )
                    ],
                  ),
                );
              }
              return Container(child: CircularProgressIndicator());
            }),

        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              // citySearchBar(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Image.asset('assets/images/location.png'),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: searchCityController,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText: "Enter your City",
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(0,0,0,1)
                              )
                              ),
                          onChanged: (val) {
                            setState(() {
                              selectedCity = searchCityController.text
                                  .trim()
                                  .capitalizeFirst;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: selectedCity != null && selectedCity.isNotEmpty
                      ? FirebaseFirestore.instance
                          .collection("directory-users")
                          .where("hCity", isEqualTo: selectedCity)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection("directory-users")
                          .snapshots(),
                  builder: (context, snapshot) {
                    print(
                        "VALUE OF SELECT CITY CONTROLLER INSIDE BUILDER $selectedCity");
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData && snapshot.data != null) {
                        if (searchController.text.isEmpty) {
                          _allResults = snapshot.data!.docs;
                          print("value of checkNum in streambuilder $checkNum");
                          return ListView.builder(
                            controller: _controller,
                            itemCount: _allResults.length,
                            itemBuilder: (context, index) {
                              var docId = _allResults[index].id;

                              String hPhoneNumber =
                                  _allResults[index]['hContact'];
                              String maskedHPhoneNum =
                                  maskLastThreeDigits(hPhoneNumber);
                              String wPhoneNumber;
                              String? maskedWPhoneNum;
                              if (_allResults[index]['wContact'] != null) {
                                wPhoneNumber = _allResults[index]['wContact'];
                                maskedWPhoneNum =
                                    maskLastThreeDigits(wPhoneNumber);
                              }

                              return GestureDetector(
                                onTap: () async {
                                  var sharedPref =
                                      await SharedPreferences.getInstance();
                                  var isLoggedIn =
                                      sharedPref.getBool(MyAppState.KEYLOGIN);
                                  print(
                                      " VALUE OF IS LOGGED IN in userdetails: $isLoggedIn");
                                  if (isLoggedIn != null) {
                                    if (isLoggedIn == true) {
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserDetailsPage(
                                            userData: _allResults[index].data()
                                                as Map<String, dynamic>,
                                            userId: docId,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.pushNamed(context, '/second');
                                    }
                                  } else {
                                    Navigator.pushNamed(context, '/second');
                                  }
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        leading: CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            _allResults[index][
                                                                    "hProfilePic"] ??
                                                                '',
                                                          ),
                                                        ),
                                                        title: Text(
                                                          _allResults[index]
                                                                  ["hName"] +
                                                              " " +
                                                              _allResults[index]
                                                                  ["hGotra"] +
                                                              " ",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        subtitle: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "$maskedHPhoneNum",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "${_allResults[index]['hCity']}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (_allResults[index]
                                                                  ["wName"] !=
                                                              null &&
                                                          _allResults[index]
                                                                  ["wGotra"] !=
                                                              null &&
                                                          _allResults[index][
                                                                  "wContact"] !=
                                                              null) ...[
                                                        Column(
                                                          children: [
                                                            const Divider(
                                                              thickness: 0.4,
                                                            ),
                                                            ListTile(
                                                              visualDensity:
                                                                  VisualDensity(
                                                                      vertical:
                                                                          -4),
                                                              leading:
                                                                  CircleAvatar(
                                                                radius: 25,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                  _allResults[index]
                                                                          [
                                                                          "wProfilePic"] ??
                                                                      '',
                                                                ),
                                                              ),
                                                              title: Text(
                                                                _allResults[index]
                                                                        [
                                                                        'wName'] +
                                                                    " " +
                                                                    _allResults[
                                                                            index]
                                                                        [
                                                                        'wGotra'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              subtitle: Column(
                                                                children: [
                                                                  if (_allResults[
                                                                              index]
                                                                          [
                                                                          "wContact"] !=
                                                                      null)
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          "$maskedWPhoneNum",
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ] else
                                                        Container(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5)
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return ListView.builder(
                            controller: _controller,
                            itemCount: resultList.length,
                            itemBuilder: (context, index) {
                              var docId = resultList[index].id;

                              String hPhoneNumber =
                                  resultList[index]['hContact'];
                              String maskedHResultedPhoneNum =
                                  maskLastThreeDigits(hPhoneNumber);
                              String? wPhoneNumber;
                              String? maskedWResultedPhoneNum;
                              if (resultList[index]['wContact'] != null) {
                                wPhoneNumber = resultList[index]['wContact'];
                                maskedWResultedPhoneNum =
                                    maskLastThreeDigits(wPhoneNumber!);
                              }

                              return GestureDetector(
                                onTap: () async {
                                  var sharedPref =
                                      await SharedPreferences.getInstance();
                                  var isLoggedIn =
                                      sharedPref.getBool(MyAppState.KEYLOGIN);
                                  print(
                                      " VALUE OF IS LOGGED IN in userdetails: $isLoggedIn");
                                  if (isLoggedIn != null) {
                                    if (isLoggedIn == true) {
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UserDetailsPage(
                                              userData: resultList[index].data()
                                                  as Map<String, dynamic>,
                                              userId: docId),
                                        ),
                                      );
                                    } else {
                                      Navigator.pushNamed(context, '/second');
                                    }
                                  } else {
                                    Navigator.pushNamed(context, '/second');
                                  }
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      leading: CircleAvatar(
                                                        radius: 25,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          resultList[index][
                                                                  "hProfilePic"] ??
                                                              '',
                                                        ),
                                                      ),
                                                      title: Text(
                                                        resultList[index]
                                                                ["hName"] +
                                                            " " +
                                                            resultList[index]
                                                                ["hGotra"] +
                                                            " ",
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      subtitle: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "${resultList[index]['hOccupation']}",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "$maskedHResultedPhoneNum",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (resultList[index]
                                                                ["wName"] !=
                                                            null &&
                                                        resultList[index]
                                                                ["wGotra"] !=
                                                            null &&
                                                        resultList[index][
                                                                "wOccupation"] !=
                                                            null &&
                                                        resultList[index]
                                                                ["wContact"] !=
                                                            null) ...[
                                                      Column(
                                                        children: [
                                                          ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              radius: 25,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                resultList[index]
                                                                        [
                                                                        "wProfilePic"] ??
                                                                    '',
                                                              ),
                                                            ),
                                                            title: Text(
                                                              resultList[index][
                                                                      'wName'] +
                                                                  " " +
                                                                  resultList[
                                                                          index]
                                                                      [
                                                                      'wGotra'],
                                                              style: const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            subtitle: Column(
                                                              children: [
                                                                // if (resultList[
                                                                //             index]
                                                                //         [
                                                                //         "wOccupation"] !=
                                                                //     null)
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "${resultList[index]['wOccupation']}",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                // if (resultList[
                                                                //             index]
                                                                //         [
                                                                //         "wContact"] !=
                                                                //     null)
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "$maskedWResultedPhoneNum",
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ] else
                                                      Container(),
                                                    const Divider(
                                                      thickness: 0.4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        return const Text("No data");
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget citySearchBar() {
    return Stack(children: [
      GestureDetector(
        onTap: _doToggle,
        child: const SizedBox(
            height: kToolbarHeight * 0.8,
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 25.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Tap to select your city",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )),
      ),
      AnimatedContainer(
        width: _toggle ? 0 : MediaQuery.of(context).size.width,
        transform: Matrix4.translationValues(
            _toggle ? MediaQuery.of(context).size.width : 0, 0, 0),
        duration: const Duration(seconds: 1),
        height: kToolbarHeight * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            width: 0.5,
            color: Color.fromRGBO(225, 225, 225, 1),
          ),
        ),
        child: TextField(
          controller: searchCityController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              label: const Text("Enter Your City"),
              labelStyle:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              prefixIcon: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1),
                  opacity: _toggle ? 0 : 1,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                    onPressed: _doToggle,
                  )),
              border: InputBorder.none),
          onChanged: (val) {
            setState(() {
              selectedCity = searchCityController.text.trim().capitalizeFirst;
            });
          },
        ),
      )
    ]);
  }
}
