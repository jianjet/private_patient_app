import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../utils.dart';

class AppointmentDialog extends StatefulWidget {
  const AppointmentDialog({Key? key}) : super(key: key);

  @override
  State<AppointmentDialog> createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {

  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();
  bool _showDate = false;
  late String _patientName;
  TextEditingController _serviceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _getName();
    super.initState();
  }

  Future<void> _getName() async {
    try {
      final doc = await firestore.collection('patient_users').doc(user!.uid).get();
      final data = doc.data() as Map<String, dynamic>;
      _patientName = data['Name'];
    } on FirebaseException catch(e){
      Utils.showSnackbar(e.message);
    }
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

  _showTime(){
    DatePicker.showTime12hPicker(
      context,
      showTitleActions: true,
      onChanged: (time){
        setState(() {
          _selectedTime=time;
        });
      },
      onConfirm: (time) {
        setState(() {
          _selectedTime=time;
          _showDate=!_showDate;
        });
      },
    );
  }

  Widget _timeAndTextButton(String text){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        const SizedBox(width: 4,),
        TextButton(
          onPressed: (){
            _showTime();
          }, 
          child: Text(DateFormat().add_jm().format(_selectedTime))
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
          });
          _showTime();
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

  Widget _service() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextFormField(
        controller: _serviceController,
        decoration: const InputDecoration(
          labelText: 'Service required',
          border: OutlineInputBorder()
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Please write why you need to see a doctor.';
          }
          return null;
        },
      ),
    );
  }

  Widget _doctorIconImage(){
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.all(1),
        height: 120,
        width: 120,
        child: Image.asset(
          "./image/doctor_icon.png", 
          fit: BoxFit.cover),
      ),
    );
  }

  Future _findAppointment() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    try {
      await firestore.collection('appointment_server').add({
        'patient_uid': user!.uid,
        'patient_name': _patientName,
        'doctor_uid': 'Unconfirmed',
        'doctor_name': "Unconfirmed",
        'appointment_date': DateFormat('dd/MM/yyyy').format(_selectedDate),
        'appointment_time': DateFormat().add_jm().format(_selectedTime),
        'service': _serviceController.text.trim(),
        'booking_datetime': DateTime.now().millisecondsSinceEpoch,
        'booking_status': false
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
                  child: Text("Book Appointment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const SizedBox(height: 20),
                _doctorIconImage(),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Wrap(
                    spacing: 50,
                    children: [
                      _dateAndTextButton("Date:"),
                      _timeAndTextButton('Time:')
                    ]
                  ),
                ),
                if (_showDate==true) ... [_showDateWidget()],
                _service(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, right: 20),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, 
                          child: const Text("Cancel")
                        ),
                        TextButton(
                          onPressed: (){
                            _findAppointment();
                          }, 
                          child: const Text("Submit")
                        )
                      ],
                    ),
                  )
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}