import 'package:events/screens/event_screen.dart';
import 'package:events/screens/login_screen.dart';
import 'package:events/shared/authentition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    Authentication auth = Authentication();
    auth.getUser().then((value) {
      MaterialPageRoute route;
      if (value != null) {
        route = MaterialPageRoute(
          builder: (context) => EventScreen(value.uid),
        );
      } else {
        route = MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      }
      Navigator.of(context).pushReplacement(route);
    }).catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CircularProgressIndicator(),
    );
  }
}
