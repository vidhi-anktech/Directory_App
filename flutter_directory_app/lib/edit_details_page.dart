import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class EditDetails extends ConsumerStatefulWidget {
  final Map<String, dynamic> userData;
  final String userId;
  EditDetails({
    super.key,
    required this.userData,
    required this.userId,
  });

  @override
  ConsumerState<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends ConsumerState<EditDetails> {
  final hNameEditController = TextEditingController();
  final hGotraEditController = TextEditingController();
  final hOccupationEditController = TextEditingController();
  final hAddressEditController = TextEditingController();
  final hContactEditController = TextEditingController();
  final hBirthPlaceEditController = TextEditingController();
  final wNameEditController = TextEditingController();
  final wGotraEditController = TextEditingController();
  final wOccupationEditController = TextEditingController();
  final wAddressEditController = TextEditingController();
  final wContactEditController = TextEditingController();
  final wBirthPlaceEditController = TextEditingController();
  final spouseNameController = TextEditingController();
  final spouseGotraController = TextEditingController();
  final spouseContactController = TextEditingController();
  final spouseOccupationController = TextEditingController();
  final spouseCurrentAddressController = TextEditingController();
  final spouseBirthPlaceController = TextEditingController();
  File? headEditedProfilePic;
  File? wifeEditedProfilePic;
  bool _loading = false;
  Map<String, dynamic> editedData = {};
  File? wifeProfilePic;
  bool validate = false;
  bool validateWifeName = false;
  bool validateWifeGotra = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Details"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: LoadingAnimationWidget.twistingDots(
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            _buildHPersonDetails("Head", widget.userData),
                            _buildWPersonDetails("Wife", widget.userData),
                          ],
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

  Widget _buildHPersonDetails(String person, Map<String, dynamic> userData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              children: [
                Text(
                  "Householder",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final hSelectedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
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
            if (headEditedProfilePic != null) ...[
              IconButton(
                  onPressed: () {
                    _cropImage();
                  },
                  icon: const Icon(Icons.crop))
            ],
            _buildTextField(
              "$person Name",
              "hName",
              userData["hName"],
            ),
            _buildTextField(
              "$person Gotra",
              "hGotra",
              userData["hGotra"],
            ),
            _buildTextField(
              "$person Occupation",
              "hOccupation",
              userData["hOccupation"],
            ),
            _buildTextField(
              "$person Current Address",
              "hCurrentAddress",
              userData["hCurrentAddress"],
            ),
            _buildTextField(
              "$person Contact Number",
              "hContact",
              userData["hContact"],
            ),
            _buildTextField(
              "$person Birth Place",
              "hBirthPlace",
              userData["hBirthPlace"],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWPersonDetails(String person, Map<String, dynamic> userData) {
    if (userData["wName"] != null ||
        userData["wGotra"] != null ||
        userData["wOccupation"] != null ||
        userData["wContact"] != null ||
        userData['wBirthPlace'] != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Text(
                    "Spouse",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final wSelectedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (wSelectedImage != null) {
                    File wEditedFile = File(wSelectedImage.path);
                    setState(() {
                      wifeEditedProfilePic = wEditedFile;
                    });
                    print("Wife Image selected");
                  } else {
                    print("No Wife image selected");
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
              if (wifeEditedProfilePic != null) ...[
                IconButton(
                    onPressed: () {
                      _wEditedCropImage();
                    },
                    icon: const Icon(Icons.crop))
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    "$person Name",
                    "wName",
                    userData["wName"],
                  ),
                  _buildTextField(
                    "$person Gotra",
                    "wGotra",
                    userData["wGotra"],
                  ),
                  _buildTextField(
                    "$person Occupation",
                    "wOccupation",
                    userData["wOccupation"],
                  ),
                  _buildTextField(
                    "$person Current Address",
                    "wCurrentAddress",
                    userData["wCurrentAddress"],
                  ),
                  _buildTextField(
                    "$person Contact Number",
                    "wContact",
                    userData["wContact"],
                  ),
                  _buildTextField(
                    "$person Birth Place",
                    "wBirthPlace",
                    userData["wBirthPlace"],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                children: [
                  Text(
                    "Spouse",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final wSelectedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (wSelectedImage != null) {
                    File wConvertedFile = File(wSelectedImage.path);
                    setState(() {
                      wifeProfilePic = wConvertedFile;
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
              if (wifeProfilePic != null) ...[
                IconButton(
                    onPressed: () {
                      _wCropImage();
                    },
                    icon: const Icon(Icons.crop))
              ],
              const SizedBox(height: 5),
              const Center(
                child: Text(
                  'Tap to select your profile photo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              _buildWifeEmptyTextField(
                  'Spouse Name', spouseNameController, 'wName', validateWifeName ),
              _buildWifeEmptyTextField(
                  'Spouse Gotra', spouseGotraController, 'wGotra', validateWifeGotra),
              _buildWifeEmptyTextField('Spouse Occupation',
                  spouseOccupationController, 'wOccupation', false),
              _buildWifeEmptyTextField(
                  'Spouse Contact', spouseContactController, 'wContact', false),
              _buildWifeEmptyTextField('Spouse Birthplace',
                  spouseBirthPlaceController, 'wBirthPlace', false),
              _buildWifeEmptyTextField('Spouse CurrentAddress',
                  spouseCurrentAddressController, 'wCurrentAddress',false),
            ],
          ),
        ),
      );
    }
  }

  _buildWifeEmptyTextField(
      String label, TextEditingController controller, String field, bool validate) {
    return TextField(
      cursorColor: Colors.black,
      controller: controller,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(1.0))),
        hintText: label,
        hintStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        errorText: validate ? 'Required' : null,
        errorStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      onChanged: (value) {
        if(validateForm()){
        editedData[field] = value.capitalize??"";
        }
      },
    );
  }

  Widget _buildTextField(String label, String field, String? initialValue) {
    return TextFormField(
      initialValue: initialValue ?? '',
      decoration: InputDecoration(labelText: label),
      onChanged: (value) {
        editedData[field] = value.capitalize??"";
      },
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

  Widget _buildUpdateNowButton() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _loading = true;
        });
        await _uploadAndSaveImage();
        await FirebaseFirestore.instance
            .collection("directory-users")
            .doc(widget.userId)
            .update(editedData)
            .then((value) => {
                  print("HURRAAAYYY! DATA UPDATED SUCCESSFULLY"),
                  Navigator.pop(context),
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



  Future<void> _uploadAndSaveImage() async {
    if (headEditedProfilePic != null) {
      final downloadUrl =
          await uploadFile(headEditedProfilePic!, "headProfilePictures");
      setState(() {
        editedData['hProfilePic'] = downloadUrl;
      });
    }

    if (wifeEditedProfilePic != null) {
      final wDownloadUrl =
          await uploadFile(wifeEditedProfilePic!, "wifeProfilePictures");
      setState(() {
        editedData['wProfilePic'] = wDownloadUrl;
      });
    } else if (wifeProfilePic != null) {
      final wifeDownloadUrl =
          await uploadFile(wifeProfilePic!, "wifeProfilePictures");
      setState(() {
        editedData['wProfilePic'] = wifeDownloadUrl;
      });
    }
  }

  Future _cropImage() async {
    if (headEditedProfilePic != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: headEditedProfilePic!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop',
                cropGridColor: Colors.black,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(title: 'Crop')
          ]);

      if (cropped != null) {
        setState(() {
          headEditedProfilePic = File(cropped.path);
        });
      }
    }
  }

  Future _wEditedCropImage() async {
    if (wifeEditedProfilePic != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: wifeEditedProfilePic!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop',
                cropGridColor: Colors.black,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(title: 'Crop')
          ]);

      if (cropped != null) {
        setState(() {
          wifeEditedProfilePic = File(cropped.path);
        });
      }
    }
  }

  Future _wCropImage() async {
    if (wifeProfilePic != null) {
      CroppedFile? cropped = await ImageCropper()
          .cropImage(sourcePath: wifeProfilePic!.path, aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ], uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop',
            cropGridColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(title: 'Crop')
      ]);

      if (cropped != null) {
        setState(() {
          wifeProfilePic = File(cropped.path);
        });
      }
    }
  }
  validateForm() {
  validateWifeName = spouseNameController.text.isEmpty;
    validateWifeGotra = spouseGotraController.text.isEmpty;

    return !validateWifeName && !validateWifeGotra;
}
}
