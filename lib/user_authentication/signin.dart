import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/main.dart';
import 'package:patient_app/user_authentication/forgot_pw.dart';
import 'package:patient_app/user_authentication/signup.dart';
import 'package:patient_app/utils.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
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

  Widget _password() {
    return TextFormField(
      obscureText: true,
      controller: passwordController,
      decoration: const InputDecoration(labelText: 'Password'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please write your password.';
        }
        return null;
      },
      onSaved: (String? value) {
      },
    );
  }

  Future _signIn() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context, 
      builder: (context) => const Center(child: CircularProgressIndicator())
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e){
      Utils.showSnackbar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Widget _signInButton(){
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.lock_open, size: 32),
        onPressed: () {
          _signIn();
        },
        label: const Text('Sign In', style: TextStyle(fontSize: 24))),
      );
  }

  void _pushSignUp(){
    Navigator.push(context, MaterialPageRoute(builder: ((context) => const SignUp())));
  }

  Widget _signup(){
    return TextButton(
      onPressed: () {
        _pushSignUp();
      }, 
      child: const Text("Sign up", style: TextStyle(decoration: TextDecoration.underline),)
    );
  }

  void _pushForgotPassword(){
    Navigator.push(context, MaterialPageRoute(builder: ((context) => const ForgotPW())));
  }

  Widget _forgotPW(){
    return TextButton(
      onPressed: () {
        _pushForgotPassword();
      }, 
      child: const Text("Forgot password?", style: TextStyle(decoration: TextDecoration.underline),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _email(),
              _password(),
              _signInButton(),
              _forgotPW(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No account?"),
                  _signup()
                ],
              ),
              const Text("patient")
            ],
          ),
        ),
      )
    );
  }
}