import 'dart:io';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/profile.dart';
import 'package:flutter_directory_app/register_details_page.dart';
import 'package:flutter_directory_app/show_data.dart';
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
  var textController = TextEditingController();
  final hNameEditController = TextEditingController();
  final hGotraEditController = TextEditingController();
  final hOccupationEditController = TextEditingController();
  final hPinCodeEditController = TextEditingController();
  final hDistrictEditController = TextEditingController();
  final hCityEditController = TextEditingController();
  final hStateEditController = TextEditingController();
  final hAddressEditController = TextEditingController();
  final hContactEditController = TextEditingController();
  final hBirthPlaceEditController = TextEditingController();
  final wNameEditController = TextEditingController();
  final wGotraEditController = TextEditingController();
  final wOccupationEditController = TextEditingController();
  final wAddressEditController = TextEditingController();
  final wPinCodeEditController = TextEditingController();
  final wDistrictEditController = TextEditingController();
  final wCityEditController = TextEditingController();
  final wStateEditController = TextEditingController();
  final wContactEditController = TextEditingController();
  final wBirthPlaceEditController = TextEditingController();
  final spouseNameController = TextEditingController();
  final spouseGotraController = TextEditingController();
  final spouseContactController = TextEditingController();
  final spouseOccupationController = TextEditingController();
  final spouseAddressController = TextEditingController();
  final spousePinCodeController = TextEditingController();
  final spouseStateController = TextEditingController();
  final spouseDistrictController = TextEditingController();
  final spouseCityController = TextEditingController();
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
  int _currentIndex = 0;
  _onTap() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => _children[_currentIndex]));
  }

  final List<Widget> _children = [
    ShowData(),
    MyProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegistrationPage()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          )
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _onTap();
        },
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
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Column(
              children: [
                Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Head of the family/Husband",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildHPersonDetails("Head", widget.userData),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Text(
                          "Spouse",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildWPersonDetails("Wife", widget.userData),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 3, child: _buildCancelButton()),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(flex: 3, child: _buildUpdateNowButton()),
                    ]),
                const SizedBox(height: 40)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHPersonDetails(String person, Map<String, dynamic> userData) {
    return Card(
      elevation: 0.7,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              child: headEditedProfilePic == null
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          NetworkImage(widget.userData['hProfilePic']))
                  : CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(headEditedProfilePic!)),
            ),
            if (headEditedProfilePic != null) ...[
              TextButton(
                onPressed: () {
                  _cropImage();
                },
                child: const Text(
                  "Crop Image",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              )
            ] else
              TextButton(
                  onPressed: () async {
                    final hSelectedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (hSelectedImage != null) {
                      File editedFile = File(hSelectedImage.path);
                      setState(() {
                        headEditedProfilePic = editedFile;
                      });
                    }
                  },
                  child: const Text(
                    "Edit Image",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  )),
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
              "$person Pin Code",
              "hPinCode",
              userData["hPinCode"],
            ),
            _buildTextField(
              "$person State",
              "hState",
              userData["hState"],
            ),
            _buildTextField(
              "$person District",
              "hDistrict",
              userData["hDistrict"],
            ),
            _buildTextField(
              "$person City",
              "hCity",
              userData["hCity"],
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
        elevation: 0.7,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                child: wifeEditedProfilePic == null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            NetworkImage(widget.userData['wProfilePic']))
                    : CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(wifeEditedProfilePic!)),
              ),
              if (wifeEditedProfilePic != null) ...[
                TextButton(
                  onPressed: () {
                    _wEditedCropImage();
                  },
                  child: const Text(
                    "Crop Image",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                )
              ] else
                TextButton(
                    onPressed: () async {
                      final wSelectedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (wSelectedImage != null) {
                        File wEditedFile = File(wSelectedImage.path);
                        setState(() {
                          wifeEditedProfilePic = wEditedFile;
                        });
                      }
                    },
                    child: const Text(
                      "Edit Image",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    )),
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
                    "$person Pin Code",
                    "wPinCode",
                    userData["wPinCode"],
                  ),
                  _buildTextField(
                    "$person State",
                    "wState",
                    userData["wState"],
                  ),
                  _buildTextField(
                    "$person District",
                    "wDistrict",
                    userData["wDistrict"],
                  ),
                  _buildTextField(
                    "$person City",
                    "wCity",
                    userData["wCity"],
                  ),
                  _buildTextField(
                    "$person Current Address",
                    "wCurrentAddress",
                    userData["wCurrentAddress"],
                  ),
                 
                  _buildContactTextField( "$person Contact Number",
                    "wContact",
                  wContactEditController),
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
      return Column(
        children: [
          Card(
            elevation: 0.7,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                    child: wifeProfilePic == null
                        ? const CircleAvatar(
                            radius: 60,
                            backgroundColor: Color.fromARGB(255, 219, 215, 215),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(wifeProfilePic!)),
                  ),
                  if (headEditedProfilePic != null) ...[
                    TextButton(
                      onPressed: () {
                        _wCropImage();
                      },
                      child: const Text(
                        "Crop Image",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    )
                  ] else
                    TextButton(
                        onPressed: () async {
                          final wSelectedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (wSelectedImage != null) {
                            File wConvertedFile = File(wSelectedImage.path);
                            setState(() {
                              wifeProfilePic = wConvertedFile;
                            });
                          }
                        },
                        child: const Text(
                          "Add Image",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        )),
                  const SizedBox(height: 5),
                  _buildWifeEmptyTextField('Spouse Name', spouseNameController,
                      'wName', validateWifeName),
                  _buildWifeEmptyTextField('Spouse Gotra',
                      spouseGotraController, 'wGotra', validateWifeGotra),
                  _buildWifeEmptyTextField('Spouse Occupation',
                      spouseOccupationController, 'wOccupation', false),
                  _buildWifeEmptyTextField('Spouse Pin Code',
                      spousePinCodeController, 'wPinCode', false),
                  _buildWifeEmptyTextField(
                      'Spouse State', spouseStateController, 'wState', false),
                  _buildWifeEmptyTextField('Spouse District',
                      spouseDistrictController, 'wDistrict', false),
                  _buildWifeEmptyTextField(
                      'Spouse City', spouseCityController, 'wCity', false),
                  _buildContactTextField('Spouse Contact',
                       'wContact', spouseContactController),
                  _buildWifeEmptyTextField('Spouse Birthplace',
                      spouseBirthPlaceController, 'wBirthPlace', false),
                  _buildWifeEmptyTextField('Spouse CurrentAddress',
                      spouseCurrentAddressController, 'wCurrentAddress', false),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }


   Widget _buildContactTextField(String label, String field,  TextEditingController controller) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          // initialValue: initialValue ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(0, 0, 0, 1),
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelText: label,
            labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 1)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 168, 162, 162),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 168, 162, 162),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: (value) {
            String hEditedContact = hContactEditController.text.trim();
            String wEditedContact = wContactEditController.text.trim();
            String spouseContact = spouseContactController.text.trim();
            hEditedContact = "+91$hEditedContact";
            wEditedContact = "+91$wEditedContact";
            spouseContact = "+91$spouseContact";
            
              if(controller == hContactEditController){
                editedData[field] = hEditedContact;
              }else if(controller == wContactEditController){
                editedData[field] = wEditedContact;
              }else if(controller == spouseContactController){
                editedData[field] = spouseContact;
              }
            
          },
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }


  _buildWifeEmptyTextField(String label, TextEditingController controller,
      String field, bool validate) {
    return Column(
      children: [
        TextField(
          cursorColor: Colors.black,
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 168, 162, 162),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 168, 162, 162),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: label,
            labelStyle: const TextStyle(
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
            editedData[field] = value.capitalize ?? "";
            // if (validateForm()) {
            //   editedData[field] = value.capitalize ?? "";
            // }
          },
        ),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget _buildTextField(String label, String field, String? initialValue) {
    return Column(
      children: [
        TextFormField(
          initialValue: initialValue ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(0, 0, 0, 1),
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelText: label,
            labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 1)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 168, 162, 162),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 168, 162, 162),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onChanged: (value) {
            editedData[field] = value.capitalizeFirst ?? "";
          },
        ),
        const SizedBox(
          height: 10,
        )
      ],
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

  Widget _buildCancelButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
          side: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0),
      child: const Text(
        "Cancel",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShowData())),
                });
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      child: const Text(
        "Update",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
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
