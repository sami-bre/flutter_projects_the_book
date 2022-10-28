import 'package:events/screens/event_screen.dart';
import 'package:events/screens/launch_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

Future<void> testData() async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var data = (await db.collection("event_details").get()).docs;
  data.forEach((element) {
    print(element.id);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LaunchScreen(),
    );
  }
}
