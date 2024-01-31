import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("directory-users")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> userMap =
                        snapshot.data!.docs[index].data();

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(userMap["hProfilePic"]),
                              ),
                              title:  Text(
                                    userMap["hName"] + "(${userMap['hOccupation']})",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),),
                              
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text(
                                    "Current Address = ${userMap['hCurrentAddress']}"),
                                Text("Contact Number = ${userMap['hContact']}"),
                              ]),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(userMap["wProfilePic"]),
                              ),
                              title: Text(
                                  userMap["wName"] + "(${userMap['wOccupation']})",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text(
                                    "Spouse Current Address = ${userMap['wCurrentAddress']}"),
                                Text(
                                    "Spouse Contact Number = ${userMap['wContact']}"),
                              ]),
                            ),
                          ],
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
    );
  }
}
