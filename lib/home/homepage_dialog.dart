import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/user_authentication/utils.dart';

class HomepageDialog extends StatefulWidget {
  String healthField;
  HomepageDialog({
    required this.healthField,
    Key? key
  }) : super(key: key);

  @override
  State<HomepageDialog> createState() => HomepageDialogState();
}

class HomepageDialogState extends State<HomepageDialog> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _healthDataController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;
  late String _label;

  @override
  void initState() {
    _label = _labelText();
    super.initState();
  }

  Future<void> _updateOrCreateField(String key, dynamic value) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    final userRef = databaseRef.child('HealthData').child(user!.uid);
    try {
      DatabaseEvent event = await userRef.once();
      if (event.snapshot.value == null) {
        await userRef.set({key : value});
      } else {
        await userRef.update({key : value});
      }
    } on FirebaseException catch(e) {
      Utils.showSnackbar(e.message);
    }
    Navigator.of(context).pop();
  }

  String _labelText(){
    String x='';
    switch (widget.healthField){
      case 'BMI': {x='e.g. 36.2';}
      break;
      case 'Heart Rate': {x='e.g. 78 bpm';}
      break;
      case 'Blood Pressure': {x='e.g. 132/85';}
      break;
      case 'Sleep': {x='e.g. 8 hrs';}
      break;
      case 'Steps': {x='e.g. 3680/day';}
      break;
      case 'Mood': {x='e.g. 4/5';}
      break;
    }
    return x;
  }

  Widget _healthData() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextFormField(
        controller: _healthDataController,
        decoration: const InputDecoration(
          labelText: 'Data',
          border: OutlineInputBorder()
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Please write the health data. $_label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(widget.healthField, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                _healthData(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _updateOrCreateField(widget.healthField,_healthDataController.text.trim());
                    },
                    child: const Text('Done'),
                  )
                )
              ]
            ),
          )
        ),
      ),
    );
  }
}