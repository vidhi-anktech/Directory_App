import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/edit_details_page.dart';
import 'package:flutter_directory_app/register_details_page.dart';
import 'package:flutter_directory_app/user-details-page.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  List _allResults = [];
  List resultList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(onSearchChanged);
    super.initState();
  }

  onSearchChanged() {
    print("HUAAAHHHH ${_searchController.text}");
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

        if (hName.contains(_searchController.text.toLowerCase()) ||
            wName.contains(_searchController.text.toLowerCase()) ||
            hCurrentAddress.contains(_searchController.text.toLowerCase()) ||
            wCurrentAddress.contains(_searchController.text.toLowerCase()) ||
            hOccupation.contains(_searchController.text.toLowerCase()) ||
            wOccupation.contains(_searchController.text.toLowerCase())) {
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

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(225, 225, 225, 1),
      ),
      borderRadius: BorderRadius.horizontal(left: Radius.circular(40)),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Directory"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistrationPage()));
              },
              icon: Icon(Icons.add_box_rounded),
              iconSize: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
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
                          shrinkWrap: true,
                          itemCount: resultList.length,
                          itemBuilder: (context, index) {
                            var docId = resultList[index].id;
                            print(
                                "LET CHECK ${resultList[index]['hProfilePic']}");
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
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
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "HOUSEHOLDER ",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                              IconButton(
                                                  onPressed: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         EditDetails(
                                                    //       userData:
                                                    //           resultList[index]
                                                    //                   .data()
                                                    //               as Map<String,
                                                    //                   dynamic>,
                                                    //       userId: docId,
                                                    //     ),
                                                    //   ),
                                                    // );
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Color.fromRGBO(
                                                        5, 111, 146, 1),
                                                  )),
                                      
                                          ],
                                        ),
                                        ListTile(
                                          leading: CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                              resultList[index]
                                                      ["hProfilePic"] ??
                                                  '', // Check for null
                                            ),
                                          ),
                                          title: Text(
                                            resultList[index]["hName"] +
                                                " " +
                                                resultList[index]["hGotra"] +
                                                " " +
                                                "(${resultList[index]['hOccupation']})",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              const Icon(Icons.phone, size: 18),
                                              const SizedBox(width: 5),
                                              Text(
                                                  "+91 ${resultList[index]['hContact']}"),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Row(
                                          children: [
                                            Text(
                                              "SPOUSE",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        ListTile(
                                          leading: CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                              resultList[index]
                                                      ["wProfilePic"] ??
                                                  '', // Check for null
                                            ),
                                          ),
                                          title: Text(
                                            resultList[index]["wName"] +
                                                " " +
                                                resultList[index]["wGotra"] +
                                                " " +
                                                "(${resultList[index]['wOccupation']})",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              const Icon(Icons.phone, size: 18),
                                              const SizedBox(width: 5),
                                              Text(
                                                  "+91 ${resultList[index]['hContact']}"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
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
    );
  }
}
