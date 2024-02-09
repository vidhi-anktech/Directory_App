import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/edit_details_page.dart';
import 'package:flutter_directory_app/register_details_page.dart';
import 'package:flutter_directory_app/user-details-page.dart';

class ShowData extends StatefulWidget {
  String phoneNo;
  ShowData({super.key, required this.phoneNo});

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

  @override
  Widget build(BuildContext context) {
    print(
        "Phone Number That User Entererd at show data page: ${widget.phoneNo}");
    const border = OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(225, 225, 225, 1),
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)));
    return Scaffold(
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
        backgroundColor: Color.fromRGBO(5, 111, 146, 1).withOpacity(0.8),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RegistrationPage(
                        phoneNo: widget.phoneNo,
                      )));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          itemCount: resultList.length,
                          itemBuilder: (context, index) {
                            var docId = resultList[index].id;
                          
                            editIconButton() {
                              if (widget.phoneNo ==
                                      resultList[index]['addedBy'] ||
                                  widget.phoneNo ==
                                      resultList[index]['hContact'] ||
                                  widget.phoneNo ==
                                      resultList[index]['wContact']) {
                                return IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditDetails(
                                            userData: resultList[index].data()
                                                as Map<String, dynamic>,
                                            userId: docId,
                                            phoneNo: widget.phoneNo,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color.fromRGBO(5, 111, 146, 1),
                                    ));
                              }
                              else{
                                return Container();
                              }
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
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
                                    padding: const EdgeInsets.all(5.0),
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
                                            editIconButton(),
                                          ],
                                        ),
                                        ListTile(
                                          leading: CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                              resultList[index]
                                                      ["hProfilePic"] ??
                                                  '', 
                                            ),
                                          ),
                                          title: Text(
                                            resultList[index]["hName"] +
                                                " " +
                                                resultList[index]["hGotra"] +
                                                " ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.work,
                                                    size: 15,
                                                    color: Color.fromRGBO(
                                                        5, 111, 146, 1),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                      "${resultList[index]['hOccupation']}"),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.phone,
                                                    size: 18,
                                                    color: Color.fromRGBO(
                                                        5, 111, 146, 1),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                      "${resultList[index]['hContact']}"),
                                                ],
                                              ),
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
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                              resultList[index]
                                                      ["wProfilePic"] ??
                                                  '', 
                                            ),
                                          ),
                                          title: Text(
                                            resultList[index]["wName"] +
                                                " " +
                                                resultList[index]["wGotra"] +
                                                " ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.work,
                                                    size: 15,
                                                    color: Color.fromRGBO(
                                                        5, 111, 146, 1),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                      "${resultList[index]['wOccupation']}"),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.phone,
                                                    size: 18,
                                                    color: Color.fromRGBO(
                                                        5, 111, 146, 1),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                      "${resultList[index]['wContact']}"),
                                                ],
                                              ),
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
