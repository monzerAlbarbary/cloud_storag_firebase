import 'package:cloud_storg/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAnhwyEgnMgs8bIWPuaDJkk_Noj1bRRmC0',
      appId: '1:486076073048:web:c2deb2a93e0615596bf62d',
      messagingSenderId: '486076073048',
      projectId: 'fir-test-40ebf',
      authDomain: 'fir-test-40ebf.firebaseapp.com',
      storageBucket: 'fir-test-40ebf.appspot.com',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Storage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
