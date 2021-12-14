import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Button extends StatefulWidget {
  Button(this.title, this.icn);
  String title;
  IconData icn;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late File _imageFile;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => pickImage(),
      child: Container(
        height: 50,
        width: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icn, color: Colors.white),
            SizedBox(width: 10),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  final picker = ImagePicker();

  Future pickImage() async {
    print("pickImage");

    await picker.getImage(source: ImageSource.gallery).then((pickedFile) {
      setState(() {
        _imageFile = File(pickedFile!.path);
      });

      uploadImageToFirebase();
    });
  }

  Future uploadImageToFirebase() async {
    String fileName = _imageFile.path.split('/').last;

    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then((value) {
      print("Done!!!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Uploading Done!"),
      ));
    });
  }
}
