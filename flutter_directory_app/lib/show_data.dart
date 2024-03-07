import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/home_page.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/profile.dart';
import 'package:flutter_directory_app/register_details_page.dart';
import 'package:flutter_directory_app/user-details-page.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'animated_seach_bar.dart';

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

  void _doToggle() => setState(() => _toggle = !_toggle);

  int _currentIndex = 0;
  _onTap() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => _children[_currentIndex]));
  }

  final List<Widget> _children = [
    ShowData(),
    MyProfile(),
  ];

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
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            )
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _onTap();
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
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        hintText: "Search",
                        //  border: border,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(225, 225, 225, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(225, 225, 225, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (searchController) {
                        _allResults = snapshot.data!.docs;
                        searchResultList(_allResults);
                      });
                }),
          ),
        ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Column(
              children: [
                const SizedBox(height: 5,),
                citySearchBar(),
                const SizedBox(height: 5,),
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
                            print(
                                "value of checkNum in streambuilder $checkNum");
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
                                          userId: docId,
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
                                                                visualDensity: VisualDensity(vertical: -4),
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
                                        ],
                                      ),
                                      const SizedBox(height:5)
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserDetailsPage(
                                            userData: resultList[index].data()
                                                as Map<String, dynamic>,
                                            userId: docId),
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
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "${resultList[index]['hContact']}",
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
                                                      if (resultList[index]
                                                                  ["wName"] !=
                                                              null &&
                                                          resultList[index]
                                                                  ["wGotra"] !=
                                                              null &&
                                                          resultList[index][
                                                                  "wOccupation"] !=
                                                              null &&
                                                          resultList[index][
                                                                  "wContact"] !=
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
                                                                resultList[index]
                                                                        [
                                                                        'wName'] +
                                                                    " " +
                                                                    resultList[
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
                const SizedBox(height:5),
              ],
            ),
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
