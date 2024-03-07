import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/edit_details_page.dart';
import 'package:flutter_directory_app/home_page.dart';
import 'package:flutter_directory_app/location_notifier.dart';
import 'package:flutter_directory_app/login_page.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/phone_number_notifier.dart';
import 'package:flutter_directory_app/profile.dart';
import 'package:flutter_directory_app/register_details_page.dart';
import 'package:flutter_directory_app/user-details-page.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
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

  check() async {
    var sharedPref = await SharedPreferences.getInstance();
    checkNum = sharedPref.getString(MyAppState.PHONENUM);
    print("VALUE OF CHECK NUM IN CHECK() $checkNum");
    return checkNum;
  }

  final TextEditingController searchController = TextEditingController();
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    dataStream = FirebaseFirestore.instance
        .collection("directory-users")
        .snapshots()
        .asBroadcastStream();
    searchController.addListener(onSearchChanged);
    _controller = ScrollController();
    super.initState();
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

        if (hName.contains(searchController.text.toLowerCase()) ||
            wName.contains(searchController.text.toLowerCase()) ||
            hCurrentAddress.contains(searchController.text.toLowerCase()) ||
            wCurrentAddress.contains(searchController.text.toLowerCase()) ||
            hOccupation.contains(searchController.text.toLowerCase()) ||
            wOccupation.contains(searchController.text.toLowerCase()) ||
            hGotra.contains(searchController.text.toLowerCase()) ||
            wGotra.contains(searchController.text.toLowerCase())) {
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

  @override
  Widget build(BuildContext context) {
    check();
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
        floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegistrationPage()));
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/images/home.png')),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyProfile()));
                  },
                  child: const ImageIcon(AssetImage('assets/images/more.png'))),
                label: 'More',
              ),
            ],
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            elevation: 5
            ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 30,
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: searchCityController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(0.00),
                            hintText: 'Select your city',
                            hintStyle: TextStyle(fontSize: 10),
                          ),
                          onChanged: (val) {
                            setState(() {
                              selectedCity = searchCityController.text.trim();
                            });
                          },
                        
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<dynamic>(
                    stream: dataStream,
                    builder: (context, snapshot) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            searchClick = true;
                            print(
                                "Value OF SEARCHcLICK IN ONGESTUREDETECTOR :$searchClick");
                          });
                        },
                        child: AnimSearchBar(
                          width: 200,
                          textController: searchController,
                          onSuffixTap: () {
                            print("SUUFIX TAPPED");
                            setState(() {
                              searchController.clear();
                              searchClick = false;
                              print(
                                  "Value OF SEARCHcLICK IN ONSUFFIXTAP :$searchClick");
                            });
                          },
                          rtl: false,
                          onSubmitted: (String value) {
                            debugPrint("onSubmitted value : " + value);
                            // Handle submitted event if needed
                          },

                        ),
                      );
                    },
                  ),
                
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
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

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserDetailsPage(
                                        userData: _allResults[index].data()
                                            as Map<String, dynamic>,
                                            userId : docId,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 0),
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
                                                              _allResults[index]
                                                                      [
                                                                      "hProfilePic"] ??
                                                                  '',
                                                            ),
                                                          ),
                                                          title: Text(
                                                            _allResults[index]
                                                                    ["hName"] +
                                                                " " +
                                                                _allResults[
                                                                        index]
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
                                                                    "${_allResults[index]['hContact']}",
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
                                                            _allResults[index][
                                                                    "wGotra"] !=
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
                                                                subtitle:
                                                                    Column(
                                                                  children: [
                                                                    if (_allResults[index]
                                                                            [
                                                                            "wContact"] !=
                                                                        null)
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "${_allResults[index]['wContact']}",
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
                                        ),
                                      ],
                                    ),
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

                              return GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => UserDetailsPage(
                                  //       userData: resultList[index].data()
                                  //           as Map<String, dynamic>,
                                  //           userId: docId
                                  //     ),
                                  //   ),
                                  // );
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
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 2),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            "Head of Family",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              var sharedPref =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              checkNum = sharedPref
                                                                  .getString(
                                                                      MyAppState
                                                                          .PHONENUM);
                                                              if (checkNum == resultList[index]['addedBy'] ||
                                                                  checkNum ==
                                                                      resultList[
                                                                              index]
                                                                          [
                                                                          'hContact'] ||
                                                                  checkNum ==
                                                                      resultList[
                                                                              index]
                                                                          [
                                                                          'wContact']) {
                                                                // ignore: use_build_context_synchronously
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            EditDetails(
                                                                      userData: resultList[index]
                                                                              .data()
                                                                          as Map<
                                                                              String,
                                                                              dynamic>,
                                                                      userId:
                                                                          docId,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            child:
                                                                FutureBuilder<
                                                                    dynamic>(
                                                              future: check(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                checkNum =
                                                                    snapshot
                                                                        .data;

                                                                return (checkNum == resultList[index]['addedBy'] ||
                                                                        checkNum ==
                                                                            resultList[index][
                                                                                'hContact'] ||
                                                                        checkNum ==
                                                                            resultList[index]['wContact'])
                                                                    ? const Icon(
                                                                        Icons
                                                                            .edit_note,
                                                                        color: Color.fromRGBO(
                                                                            5,
                                                                            111,
                                                                            146,
                                                                            1),
                                                                        size:
                                                                            25,
                                                                      )
                                                                    : Container(); // Empty container when condition is false
                                                              },
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    ListTile(
                                                      leading: CircleAvatar(
                                                        radius: 30,
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
                                                              const Icon(
                                                                Icons.work,
                                                                size: 15,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        5,
                                                                        111,
                                                                        146,
                                                                        1),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
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
                                                              const Icon(
                                                                Icons.phone,
                                                                size: 15,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        5,
                                                                        111,
                                                                        146,
                                                                        1),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                "${resultList[index]['hContact']}",
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
                                                            null ||
                                                        resultList[index]
                                                                ["wGotra"] !=
                                                            null ||
                                                        resultList[index][
                                                                "wOccupation"] !=
                                                            null ||
                                                        resultList[index]
                                                                ["wContact"] !=
                                                            null) ...[
                                                      Column(
                                                        children: [
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        2),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "Spouse",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              radius: 30,
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
                                                                if (resultList[
                                                                            index]
                                                                        [
                                                                        "wOccupation"] !=
                                                                    null)
                                                                  Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .work,
                                                                        size:
                                                                            15,
                                                                        color: Color.fromRGBO(
                                                                            5,
                                                                            111,
                                                                            146,
                                                                            1),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
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
                                                                if (resultList[
                                                                            index]
                                                                        [
                                                                        "wContact"] !=
                                                                    null)
                                                                  Row(
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .phone,
                                                                        size:
                                                                            15,
                                                                        color: Color.fromRGBO(
                                                                            5,
                                                                            111,
                                                                            146,
                                                                            1),
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(
                                                                        "${resultList[index]['wContact']}",
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
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 2),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "more",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        24,
                                                                        99,
                                                                        26),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          Icon(
                                                            Icons.double_arrow,
                                                            size: 15,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    24,
                                                                    99,
                                                                    26),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
