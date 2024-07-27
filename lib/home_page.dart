import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  io.File? image;
  final picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  String? webImage;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        if (kIsWeb) {
          webImage = pickedFile.path;
        } else {
          image = io.File(pickedFile.path);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadImage() async {
    if (image != null || webImage != null) {
      final String fileName =
          'uploads/${DateTime.now().millisecondsSinceEpoch}.png';
      try {
        if (kIsWeb) {
          // Upload image for web
          await storage.ref(fileName).putFile(io.File(webImage!));
        } else {
          // Upload image for mobile
          await storage.ref(fileName).putFile(image!);
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Upload successful')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    }
  }

  Future<List<String>> loadImages() async {
    ListResult result = await storage.ref('uploads').listAll();
    List<String> urls = [];
    for (var ref in result.items) {
      String url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase Storage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (kIsWeb)
              webImage == null
                  ? Text('No image selected.')
                  : Image.network(webImage!)
            else
              image == null ? Text('No image selected.') : Image.file(image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadImage,
              child: Text('Upload Image'),
            ),
            FutureBuilder<List<String>>(
              future: loadImages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        return Image.network(snapshot.data![index]);
                      },
                    ),
                  );
                } else {
                  return Text('No images found.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
