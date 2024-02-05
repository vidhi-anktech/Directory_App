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
    print(" LET'S CHECK : ${widget.userData}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                "HOUSEHOLDER INFO...",
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
                child: Image.network(widget.userData['hProfilePic']),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  "Name : ${widget.userData["hName"]} ${widget.userData["hGotra"]}",
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text("Occupation : ${widget.userData["hOccupation"]}",
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              Text("Current Address : ${widget.userData["hCurrentAddress"]}",
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              Text("Contact Number : +91 ${widget.userData["hContact"]}",
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              Text("Birth Place : ${widget.userData["hBirthPlace"]}",
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              const SizedBox(height: 20),
              const Text(
                "SPOUSE INFO...",
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
                child: Image.network(widget.userData['wProfilePic']),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  "Name : ${widget.userData["wName"]} ${widget.userData["wGotra"]}",
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text("Occupation : ${widget.userData["wOccupation"]}",
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              Text("Current Address : ${widget.userData["wCurrentAddress"]}",
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              Text("Contact Number : +91 ${widget.userData["wContact"]}",
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              Text("Birth Place : ${widget.userData["wBirthPlace"]}",
                  style:
                      const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
