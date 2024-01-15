import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _validate = false;

final heheController = TextEditingController();
  final TextEditingController headNameController = TextEditingController();
  final TextEditingController headGotraController = TextEditingController();
  final TextEditingController headOccupationController =
      TextEditingController();
  final TextEditingController headContactController = TextEditingController();
  final TextEditingController headBirthplaceController =
      TextEditingController();
  final TextEditingController headCurrentAddressController =
      TextEditingController();
  File? headImage;

  final TextEditingController wifeNameController = TextEditingController();
  final TextEditingController wifeGotraController = TextEditingController();
  final TextEditingController wifeOccupationController =
      TextEditingController();
  final TextEditingController wifeContactController = TextEditingController();
  final TextEditingController wifeBirthplaceController =
      TextEditingController();
  final TextEditingController wifeCurrentAddressController =
      TextEditingController();
  File? wifeImage;

  final _imagePicker = ImagePicker();

  final border = const OutlineInputBorder(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(5)));

  @override
  void dispose() {
    super.dispose();
  }

  void clearRegScreen(){
    headNameController.clear();
    headGotraController.clear();
    headOccupationController.clear();
    headContactController.clear();
    headBirthplaceController.clear();
    headCurrentAddressController.clear();
    headImage=null;
     wifeNameController.clear();
    wifeGotraController.clear();
    wifeOccupationController.clear();
    wifeContactController.clear();
    wifeBirthplaceController.clear();
    wifeCurrentAddressController.clear();
    wifeImage=null;
  }

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildPersonForm("Householder"),
              const SizedBox(height: 20),
              _buildPersonForm("Spouse"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  backgroundColor: const Color.fromARGB(255, 109, 158, 243),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonForm(String title) {
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
            _buildImagePicker('$title Photo',
                title == "Householder" ? headImage : wifeImage, (file) {
              setState(() {
                if (title == "Householder") {
                  headImage = file;
                } else {
                  wifeImage = file;
                }
              });
            }),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      cursorColor: Colors.black,
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        errorText: _validate && controller.text.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildImagePicker(
      String label, File? image, void Function(File?) onImageSelected) {
    return Column(
      children: [
        image != null
            ? Image.network(
                image.path,
                height: 100,
                width: 100,
              )
            : const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Upload coloured photograph',
                  errorText: _validate && image == null ? 'Required' : null,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.upload_file),
                    onPressed: () {
                      _pickImage(onImageSelected);
                    },
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue[800],
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(10))),
              child: IconButton(
                icon: const Icon(
                  Icons.photo,
                  color: Colors.white,
                ),
                onPressed: () {
                  _captureImage(onImageSelected);
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  Future<void> _pickImage(void Function(File?) onImageSelected) async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    onImageSelected(File(pickedFile!.path));
  }

  Future<void> _captureImage(void Function(File?) onImageSelected) async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    onImageSelected(File(pickedFile!.path));
  }

  void _submitForm() {
    setState(() {
      _validate = true;
      clearRegScreen();
    });

    if (_validateForm()) {
      // Handle form data submission
      final headData = {
        'Name': headNameController.text,
        'Gotra': headGotraController.text,
        'Occupation': headOccupationController.text,
        'Contact': headContactController.text,
        'Birthplace': headBirthplaceController.text,
        'CurrentAddress': headCurrentAddressController.text,
        'Photo': headImage?.path,
      };

      final wifeData = {
        'Name': wifeNameController.text,
        'Gotra': wifeGotraController.text,
        'Occupation': wifeOccupationController.text,
        'Contact': wifeContactController.text,
        'Birthplace': wifeBirthplaceController.text,
        'CurrentAddress': wifeCurrentAddressController.text,
        'Photo': wifeImage?.path,
      };

      print('Head of the Family: $headData');
      print('Wife: $wifeData');

      // You can save the data or perform other actions here
    }
  }

  bool _validateForm() {
    return headNameController.text.isNotEmpty &&
        headGotraController.text.isNotEmpty &&
        headOccupationController.text.isNotEmpty &&
        headContactController.text.isNotEmpty &&
        headBirthplaceController.text.isNotEmpty &&
        headCurrentAddressController.text.isNotEmpty &&
        wifeNameController.text.isNotEmpty &&
        wifeGotraController.text.isNotEmpty &&
        wifeOccupationController.text.isNotEmpty &&
        wifeContactController.text.isNotEmpty &&
        wifeBirthplaceController.text.isNotEmpty &&
        wifeCurrentAddressController.text.isNotEmpty &&
        headImage != null &&
        wifeImage != null;
  }
}
