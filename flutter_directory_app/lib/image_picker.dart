import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImagePickereg extends StatefulWidget {
  const ImagePickereg({super.key});

  @override
  State<ImagePickereg> createState() => _ImagePickeregState();
}

class _ImagePickeregState extends State<ImagePickereg> {
  File? _image;

  Future getImage(ImageSource source) async{
    try{
    final image = await ImagePicker().pickImage(source: source);

    if(image == null) return;

    // final imageTemporary = File(image.path);
    final imagePermanent = await saveFilePermanently(image.path);

    setState(() {
      this._image = imagePermanent;
    });
    } on PlatformException catch (e){
      print("Failed to pick an image: $e");
    }
  }

  Future<File> saveFilePermanently(String imagePath) async{
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

  return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          _image!=null ? Image.network(_image!.path,
          width:250,
          height: 250,
          fit: BoxFit.cover,
          ) :
          Image.network(
            "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aHVtYW58ZW58MHx8MHx8fDA%3D",
            width: 300,
            height: 300,
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: (){
              getImage(ImageSource.gallery);
            },
            child: Text(
              "choose from gallery",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              backgroundColor: const Color.fromARGB(255, 109, 158, 243),
              foregroundColor: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              getImage(ImageSource.camera);
            },
            child: Text(
              "choose from Camera",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              backgroundColor: const Color.fromARGB(255, 109, 158, 243),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    ));
  }
}
