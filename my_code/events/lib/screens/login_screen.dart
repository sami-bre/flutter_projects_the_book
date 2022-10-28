import 'package:events/screens/event_screen.dart';
import 'package:events/shared/authentition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  String _userId = '';
  String _email = '';
  String _password = '';
  String _message = '';
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  late Authentication auth;

  @override
  void initState() {
    auth = Authentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Container(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                emailInput(),
                passwordInput(),
                mainButton(),
                secondaryButton(),
                validationMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: TextFormField(
        controller: txtEmail,
        keyboardType: TextInputType.emailAddress,
        decoration:
            const InputDecoration(hintText: 'email', icon: Icon(Icons.mail)),
        validator: (value) =>
            (value == null || value.isEmpty) ? "Email is required" : null,
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: txtPassword,
        obscureText: true,
        decoration: const InputDecoration(
            hintText: 'Password', icon: Icon(Icons.enhanced_encryption)),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Password is required.' : null,
      ),
    );
  }

  Widget mainButton() {
    String buttonText = _isLogin ? 'Login' : 'Sign up';
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        height: 50,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
            backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.secondary,
            ),
            elevation: MaterialStateProperty.all(3),
          ),
          onPressed: submit,
          child: Text(buttonText),
        ),
      ),
    );
  }

  Widget secondaryButton() {
    String buttonText = _isLogin ? 'Sign up' : 'Login';
    return TextButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
      child: Text(buttonText),
    );
  }

  Widget validationMessage() {
    return Text(
      _message,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void submit() async {
    setState(() {
      _message = "";
    });
    String? _userId;
    try {
      if (_isLogin) {
        _userId = await auth.login(txtEmail.text, txtPassword.text);
        print("Login for user $_userId");
      } else {
        _userId = await auth.signUp(txtEmail.text, txtPassword.text);
        print('Sigh up for user $_userId');
      }
      if (_userId != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EventScreen(_userId!),
            ));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _message = e.message!;
      });
    }
  }
}
