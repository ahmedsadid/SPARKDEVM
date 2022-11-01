import 'package:auth_service/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth_service/src/service/firebase_auth_service.dart' as fba;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/loginPage.dart';

class UpdateEmailPage extends StatefulWidget {
  static String tag = 'email-change-page';
  @override
  UpdateEmailState createState() => new UpdateEmailState();
}

class UpdateEmailState extends State<UpdateEmailPage> {
  final _formkey = GlobalKey<FormState>();
  final newEmailController = TextEditingController();
  final AuthService _authService =
      FirebaseAuthService(authService: FirebaseAuth.instance);
  final currentUser = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  String errorMessage = 'Error';
  String newEmail = "";

  changeEmail() async {
    try {
      await currentUser?.updateEmail(newEmail);
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Your email address has been Changed. Login again.',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter new email';
        } else if (!value.contains('@')) {
          return 'Please enter a valid email';
        } else if (!value.contains('fiu.edu')) {
          return 'Please use your FIU email address';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      autocorrect: false,
      controller: newEmailController,
      decoration: InputDecoration(
          hintText: 'New Email Address',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
      textInputAction: TextInputAction.next,
    );

    final submitButton = ElevatedButton(
      onPressed: () {
        // Validate returns true if the form is valid, otherwise false.
        if (_formkey.currentState!.validate()) {
          setState(() {
            newEmail = newEmailController.text;
          });
          changeEmail();
        }
      },
      child: Text(
        'Submit',
        style: TextStyle(fontSize: 18.0),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: _formkey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[SizedBox(height: 12.0), email, submitButton],
            ),
          ),
        ));
  }
}
