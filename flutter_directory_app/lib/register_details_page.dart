import 'dart:async';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class RegistrationPage extends ConsumerStatefulWidget {
   RegistrationPage({super.key, 
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
    
 hello() async {
      var sharedPref = await SharedPreferences.getInstance();
      var checkNum = sharedPref.getString(MyAppState.PHONENUM);
      print("SHARED PREFERENCE CALLED AT BUILD CONTEXT OF REGISTRATION PAGE $checkNum");
    }

    hello();

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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final hSelectedImage =
                        await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (hSelectedImage != null) {
                      File convertedFile = File(hSelectedImage.path);
                
                      // Crop feature for convertedFile of householder
                
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
                if(headProfilePic!=null)...[
                   IconButton(onPressed: (){
                    _cropImage();
                   }, 
                  icon: const Icon(Icons.crop))
                ]
              ],
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
            Column(
              children: [
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
                   if(wifeProfilePic!=null)...[
                   IconButton(onPressed: (){
                    _wCropImage();
                   }, 
                  icon: const Icon(Icons.crop))
                ],
              ],
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

   
  Future _cropImage() async { 
    print('CROP IMAGE METHOD CALLED');
    if (headProfilePic != null) { 
      CroppedFile? cropped = await ImageCropper().cropImage( 
          sourcePath: headProfilePic!.path, 
          aspectRatioPresets:  
               [ 
                  CropAspectRatioPreset.square, 
                  CropAspectRatioPreset.ratio3x2, 
                  CropAspectRatioPreset.original, 
                  CropAspectRatioPreset.ratio4x3, 
                  CropAspectRatioPreset.ratio16x9 
                ] ,
               
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
          headProfilePic = File(cropped.path); 
        }); 
      } 
    } 
  } 

Future _wCropImage() async { 
    print('CROP IMAGE METHOD CALLED');
    if (wifeProfilePic != null) { 
      CroppedFile? cropped = await ImageCropper().cropImage( 
          sourcePath: wifeProfilePic!.path, 
          aspectRatioPresets:  
               [ 
                  CropAspectRatioPreset.square, 
                  CropAspectRatioPreset.ratio3x2, 
                  CropAspectRatioPreset.original, 
                  CropAspectRatioPreset.ratio4x3, 
                  CropAspectRatioPreset.ratio16x9 
                ] ,
               
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
          wifeProfilePic = File(cropped.path); 
        }); 
      } 
    } 
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
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            _buildTextField(
                '$title Name',
                title == "Householder"
                    ? headNameController
                    : wifeNameController,
                    title == "Householder" ? validateHeadName : false),
            _buildTextField(
                '$title Gotra',
                title == "Householder"
                    ? headGotraController
                    : wifeGotraController,
                      title == "Householder" ? validateHeadGotra : false,),
            _buildTextField(
                '$title Occupation',
                title == "Householder"
                    ? headOccupationController
                    : wifeOccupationController,
                       false,),
            _buildTextField(
                '$title Contact',
                title == "Householder"
                    ? headContactController
                    : wifeContactController,
                       title == "Householder" ? validateHeadContact : false,),
            _buildTextField(
                '$title Birthplace',
                title == "Householder"
                    ? headBirthplaceController
                    : wifeBirthplaceController,
                      false,),
            _buildTextField(
                '$title CurrentAddress',
                title == "Householder"
                    ? headCurrentAddressController
                    : wifeCurrentAddressController,
                      false,),
          ],
        ),
      ),
    );
  }

  _buildTextField(String label, TextEditingController controller, bool validate) {
    return TextField(
      cursorColor: Colors.black,
      controller: controller,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(1.0))),
        hintText: label,
        hintStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        errorText: validate ? 'Required' : null,
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
        headProfilePic != null ) {
      final headDownloadUrl =
          await uploadFile(headProfilePic!, "headProfilePictures");
     String? wifeDownloadUrl;

         if (wifeProfilePic != null) {
      wifeDownloadUrl = await uploadFile(wifeProfilePic!, "wifeProfilePictures");
    }

      Map<String, dynamic> userData = {
        "hProfilePic": headDownloadUrl,
        "hName": hName.capitalizeFirst,
        "hGotra": hGotra.capitalizeFirst,
        "hOccupation": hOccupation.capitalizeFirst,
        "hContact": hContact,
        "hBirthPlace": hBirthplace.capitalizeFirst,
        "hCurrentAddress": hCurrentAddress.capitalizeFirst,
         if (wifeDownloadUrl != null ) ...{
        "wProfilePic": wifeDownloadUrl,
        "wName": wName.capitalizeFirst,
        "wGotra": wGotra.capitalizeFirst,
        "wOccupation": wOccupation.capitalizeFirst,
        "wContact": wContact,
        "wBirthPlace": wBirthplace.capitalizeFirst,
        "wCurrentAddress": wCurrentAddress.capitalizeFirst,
      }
      else ...{
        "wProfilePic": null,
        "wName": null,
        "wGotra": null,
        "wOccupation":null,
        "wContact": null,
        "wBirthPlace": null,
        "wCurrentAddress": null,
      },
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
  validateHeadName = headNameController.text.isEmpty;
    validateHeadGotra = headGotraController.text.isEmpty;
    validateHeadContact = headContactController.text.isEmpty;

    return !validateHeadName && !validateHeadGotra && !validateHeadContact;
}

}
