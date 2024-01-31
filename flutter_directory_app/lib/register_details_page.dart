import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/show_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final bool validate = false;

  final TextEditingController headNameController = TextEditingController();

  final TextEditingController headGotraController = TextEditingController();

  final TextEditingController headOccupationController =
      TextEditingController();

  final TextEditingController headContactController = TextEditingController();

  final TextEditingController headBirthplaceController =
      TextEditingController();

  final TextEditingController headCurrentAddressController =
      TextEditingController();

  final TextEditingController wifeNameController = TextEditingController();

  final TextEditingController wifeGotraController = TextEditingController();

  final TextEditingController wifeOccupationController =
      TextEditingController();

  final TextEditingController wifeContactController = TextEditingController();

  final TextEditingController wifeBirthplaceController =
      TextEditingController();

  final TextEditingController wifeCurrentAddressController =
      TextEditingController();

  File? headProfilePic;
  File? wifeProfilePic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Family Registration',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: Theme.of(context).colorScheme.primary,
                blurRadius: 4.0,
                offset: const Offset(-2.0, 2.0),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShowData()),
              );
            },
            icon: const Icon(Icons.exit_to_app),
            color: Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () async {
                final hSelectedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (hSelectedImage != null) {
                  File convertedFile = File(hSelectedImage.path);
                  setState(() {
                    headProfilePic = convertedFile;
                    print("setstate triggered");
                  });
                  print("Image selected");
                } else {
                  print("No image selected");
                }
              },
              child: Container(
                height: 150,
                width: 150,
                child: headProfilePic == null
                    ? Image.asset('assets/images/user.png')
                    : Image.file(headProfilePic!),
              ),
            ),
            const SizedBox(height: 5),
            const Center(
              child: Text(
                'Tap to select your profile photo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            _buildPersonForm("Householder"),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final wSelectedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (wSelectedImage != null) {
                  File wConvertedFile = File(wSelectedImage.path);
                  setState(() {
                    wifeProfilePic = wConvertedFile;
                    print("setstate triggered");
                  });
                  print("Image selected");
                } else {
                  print("No image selected");
                }
              },
              child: Container(
                height: 150,
                width: 150,
                child: wifeProfilePic == null
                    ? Image.asset('assets/images/user.png')
                    : Image.file(wifeProfilePic!),
              ),
            ),
            const SizedBox(height: 5),
            const Center(
              child: Text(
                'Tap to select your profile photo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            _buildPersonForm("Spouse"),
            SizedBox(height: 10),
            _buildRegisterNowButton(),
          ],
        ),
      ),
    );
  }

  _buildRegisterNowButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: ElevatedButton(
        onPressed: () {
          saveUser();
          // submitForm();
        },
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          backgroundColor: const Color.fromRGBO(5, 111, 146, 1),
          foregroundColor: Colors.white,
        ),
        child: const Text(
          "Register Now",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  _buildPersonForm(String title) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            _buildTextField(
                '$title Name',
                title == "Householder"
                    ? headNameController
                    : wifeNameController),
            _buildTextField(
                '$title Gotra',
                title == "Householder"
                    ? headGotraController
                    : wifeGotraController),
            _buildTextField(
                '$title Occupation',
                title == "Householder"
                    ? headOccupationController
                    : wifeOccupationController),
            _buildTextField(
                '$title Contact',
                title == "Householder"
                    ? headContactController
                    : wifeContactController),
            _buildTextField(
                '$title Birthplace',
                title == "Householder"
                    ? headBirthplaceController
                    : wifeBirthplaceController),
            _buildTextField(
                '$title CurrentAddress',
                title == "Householder"
                    ? headCurrentAddressController
                    : wifeCurrentAddressController),
          ],
        ),
      ),
    );
  }

  _buildTextField(String label, TextEditingController controller) {
    return TextField(
      cursorColor: Colors.black,
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        // errorText: validate && controller.text.isEmpty ? 'Required' : null,
      ),
    );
  }

  Future<void> saveUser() async {
    try {
      String hName = headNameController.text.trim();
      String hGotra = headGotraController.text.trim();
      String hOccupation = headOccupationController.text.trim();
      String hContactString = headContactController.text.trim();
      String hBirthplace = headBirthplaceController.text.trim();
      String hCurrentAddress = headCurrentAddressController.text.trim();
      String wName = wifeNameController.text.trim();
      String wGotra = wifeGotraController.text.trim();
      String wOccupation = wifeOccupationController.text.trim();
      String wContactString = wifeContactController.text.trim();
      String wBirthplace = wifeBirthplaceController.text.trim();
      String wCurrentAddress = wifeCurrentAddressController.text.trim();

      if (hName.isNotEmpty &&
          hGotra.isNotEmpty &&
          wName.isNotEmpty &&
          headProfilePic != null &&
          wifeProfilePic != null) {
        final headDownloadUrl =
            await uploadFile(headProfilePic!, "headProfilePictures");
        print("HEAD PROFILE PICTURE: $headDownloadUrl");
        print("wifeProfilePic: $wifeProfilePic");
        final wifeDownloadUrl =
            await uploadFile(wifeProfilePic!, "wifeProfilePictures");
        print("WIFE PROFILE PICTURE: $wifeDownloadUrl");

        Map<String, dynamic> userData = {
          "hProfilePic": headDownloadUrl,
          "hName": hName,
          "hGotra": hGotra,
          "hOccupation": hOccupation,
          "hContact": hContactString,
          "hBirthPlace": hBirthplace,
          "hCurrentAddress": hCurrentAddress,
          "wProfilePic": wifeDownloadUrl,
          "wName": wName,
          "wGotra": wGotra,
          "wOccupation": wOccupation,
          "wContact": wContactString,
          "wBirthPlace": wBirthplace,
          "wCurrentAddress": wCurrentAddress,
        };

        await FirebaseFirestore.instance
            .collection("directory-users")
            .add(userData);

        print("User Created!");
        submitForm();
      } else {
        print("User not created. Please fill in all required fields.");
      }
    } catch (error) {
      print("Error saving user: $error");
    } finally {
      setState(() {
        headProfilePic = null;
        wifeProfilePic = null;
      });
    }
  }

  Future<String> uploadFile(File file, String folder) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("Profilepictures")
          .child(folder)
          .child(Uuid().v1());
      final uploadTask = ref.putFile(file);
      final taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (error) {
      print("Error uploading file: $error");
      throw error;
    }
  }

  void submitForm() {
    setState(() {
      clearRegScreen();
    });

    final headData = {
      'hName': headNameController.text.trim(),
      'hGotra': headGotraController.text.trim(),
      'hOccupation': headOccupationController.text.trim(),
      'hContactString': headContactController.text.trim(),
      'hBirthplace': headBirthplaceController.text.trim(),
      'hCurrentAddress': headCurrentAddressController.text.trim(),
    };
    final wifeData = {
      'wName': wifeNameController.text.trim(),
      'wGotra': wifeGotraController.text.trim(),
      'wOccupation': wifeOccupationController.text.trim(),
      'wContactString': wifeContactController.text.trim(),
      'wBirthplace': wifeBirthplaceController.text.trim(),
      'wCurrentAddress': wifeCurrentAddressController.text.trim(),
    };
    print('Head of the Family: $headData');
    print('Wife: $wifeData');
  }

  void clearRegScreen() {
    headNameController.clear();
    headGotraController.clear();
    headOccupationController.clear();
    headContactController.clear();
    headBirthplaceController.clear();
    headCurrentAddressController.clear();
    // headProfilePic = null;
    wifeNameController.clear();
    wifeGotraController.clear();
    wifeOccupationController.clear();
    wifeContactController.clear();
    wifeBirthplaceController.clear();
    wifeCurrentAddressController.clear();
    // wifeProfilePic = null;
  }
}
