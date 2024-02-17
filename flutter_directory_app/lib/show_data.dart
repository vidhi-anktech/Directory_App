import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/edit_details_page.dart';
import 'package:flutter_directory_app/home_page.dart';
import 'package:flutter_directory_app/login_page.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/phone_number_notifier.dart';
import 'package:flutter_directory_app/register_details_page.dart';
import 'package:flutter_directory_app/user-details-page.dart';
import 'package:flutter_scrolling_fab_animated/flutter_scrolling_fab_animated.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowData extends ConsumerStatefulWidget {
  // String phoneNo;
  ShowData({
    super.key,
    // required this.phoneNo
  });

  @override
  ConsumerState<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends ConsumerState<ShowData> {
  List _allResults = [];
  List resultList = [];
  var checkNum;
  check() async {
    var sharedPref = await SharedPreferences.getInstance();
    checkNum = sharedPref.getString(MyAppState.PHONENUM);
    print("VALUE OF CHECK NUM IN CHECK() $checkNum");
    return checkNum;
  }

  final TextEditingController _searchController = TextEditingController();
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _searchController.addListener(onSearchChanged);
    _controller = ScrollController();
    super.initState();
  }

  onSearchChanged() {
    print("SEARCH CONTROLLER TEXT ${_searchController.text}");
    searchResultList();
  }

  searchResultList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var clientSnapShot in _allResults) {
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

        if (hName.contains(_searchController.text.toLowerCase()) ||
            wName.contains(_searchController.text.toLowerCase()) ||
            hCurrentAddress.contains(_searchController.text.toLowerCase()) ||
            wCurrentAddress.contains(_searchController.text.toLowerCase()) ||
            hOccupation.contains(_searchController.text.toLowerCase()) ||
            wOccupation.contains(_searchController.text.toLowerCase()) ||
            hGotra.contains(_searchController.text.toLowerCase()) ||
            wGotra.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      resultList = showResults;
    });
  }

  getClientStream() async {
    var data = await FirebaseFirestore.instance
        .collection("directory-users")
        .orderBy("hName")
        .get();

    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  Stream<List<Map<String, dynamic>>> fetchData() async* {
    try {
      var data = await FirebaseFirestore.instance
          .collection("directory-users")
          .orderBy("hName")
          .get();

      var resultList =
          data.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      yield resultList;
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    check();
    print('VALUE OF CHECK() AT BUILDCONTEXT $check()');

    void logout() async {
      var sharedPref = await SharedPreferences.getInstance();
      sharedPref.setBool(MyAppState.KEYLOGIN, false);
      final notifier = ref.read(phoneNoProvider.notifier);
      notifier.setPhoneNo(phoneNo: '');
      sharedPref.setString(MyAppState.PHONENUM, '');
      await FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }

    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(225, 225, 225, 1),
      ),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
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
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const Text(
            "User Directory",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromRGBO(5, 111, 146, 1).withOpacity(0.8),
          actions: [
            IconButton(
              onPressed: () {
                logout();
              },
              icon: const Icon(Icons.exit_to_app),
            )
          ],
        ),
        floatingActionButton: ScrollingFabAnimated(
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 20,
          ),
          text: const Text(
            'Add',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.bold),
          ),
          onPress: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegistrationPage()));
          },
          scrollController: _controller,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
          width: 10,
          animateIcon: true,
          inverted: false,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    hintText: "Search",
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("directory-users")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return ListView.builder(
                          controller: _controller,
                          itemCount: resultList.length,
                          itemBuilder: (context, index) {
                            var docId = resultList[index].id;
                            print(
                                'VALUE OF WNAME : ${resultList[index]['wName']}');

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserDetailsPage(
                                      userData: resultList[index].data()
                                          as Map<String, dynamic>,
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
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            var sharedPref =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            var checkNum =
                                                                sharedPref.getString(
                                                                    MyAppState
                                                                        .PHONENUM);
                                                            print(
                                                                "CHECKNUM INSIDE EDIT WIDGET $checkNum");
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
                                                          child: FutureBuilder<
                                                              dynamic>(
                                                            future: check(),
                                                            builder: (context,
                                                                snapshot) {
                                                              var checkNum =
                                                                  snapshot.data;
                                                              print(
                                                                  "VALUE OF CHECKNUM INSIDE FUTUREBUILDER $checkNum");
                                                              return (checkNum == resultList[index]['addedBy'] ||
                                                                      checkNum ==
                                                                          resultList[index]
                                                                              [
                                                                              'hContact'] ||
                                                                      checkNum ==
                                                                          resultList[index]
                                                                              [
                                                                              'wContact'])
                                                                  ? const Icon(
                                                                      Icons
                                                                          .edit_note,
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              5,
                                                                              111,
                                                                              146,
                                                                              1),
                                                                      size: 25,
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
                                                        fontWeight: FontWeight.w600
                                                      ),
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
                                                      resultList[index]
                                                              ["wOccupation"] !=
                                                          null ||
                                                      resultList[index]
                                                              ["wContact"] !=
                                                          null) ...[
                                                    Column(
                                                      children: [
                                                        const Padding(
                                                          padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                          child:  Row(
                                                            children: [
                                                             Text(
                                                                "Spouse",
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight.bold,
                                                                ),),
                                                            ],
                                                          ),
                                                        ),
                                                        ListTile(
                                                          leading: CircleAvatar(
                                                            radius: 30,
                                                            backgroundImage:
                                                                NetworkImage(
                                                              resultList[index][
                                                                      "wProfilePic"] ??
                                                                  '',
                                                            ),
                                                          ),
                                                          title: Text(
                                                            resultList[index]
                                                                ['wName'] + " " + resultList[index]['wGotra'],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.bold
                                                            ),
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
                                                                      size: 15,
                                                                      color: Color
                                                                          .fromRGBO(
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
                                                                      size: 15,
                                                                      color: Color
                                                                          .fromRGBO(
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
                                                          MainAxisAlignment.end,
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
                                                          color: Color.fromARGB(
                                                              255, 24, 99, 26),
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
                      } else {
                        return const Text("No data");
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
