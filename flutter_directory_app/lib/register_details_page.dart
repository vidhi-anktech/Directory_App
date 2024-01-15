import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

 final TextEditingController headNameController = TextEditingController();
  final TextEditingController headGotraController = TextEditingController();
  final TextEditingController headOccupationController = TextEditingController();
  final TextEditingController headContactController = TextEditingController();
  final TextEditingController headBirthplaceController = TextEditingController();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Family Registration',
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
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildPersonForm("Householder"),
              SizedBox(height: 20),
              _buildPersonForm("Spouse"),
              SizedBox(height: 20),
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
              style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
            ),
            SizedBox(height: 10),
            _buildTextField('$title Name', title == "Householder"
                ? headNameController
                : wifeNameController),
            _buildTextField('$title Gotra', title == "Householder"
                ? headGotraController
                : wifeGotraController),
            _buildTextField('$title Occupation', title == "Householder"
                ? headOccupationController
                : wifeOccupationController),
            _buildTextField('$title Contact', title == "Householder"
                ? headContactController
                : wifeContactController),
            _buildTextField('$title Birthplace', title == "Householder"
                ? headBirthplaceController
                : wifeBirthplaceController),
            _buildTextField('$title CurrentAddress', title == "Householder"
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
      ),
    );
  }

  void _submitForm() {
    // Handle form data submission
    final headData = {
      'Name': headNameController.text,
      'Gotra': headGotraController.text,
      'Occupation': headOccupationController.text,
      'Contact': headContactController.text,
      'Birthplace': headBirthplaceController.text,
      'CurrentAddress': headCurrentAddressController.text,
    };

    final wifeData = {
      'Name': wifeNameController.text,
      'Gotra': wifeGotraController.text,
      'Occupation': wifeOccupationController.text,
      'Contact': wifeContactController.text,
      'Birthplace': wifeBirthplaceController.text,
      'CurrentAddress': wifeCurrentAddressController.text,
    };

    print('Head of the Family: $headData');
    print('Wife: $wifeData');

    // You can save the data or perform other actions here
  }
}
