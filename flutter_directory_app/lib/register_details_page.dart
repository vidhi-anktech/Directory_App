import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  String phoneNo;
   RegistrationPage({super.key, required this.phoneNo});
  

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final snackBar = SnackBar(
  content: Text('Oops! Something went wrong'),
);
  bool validate = false;
  bool _loading = false;

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
      appBar:AppBar(
        backgroundColor: const Color.fromRGBO(5, 111, 146, 1).withOpacity(0.8),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        titleSpacing: 0,
        title: const FittedBox(
          fit: BoxFit.contain,
          child: Text(
            "Family Registration",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
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
        setState(() {
          validate = true; // Set validation to true when button is pressed
        });
        _onLoading();
        if (_validateForm()) {
          saveUser();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill in all required fields.'),
            ),
          );
          _hideLoading();
        }
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
        errorText: validate && controller.text.isEmpty ? 'Required' : null,
        errorStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600
        )
      ),
    );
  }

Future<void> saveUser() async {
   var sharedPref = await SharedPreferences.getInstance();
   var showNum = sharedPref.getString(MyAppState.PHONENUM);
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

    String hContact = "+91$hContactString";
    String wContact = "+91$wContactString";

    if (hName.isNotEmpty &&
        hGotra.isNotEmpty &&
        wName.isNotEmpty &&
        headProfilePic != null &&
        wifeProfilePic != null) {
      final headDownloadUrl =
          await uploadFile(headProfilePic!, "headProfilePictures");
      final wifeDownloadUrl =
          await uploadFile(wifeProfilePic!, "wifeProfilePictures");

      Map<String, dynamic> userData = {
        "hProfilePic": headDownloadUrl,
        "hName": hName,
        "hGotra": hGotra,
        "hOccupation": hOccupation,
        "hContact": hContact,
        "hBirthPlace": hBirthplace,
        "hCurrentAddress": hCurrentAddress,
        "wProfilePic": wifeDownloadUrl,
        "wName": wName,
        "wGotra": wGotra,
        "wOccupation": wOccupation,
        "wContact": wContact,
        "wBirthPlace": wBirthplace,
        "wCurrentAddress": wCurrentAddress,
        "addedBy" : showNum,
      };

      await FirebaseFirestore.instance
          .collection("directory-users")
          .add(userData);

      print("User Created!");
      print("ADDED BY : ${showNum}");
      submitForm();
    }
  } catch (error) {
    print("Error saving user: $error");
    _hideLoading();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Oops! Something went wrong'),
      ),
    );
  } finally {
    _hideLoading(); // Hide loading indicator whether there's an error or not
    setState(() {
      _loading = false;
      headProfilePic = null;
      wifeProfilePic = null;
    });
    Navigator.pop(context); // Close the loading dialog
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
      _loading = false;
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
    wifeNameController.clear();
    wifeGotraController.clear();
    wifeOccupationController.clear();
    wifeContactController.clear();
    wifeBirthplaceController.clear();
    wifeCurrentAddressController.clear();
  }


void _onLoading() {
  setState(() {
    _loading = true;
  });
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return 
        SizedBox(
          height:50,
          width:50,
          child: Center(
          child: LoadingAnimationWidget.twistingDots(
            leftDotColor: const Color.fromRGBO(5, 111, 146, 1),
            rightDotColor: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
                ),
        );
    
    },
  );
}

void _hideLoading() {
  Navigator.pop(context); // Close the loading dialog
  setState(() {
    _loading = false;
  });
}

_validateForm() {
  // Check if required fields are not empty
  return headNameController.text.isNotEmpty &&
      headGotraController.text.isNotEmpty &&
      headContactController.text.isNotEmpty &&
      wifeNameController.text.isNotEmpty;
}

}
