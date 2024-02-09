import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';

class EditDetails extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String userId;
  String phoneNo;
   EditDetails({super.key, required this.userData, required this.userId, required this.phoneNo});

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  final hNameEditController = TextEditingController();
  final hOccupationEditController = TextEditingController();
  final hAddressEditController = TextEditingController();
  final hContactEditController = TextEditingController();
  final hBirthPlaceEditController = TextEditingController();
  final wNameEditController = TextEditingController();
  final wOccupationEditController = TextEditingController();
  final wAddressEditController = TextEditingController();
  final wContactEditController = TextEditingController();
  final wBirthPlaceEditController = TextEditingController();
  File? headEditedProfilePic;
  File? wifeEditedProfilePic;
  bool _loading = false;
  Map<String, dynamic> editedData = {};

  @override
  Widget build(BuildContext context) {
    // print("LET CHECKKKK ${widget.userData['hProfilePic']}");
    print("Phone Number That User Entererd at edit page: ${widget.phoneNo}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Details"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator:LoadingAnimationWidget.twistingDots(
           leftDotColor: const Color.fromRGBO(5, 111, 146, 1),
            rightDotColor: Theme.of(context).colorScheme.primary,
            size: 40,
        ), 
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final hSelectedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (hSelectedImage != null) {
                            File editedFile = File(hSelectedImage.path);
                            setState(() {
                              headEditedProfilePic = editedFile;
                            });
                            print("Image selected");
                          } else {
                            print("No image selected");
                          }
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          child: headEditedProfilePic == null
                              ? Image.network(widget.userData['hProfilePic'])
                              : Image.file(headEditedProfilePic!),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              _buildTextField(
                                  "Name", hNameEditController, 'hName'),
                              _buildTextField("Occupation",
                                  hOccupationEditController, 'hOccupation'),
                              _buildTextField("Current Address",
                                  hAddressEditController, 'hCurrentAddress'),
                              _buildTextField("Contact Number",
                                  hContactEditController, 'hContact'),
                              _buildTextField("Birth Place",
                                  hBirthPlaceEditController, 'hBirthPlace'),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final wSelectedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (wSelectedImage != null) {
                            File wEditedFile = File(wSelectedImage.path);
                            setState(() {
                              wifeEditedProfilePic = wEditedFile;
                            });
                            print("Image selected");
                          } else {
                            print("No image selected");
                          }
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          child: wifeEditedProfilePic == null
                              ? Image.network(widget.userData['wProfilePic'])
                              : Image.file(wifeEditedProfilePic!),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              _buildTextField(
                                  "Name", wNameEditController, 'wName'),
                              _buildTextField("Occupation",
                                  wOccupationEditController, 'wOccupation'),
                              _buildTextField("Current Address",
                                  wAddressEditController, 'wCurrentAddress'),
                              _buildTextField("Contact Number",
                                  wContactEditController, 'wContact'),
                              _buildTextField("Birth Place",
                                  wBirthPlaceEditController, 'wBirthPlace'),
                            ],
                          ),
                        ),
                      ),
                      _buildUpdateNowButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTextField(
      String label, TextEditingController controller, String field) {
    return TextField(
      cursorColor: Colors.black,
      controller: controller..text = "${widget.userData[field]}",
      decoration: InputDecoration(
        hintText: label,
      ),
    );
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

  Future<void> _uploadAndSaveImage() async {
    if (headEditedProfilePic != null || wifeEditedProfilePic != null) {
      final downloadUrl =
          await uploadFile(headEditedProfilePic!, "headProfilePictures");
      final wDownloadUrl =
          await uploadFile(wifeEditedProfilePic!, "wifeProfilePictures");
      setState(() {
        editedData['hProfilePic'] = downloadUrl;
        editedData['wProfilePic'] = wDownloadUrl;
      });
      print("EDITED PROFILE PIC URL ${editedData['hProfilePic']}");
      print("WIFE EDITED PROFILE PIC URL ${editedData['wProfilePic']}");
    }
    else{
      print("YE TOH NULL AGYA");
    }
  }

  _buildUpdateNowButton() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _loading = true;
        });
        await _uploadAndSaveImage();
        editedData = {
          'hName': hNameEditController.text.trim(),
          'hOccupation': hOccupationEditController.text.trim(),
          'hCurrentAddress': hAddressEditController.text.trim(),
          'hContact': hContactEditController.text.trim(),
          'hBirthPlace': hBirthPlaceEditController.text.trim(),
          'wName': wNameEditController.text.trim(),
          'wOccupation': wOccupationEditController.text.trim(),
          'wCurrentAddress': wAddressEditController.text.trim(),
          'wContact': wContactEditController.text.trim(),
          'wBirthPlace': wBirthPlaceEditController.text.trim(),
        };

         if (editedData['hProfilePic'] != null) {
        editedData['hProfilePic'] = editedData['hProfilePic'];
      }
      if (editedData['wProfilePic'] != null) {
        editedData['wProfilePic'] = editedData['wProfilePic'];
      }

      
        await FirebaseFirestore.instance
            .collection("directory-users")
            .doc(widget.userId)
            .update(editedData)
            .then((value) => {
                  print("HURRAAAYYY! DATA UPDATED SUCCESSFULLY"),
                  Navigator.pop(context)
                });
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: const Color.fromRGBO(5, 111, 146, 1),
        foregroundColor: Colors.white,
      ),
      child: const Text(
        "Update",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}



