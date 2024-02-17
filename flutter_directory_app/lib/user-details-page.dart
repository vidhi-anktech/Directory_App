import 'package:flutter/material.dart';

class UserDetailsPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserDetailsPage({super.key, required this.userData});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "User Details",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(5, 111, 146, 1).withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: double.infinity,
            child: Card(
              elevation: 2,
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "HOUSEHOLDER  INFO",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.network(
                      widget.userData['hProfilePic'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Name : ${widget.userData["hName"]} ${widget.userData["hGotra"]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text("Occupation : ${widget.userData["hOccupation"]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  Text(
                      "Current Address : ${widget.userData["hCurrentAddress"]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  Text("Contact : ${widget.userData["hContact"]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  Text("Birth Place : ${widget.userData["hBirthPlace"]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  const SizedBox(height: 10),
                 
                  if (widget.userData["wName"] != null ||
                      widget.userData["wGotra"] != null ||
                      widget.userData["wOccupation"] != null ||
                      widget.userData["wContact"] != null ||
                      widget.userData['wCurrentAddress'] != null ||
                      widget.userData['wBirthPlace'] != null) ...[
                    Column(
                      children: [
                         const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                        const SizedBox(height: 10),
                        const Text(
                          "SPOUSE INFO",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.network(
                            widget.userData['wProfilePic'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            "Name : ${widget.userData["wName"]} ${widget.userData["wGotra"]}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text("Occupation : ${widget.userData["wOccupation"]}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15)),
                        Text(
                            "Current Address : ${widget.userData["wCurrentAddress"]}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15)),
                        Text("Contact : ${widget.userData["wContact"]}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15)),
                        Text("Birth Place : ${widget.userData["wBirthPlace"]}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15)),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ] else Container(),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
