import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import '../../utils.dart';

class MakeAppointment extends StatefulWidget {
  String doctorName;
  String doctorUid;
  MakeAppointment({
    Key? key,
    required this.doctorName,
    required this.doctorUid
    }) : super(key: key);

  @override
  State<MakeAppointment> createState() => _MakeAppointmentState();
}

class _MakeAppointmentState extends State<MakeAppointment> {
  
  String _date = "Not set";
  String _time = "Not set";
  DateTime _now = DateTime.now();
  late String _doctorName;
  late String _patientName;
  late String _doctorUid;
  TextEditingController _serviceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _doctorName = widget.doctorName;
    _doctorUid = widget.doctorUid;
    _getName();
    super.initState();
  }

  @override
  void dispose() {
    _serviceController.dispose();
    super.dispose();
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

  Widget _pickDate(){
    return ElevatedButton(
      onPressed: (){
        DatePicker.showDatePicker(
          context,
          theme: const DatePickerTheme(containerHeight: 210),
          showTitleActions: true,
          minTime: _now,
          maxTime: DateTime(_now.year+10, _now.month, _now.day),
          onConfirm: (time) {
            setState(() {
              _date = DateFormat("dd/MM/yyyy").format(time);
            });
          },
          currentTime: DateTime.now(), 
          locale: LocaleType.en
        );
      }, 
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            const Icon(
              Icons.date_range,
              size: 18.0,
              color: Colors.white,
            ),
            Expanded(
              child: Text(" $_date", style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
            const Text("Change", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
          ],
        ),
      )
    );
  }

  Widget _pickTime(){
    return ElevatedButton(
      onPressed: (){
        DatePicker.showTime12hPicker(
          context,
          theme: const DatePickerTheme(containerHeight: 210),
          showTitleActions: true,
          onConfirm: (time) {
            setState(() {
              _time = DateFormat().add_jm().format(time);
            });
          },
          currentTime: DateTime.now(), 
          locale: LocaleType.en
        );
      }, 
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 18.0,
              color: Colors.white,
            ),
            Expanded(
              child: Text(" $_time", style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 18.0)),
            ),
            const Text("Change", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
          ],
        ),
      )
    );
  }

  Widget _doctorIconImage(){
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 200,
      width: 200,
      child: Image.asset(
        "./image/doctor_icon.png", 
        fit: BoxFit.cover),
    );
  }

  Widget _service() {
    return TextFormField(
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
    );
  }

  Future _findAppointment() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final uid = user!.uid;
      await firestore.collection('appointment_server').add({
        'patient_uid': uid,
        'patient_name': _patientName,
        'doctor_name': _doctorName,
        'doctor_uid': _doctorUid,
        'appointment_date': _date,
        'appointment_time': _time,
        'service': _serviceController.text.trim(),
        'booking_datetime': DateTime.now().millisecondsSinceEpoch,
        'booking_status': false,

      });
    } on FirebaseException catch (e){
      Utils.showSnackbar(e.message);
    }
  }

  Widget _submitAppointment(){
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
      ),
      onPressed: (){
        _findAppointment();
        _serviceController.clear();
        setState(() {
          _date = "Not set";
          _time = "Not set";
        });
      }, 
      child: const Text("Submit", style: TextStyle(color: Colors.white),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Book Appointment with $_doctorName',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _doctorIconImage(),
                  _pickDate(),
                  const SizedBox(height: 10),
                  _pickTime(),
                  const SizedBox(height: 10),
                  _service(),
                  const SizedBox(height: 10),
                  _submitAppointment()
                ],
              ),
            )
          ),
        )
      ),
    );
  }
}