import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/user_authentication/utils.dart';

import '../errorpage.dart';

class editDialog extends StatefulWidget {
  const editDialog({Key? key}) : super(key: key);

  @override
  State<editDialog> createState() => _editDialogState();
}

class _editDialogState extends State<editDialog> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isEditingEmail = false;
  bool _isEditingName = false;
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Widget _email() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: _emailController,
        enabled: _isEditingEmail,
        decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Please write your email';
          }
          if (EmailValidator.validate(value)==false){
            return "Please write a valid email";
          }
          return null;
        },
      ),
    );
  }

  Widget _changeEmail(){
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isEditingEmail==false) ... [
              TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
                onPressed: (){
                  setState(() {
                    _isEditingEmail=!_isEditingEmail;
                  });
                }, 
                child: const Text("Edit", style: TextStyle(color: Colors.white),)
              )
            ] else ... [
              TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
                onPressed: (){
                  setState(() {
                    _isEditingEmail=!_isEditingEmail;
                  });
                }, 
                child: const Text("Cancel", style: TextStyle(color: Colors.white),)
              ),
              const SizedBox(width: 15),
              TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
                onPressed: (){
                  _updateEmail(_passwordController.text.trim(),_emailController.text.trim());
                  setState(() {
                    _isEditingEmail=!_isEditingEmail;
                  });
                }, 
                child: const Text("Done", style: TextStyle(color: Colors.white),)
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _changeName(){
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isEditingName==false) ... [
              TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
                onPressed: (){
                  setState(() {
                    _isEditingName=!_isEditingName;
                  });
                }, 
                child: const Text("Edit", style: TextStyle(color: Colors.white),)
              )
            ] else ... [
              TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
                onPressed: () {
                  setState(() {
                    _isEditingName=!_isEditingName;
                  });
                }, 
                child: const Text("Cancel", style: TextStyle(color: Colors.white),)
              ),
              const SizedBox(width: 15),
              TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.teal)),
                onPressed: (){
                  _updateName(_nameController.text.trim());
                  setState(() {
                    _isEditingName=!_isEditingName;
                  });
                }, 
                child: const Text("Done", style: TextStyle(color: Colors.white),)
              )
            ]
          ],
        ),
      ),
    );
  }

  void _updateName(String value) async {    
    try {
      await firestore.collection('patient_users').doc(user!.uid).update({
        'Name': value,
      });
      FirebaseFirestore.instance
      .collection('message_server')
      .where('patient', isEqualTo: user!.uid)
      .get()
      .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'patient_name': value});
        }
      });
    } on FirebaseException catch (e) {
      Utils.showSnackbar(e.message);
    }
  }

  void _updateEmail(String pw, String newEmail) async {
    final credential = EmailAuthProvider.credential(email: user!.email!, password: pw);
    try {
      await user!.reauthenticateWithCredential(credential);
      await user!.updateEmail(newEmail);
      await user!.sendEmailVerification();
      await firestore.collection('patient_users').doc(user!.uid).update({
        'Email': newEmail,
      });
    } on FirebaseException catch (e) {
      Utils.showSnackbar(e.message);
    }
  }

  Widget _name() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: _nameController,
        enabled: _isEditingName,
        decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Please write your name.';
          }
          return null;
        },
      ),
    );
  }

  Widget _password() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        obscureText: true,
        controller: _passwordController,
        decoration: const InputDecoration(labelText: 'Password', errorMaxLines: 2, border: OutlineInputBorder()),
        validator: (String? value) {
          RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>_-]).{5,}$');
          if (value!.isEmpty) {
            return 'Please write your password.';
          }
          if (!regex.hasMatch(value)){
            return "Enter valid password. Password requires minimun 1 uppercase, lowercase, numeric number, special character and minimum of 12 characters in total.";
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DocumentReference documentReference = firestore.collection('patient_users').doc(user!.uid);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: StreamBuilder<DocumentSnapshot?>(
          stream: documentReference.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorPage();
            }
            else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            else {
              final DocumentSnapshot<Object?>? documentSnapshot = snapshot.data;
              _nameController.text = documentSnapshot!['Name'];
              _emailController.text = documentSnapshot['Email'];
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Center(
                        child: Text("Change User Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      _name(),
                      _changeName(),
                      if (_isEditingEmail==false) ... [
                        _email(),
                        _changeEmail()
                      ] else ... [
                        _email(),
                        _password(),
                        _changeEmail(),
                      ],
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              );
            }
          },
        )
      ),
    );
  }
}