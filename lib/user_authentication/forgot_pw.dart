import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/user_authentication/utils.dart';
import '../main.dart';

class ForgotPW extends StatefulWidget {
  const ForgotPW({Key? key}) : super(key: key);
  @override
  ForgotPWState createState() => ForgotPWState();
}

class ForgotPWState extends State<ForgotPW> {

  final emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }

  Widget _email() {
    return TextFormField(
      controller: emailController,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please write your email';
        }
        if (EmailValidator.validate(value)==false){
          return "Please write a valid email";
        }
        return null;
      },
      onSaved: (String? value) {
      },
    );
  }

  Future _forgotPassword() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context, 
      builder: (context) => const Center(child: CircularProgressIndicator())
    );
    
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackbar('Password Reset Email Sent.');
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e){
      Utils.showSnackbar(e.message);
      Navigator.of(context).pop();
    }
  }

  Widget _forgotPWButton(){
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.email_outlined, size: 32),
        onPressed: () {
          _forgotPassword();
        },
        label: const Text('Reset Password', style: TextStyle(fontSize: 24))),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              _email(),
              _forgotPWButton()
            ],
          ),
        )
      )
    );
  }
}