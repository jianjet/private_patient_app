import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../utils.dart';
import 'package:flutter/material.dart';

class GoalsDialog extends StatefulWidget {
  const GoalsDialog({Key? key}) : super(key: key);

  @override
  State<GoalsDialog> createState() => _GoalsDialogState();
}

class _GoalsDialogState extends State<GoalsDialog> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _goalController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _showDate = false;
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Widget _goal() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextFormField(
        controller: _goalController,
        decoration: const InputDecoration(
          labelText: 'Goals',
          border: OutlineInputBorder()
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Please write your goals.';
          }
          return null;
        },
      ),
    );
  }

  Widget _dateAndTextButton(String text){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        const SizedBox(width: 4,),
        TextButton(
          onPressed: () {
            setState(() {
              _showDate=!_showDate;
            });
          }, 
          child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate))
        )
      ],
    );
  }

  Widget _showDateWidget(){
    return SfDateRangePicker(
      view: DateRangePickerView.month,
      selectionMode: DateRangePickerSelectionMode.single,
      navigationDirection: DateRangePickerNavigationDirection.horizontal,
      showNavigationArrow: true,
      enablePastDates : false,
      showActionButtons: true,
      cancelText: 'Cancel',
      confirmText: 'Confirm',
      onSubmit: (value){
        if (value is DateTime){
          setState(() {
            _selectedDate = value;
            _showDate=!_showDate;
          });
        }
        else {
          Utils.showSnackbar("Error");
        }
      },
      onCancel: () {
        setState(() {
          _showDate=!_showDate;
        });
      },
    );
  }

  Future _setGoals() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    try {
      await firestore.collection('goals_server').doc(user!.uid).collection('ongoing').add({
        'goal': _goalController.text.trim(),
        'time': _selectedDate.millisecondsSinceEpoch,
        'goal_set_time': DateTime.now().millisecondsSinceEpoch
      });
      await firestore.collection('goals_server').doc(user!.uid).update({
        'ongoing': FieldValue.increment(1)
      });
    } on FirebaseException catch (e){
      Utils.showSnackbar(e.message);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Center(
                  child: Text("Write Goals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                _goal(),
                _dateAndTextButton("Due Date:"),
                if (_showDate==true) ... [_showDateWidget()],
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, 
                        child: const Text("Cancel")
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _setGoals();
                        }, 
                        child: const Text("Submit")
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}