import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/profile.dart';
import 'package:flutter_directory_app/show_data.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends ConsumerStatefulWidget {
  RegistrationPage({
    super.key,
  });

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final snackBar = SnackBar(
    content: Text('Oops! Something went wrong'),
  );
  bool validate = false;
  bool _loading = false;
  bool validateHeadName = false;
  bool validateHeadGotra = false;
  bool validateHeadContact = false;
  bool validatePin = false;

  final TextEditingController headNameController = TextEditingController();

  final TextEditingController headGotraController = TextEditingController();

  final TextEditingController headOccupationController =
      TextEditingController();

  final TextEditingController headContactController = TextEditingController();

  final TextEditingController headBirthplaceController =
      TextEditingController();

  final TextEditingController headCityPinController = TextEditingController();

  final TextEditingController headCityController = TextEditingController();

  final TextEditingController headDistrictController = TextEditingController();

  final TextEditingController headStateController = TextEditingController();

  final TextEditingController headCurrentAddressController =
      TextEditingController();

  final TextEditingController wifeNameController = TextEditingController();

  final TextEditingController wifeGotraController = TextEditingController();

  final TextEditingController wifeOccupationController =
      TextEditingController();

  final TextEditingController wifeContactController = TextEditingController();

  final TextEditingController wifeBirthplaceController =
      TextEditingController();
  final TextEditingController wifeCityPinController = TextEditingController();
  final TextEditingController wifeCityController = TextEditingController();
  final TextEditingController wifeDistrictController = TextEditingController();
  final TextEditingController wifeStateController = TextEditingController();
  final TextEditingController wifeCurrentAddressController =
      TextEditingController();
  final textController = TextEditingController();

  File? headProfilePic;
  File? wifeProfilePic;

  String pinCodeDetails = "";

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
    hello() async {
      var sharedPref = await SharedPreferences.getInstance();
      var checkNum = sharedPref.getString(MyAppState.PHONENUM);
      print(
          "SHARED PREFERENCE CALLED AT BUILD CONTEXT OF REGISTRATION PAGE $checkNum");
    }

    hello();

    return Scaffold(
      appBar: AppBar(),
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
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(children: [
                  const Row(
                    children: [
                      Text(
                        'Head of the family/Husband',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 0.7,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundColor:
                                  Color.fromARGB(255, 168, 162, 162),
                              child: GestureDetector(
                                onTap: () async {
                                  final hSelectedImage = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (hSelectedImage != null) {
                                    File convertedFile =
                                        File(hSelectedImage.path);

                                    // Crop feature for convertedFile of householder

                                    setState(() {
                                      headProfilePic = convertedFile;
                                    });
                                    print("Image selected");
                                  } else {
                                    print("No image selected");
                                  }
                                },
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    const Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.person_add,
                                          size: 30,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: CircleAvatar(
                                        radius: 58.0,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: headProfilePic != null
                                            ? FileImage(headProfilePic!)
                                            : null,
                                        child: const Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 18.0,
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: 20.0,
                                              color: Color(0xFF404040),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (headProfilePic != null) ...[
                          IconButton(
                              onPressed: () {
                                _cropImage();
                              },
                              icon: const Icon(Icons.crop))
                        ],
                        const SizedBox(height: 10),
                        _buildPersonForm("Householder"),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                Column(
                  children: [
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text(
                          'Spouse',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 0.7,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundColor:
                                    const Color.fromARGB(255, 168, 162, 162),
                                child: GestureDetector(
                                  onTap: () async {
                                    final wSelectedImage = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (wSelectedImage != null) {
                                      File wConvertedFile =
                                          File(wSelectedImage.path);
                                      setState(() {
                                        wifeProfilePic = wConvertedFile;
                                        print("setstate triggered");
                                      });
                                      print("Image selected");
                                    } else {
                                      print("No image selected");
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      const Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.person_add,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: CircleAvatar(
                                          radius: 58.0,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                              wifeProfilePic != null
                                                  ? FileImage(wifeProfilePic!)
                                                  : null,
                                          child: const Align(
                                            alignment: Alignment.bottomRight,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 18.0,
                                              child: Icon(
                                                Icons.camera_alt,
                                                size: 20.0,
                                                color: Color(0xFF404040),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (wifeProfilePic != null) ...[
                            IconButton(
                                onPressed: () {
                                  _wCropImage();
                                },
                                icon: const Icon(Icons.crop))
                          ],
                          const SizedBox(height: 10),
                          _buildPersonForm("Spouse"),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // _buildRegisterNowButton(),

                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(flex: 3, child: _buildCancelButton()),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(flex: 3, child: _buildRegisterNowButton()),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          )),
    );
  }

  Future _cropImage() async {
    print('CROP IMAGE METHOD CALLED');
    if (headProfilePic != null) {
      CroppedFile? cropped = await ImageCropper()
          .cropImage(sourcePath: headProfilePic!.path, aspectRatioPresets: [
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
          headProfilePic = File(cropped.path);
        });
      }
    }
  }

  Future _wCropImage() async {
    print('CROP IMAGE METHOD CALLED');
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

  _buildRegisterNowButton() {
    return ElevatedButton(
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
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      child: const Text(
        "Save",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
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

  _buildPersonForm(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildTextField(
              '$title Name',
              title == "Householder" ? headNameController : wifeNameController,
              title == "Householder" ? validateHeadName : false,
              false),
          _buildTextField(
              '$title Gotra',
              title == "Householder"
                  ? headGotraController
                  : wifeGotraController,
              title == "Householder" ? validateHeadGotra : false,
              false),
          _buildTextField(
              '$title Occupation',
              title == "Householder"
                  ? headOccupationController
                  : wifeOccupationController,
              false,
              false),
          _buildTextField(
              '$title Contact',
              title == "Householder"
                  ? headContactController
                  : wifeContactController,
              title == "Householder" ? validateHeadContact : false,
              false),
          _buildTextField(
              '$title Birthplace',
              title == "Householder"
                  ? headBirthplaceController
                  : wifeBirthplaceController,
              false,
              false),
          _buildZipCodeTextField(
            '$title Zip-code',
            title == 'Householder'
                ? headCityPinController
                : wifeCityPinController,
            title == "Householder" ? validatePin : false,
          ),
          _buildTextField(
              '$title City',
              title == 'Householder' ? headCityController : wifeCityController,
              false,
              false),
          _buildTextField(
              '$title District',
              title == 'Householder'
                  ? headDistrictController
                  : wifeDistrictController,
              false,
              false),
          _buildTextField(
              '$title State',
              title == 'Householder'
                  ? headStateController
                  : wifeStateController,
              false,
              false),
          _buildTextField(
              '$title CurrentAddress',
              title == "Householder"
                  ? headCurrentAddressController
                  : wifeCurrentAddressController,
              false,
              false),
        ],
      ),
    );
  }

  _buildZipCodeTextField(
    String label,
    TextEditingController controller,
    bool validate,
  ) {
    return Column(
      children: [
        TextField(
          cursorColor: Colors.black,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 1)),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 168, 162, 162)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 168, 162, 162)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: validate ? 'Required' : null,
            errorStyle:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
          onChanged: (value) {
            if (value.length == 6) {
              getDataFromPinCode(value, label);
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  _buildTextField(
    String label,
    TextEditingController controller,
    bool validate,
    bool showSuffixIcon,
  ) {
    return Column(
      children: [
        TextField(
          cursorColor: Colors.black,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 1)),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 168, 162, 162)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 168, 162, 162)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: validate ? 'Required' : null,
            errorStyle:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
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
      String hPinCode = headCityPinController.text.trim();
      String hState = headStateController.text.trim();
      String hDistrict = headDistrictController.text.trim();
      String hCity = headCityController.text.trim();
      String hCurrentAddress = headCurrentAddressController.text.trim();
      String wName = wifeNameController.text.trim();
      String wGotra = wifeGotraController.text.trim();
      String wOccupation = wifeOccupationController.text.trim();
      String wContactString = wifeContactController.text.trim();
      String wBirthplace = wifeBirthplaceController.text.trim();
      String wPinCode = wifeCityPinController.text.trim();
      String wState = wifeStateController.text.trim();
      String wDistrict = wifeDistrictController.text.trim();
      String wCity = wifeCityController.text.trim();
      String wCurrentAddress = wifeCurrentAddressController.text.trim();

      String hContact = "+91$hContactString";
      String wContact = "+91$wContactString";

      if (hName.isNotEmpty && hGotra.isNotEmpty && headProfilePic != null) {
        final headDownloadUrl =
            await uploadFile(headProfilePic!, "headProfilePictures");
        String? wifeDownloadUrl;

        if (wifeProfilePic != null) {
          wifeDownloadUrl =
              await uploadFile(wifeProfilePic!, "wifeProfilePictures");
        }

        Map<String, dynamic> userData = {
          "hProfilePic": headDownloadUrl,
          "hName": hName.capitalizeFirst,
          "hGotra": hGotra.capitalizeFirst,
          "hOccupation": hOccupation.capitalizeFirst,
          "hContact": hContact,
          "hBirthPlace": hBirthplace.capitalizeFirst,
          "hPinCode": hPinCode,
          "hState": hState.capitalizeFirst,
          "hDistrict": hDistrict.capitalizeFirst,
          "hCity": hCity.capitalizeFirst,
          "hCurrentAddress": hCurrentAddress.capitalizeFirst,
          if (wifeDownloadUrl != null) ...{
            "wProfilePic": wifeDownloadUrl,
            "wName": wName.capitalizeFirst,
            "wGotra": wGotra.capitalizeFirst,
            "wOccupation": wOccupation.capitalizeFirst,
            "wContact": wContact,
            "wBirthPlace": wBirthplace.capitalizeFirst,
            "wPinCode": wPinCode,
            "wState": wState.capitalizeFirst,
            "wDistrict": wDistrict.capitalizeFirst,
            "wCity": wCity.capitalizeFirst,
            "wCurrentAddress": wCurrentAddress.capitalizeFirst,
          } else ...{
            "wProfilePic": null,
            "wName": null,
            "wGotra": null,
            "wOccupation": null,
            "wContact": null,
            "wBirthPlace": null,
            "wPinCode": null,
            "wState": null,
            "wDistrict": null,
            "wCity": null,
            "wCurrentAddress": null,
          },
          "addedBy": showNum,
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
      'hPinCode': headCityPinController.text.trim(),
      'hState': headStateController.text.trim(),
      'hCity': headCityController.text.trim(),
    };
    final wifeData = {
      'wName': wifeNameController.text.trim(),
      'wGotra': wifeGotraController.text.trim(),
      'wOccupation': wifeOccupationController.text.trim(),
      'wContactString': wifeContactController.text.trim(),
      'wBirthplace': wifeBirthplaceController.text.trim(),
      'wCurrentAddress': wifeCurrentAddressController.text.trim(),
      'wPinCode': wifeCityPinController.text.trim(),
      'wState': wifeStateController.text.trim(),
      'wCity': wifeCityController.text.trim(),
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
    headCityPinController.clear();
    headStateController.clear();
    headDistrictController.clear();
    headCityController.clear();
    headCurrentAddressController.clear();
    wifeNameController.clear();
    wifeGotraController.clear();
    wifeOccupationController.clear();
    wifeContactController.clear();
    wifeBirthplaceController.clear();
    wifeCityPinController.clear();
    wifeStateController.clear();
    wifeDistrictController.clear();
    wifeCityController.clear();
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
        return SizedBox(
          height: 50,
          width: 50,
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
    validateHeadName = headNameController.text.isEmpty;
    validateHeadGotra = headGotraController.text.isEmpty;
    validateHeadContact = headContactController.text.isEmpty;
    validatePin = headCityPinController.text.isEmpty;

    return !validateHeadName &&
        !validateHeadGotra &&
        !validateHeadContact &&
        !validatePin;
  }

  Future<void> getDataFromPinCode(String pinCode, String title) async {
    final url = "http://www.postalpincode.in/api/pincode/$pinCode";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['Status'] == 'Error') {
          showSnackbar(context, "Pin Code is not valid. ");
          setState(() {
            pinCodeDetails = 'Pin code is not valid.';
          });
        } else {
          final postOfficeArray = jsonResponse['PostOffice'] as List;
          final obj = postOfficeArray[0];

          final district = obj['District'];
          final state = obj['State'];
          final city = obj['Name'];

          setState(() {
            pinCodeDetails =
                'Details of pin code are:\nDistrict: $district\nState: $state';

            print("PINCODE DETAILS ARE: $pinCodeDetails");
            if (title == "Householder Pincode") {
              headDistrictController.text = district;
              headStateController.text = state;
              headCityController.text = city;
            } else {
              wifeDistrictController.text = district;
              wifeStateController.text = state;
              wifeCityController.text = city;
            }
          });
        }
      } else {
        showSnackbar(context, "Failed to fetch data. Please try again");
        setState(() {
          pinCodeDetails = 'Failed to fetch data. Please try again.';
        });
      }
    } catch (e) {
      showSnackbar(context, "Error Occurred. Please try again");
      setState(() {
        pinCodeDetails = 'Error occurred. Please try again.';
      });
    }
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
