import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/classes_enums_dicts/patient_health_record.dart';
import 'package:patient_app/profile/encryption.dart';
import 'package:patient_app/utils.dart';

class AddPatientHealthRecord extends StatefulWidget {
  String patient_uid;

  AddPatientHealthRecord({
    required this.patient_uid,
    Key? key
    }) : super(key: key);
  @override
  AddPatientHealthRecordState createState() => AddPatientHealthRecordState();
}

class AddPatientHealthRecordState extends State<AddPatientHealthRecord> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  final TextEditingController _ethnicController = TextEditingController();
  final TextEditingController _icNoController = TextEditingController();

  final firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final User? user = FirebaseAuth.instance.currentUser;
  AESEncryptionForPatientHealthRecords encryption = AESEncryptionForPatientHealthRecords();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bmiController.dispose();
    _ethnicController.dispose();
    _icNoController.dispose();
    super.dispose();
  }

  Widget _nameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Name'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter the user\'s name.';
        }
        return null;
      },
    );
  }

  Widget _ageField() {
    return TextFormField(
      controller: _ageController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(labelText: 'Age'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter the user\'s age.';
        }
        // You can add additional validation for age, e.g., to ensure it's a valid number.
        return null;
      },
    );
  }

  Widget _genderField() {
    return TextFormField(
      controller: _genderController,
      decoration: const InputDecoration(labelText: 'Gender'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter the user\'s gender.';
        }
        return null;
      },
    );
  }

  Widget _heightField() {
    return TextFormField(
      controller: _heightController,
      decoration: const InputDecoration(labelText: 'Height'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter the user\'s height.';
        }
        // You can add additional validation for height, e.g., to ensure it's a valid number.
        return null;
      },
    );
  }

  Widget _weightField() {
    return TextFormField(
      controller: _weightController,
      decoration: const InputDecoration(labelText: 'Weight'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter the user\'s weight.';
        }
        // You can add additional validation for weight, e.g., to ensure it's a valid number.
        return null;
      },
    );
  }

  Widget _bmiField() {
    return TextFormField(
      controller: _bmiController,
      decoration: const InputDecoration(labelText: 'BMI'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter the user\'s BMI.';
        }
        // You can add additional validation for BMI, e.g., to ensure it's a valid number.
        return null;
      },
    );
  }

  Widget _ethnicField() {
    return TextFormField(
      controller: _ethnicController,
      decoration: const InputDecoration(labelText: 'Ethnicity'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter the user\'s ethnicity.';
        }
        return null;
      },
    );
  }

  Widget _icNoField() {
    return TextFormField(
      controller: _icNoController,
      decoration: const InputDecoration(labelText: 'IC Number'),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter the user\'s IC number.';
        }
        return null;
      },
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context, 
      builder: (context) => const Center(child: CircularProgressIndicator())
    );
    try {
      BasicInfo basicInfo = BasicInfo(
        name: _nameController.text.trim(),
        age: _ageController.text.trim(),
        gender: _genderController.text.trim(),
        height: _heightController.text.trim(),
        weight: _weightController.text.trim(),
        bmi: _bmiController.text.trim(),
        ethnic: _ethnicController.text.trim(),
        icNo: _icNoController.text.trim(),
      );
      String basicInfoJsonString = json.encode(basicInfo.toJson());
      String encryptedData = encryption.encryptMsg(basicInfoJsonString).base64;
      CollectionReference collection = firestore.collection('PatientsHealthRecord');
      // Set the document with the patient ID as the document ID
      await collection.doc(user!.uid).set({
        'EncryptedJsonData': encryptedData,
        'PatientId' : user!.uid
      });
      
    } on FirebaseException catch (e){
      Utils.showSnackbar(e.message);
    }
    Navigator.of(context).pop();
  }

  Widget _submitButton(){
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        onPressed: () {
          _submit();
        },
        child: const Text('Submit', style: TextStyle(fontSize: 24))),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Patient Health Records'),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _nameField(),
                  _ageField(),
                  _genderField(),
                  _heightField(),
                  _weightField(),
                  _bmiField(),
                  _ethnicField(),
                  _icNoField(),
                  _submitButton()
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}