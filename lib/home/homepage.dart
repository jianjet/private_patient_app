import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/AddPatientHealthRecord/AddPatientHealthRecord.dart';
import 'package:patient_app/appointment/appointment.dart';
import 'package:patient_app/home/goals_more.dart';
import 'package:patient_app/medicine/search_medicine.dart';
import 'package:patient_app/search_doctors/search_doctors.dart';
import 'package:patient_app/symptoms_tracker/tracker.dart';
import '../errorpage.dart';
import '../useful_widget.dart';
import 'homepage_dialog.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {

  late double _progressValue;
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String _name;
  final _database = FirebaseDatabase.instance.ref();
  Timer? _timer;
  bool _alert = true;

  @override
  void initState(){
    super.initState();
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _alert = false;
      });
    });
  }

  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }

  Widget _topRow(){
    return Container(
      color: Colors.amber[200],
      width: double.infinity,
      child: Visibility(
        visible:  _alert,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.black,),
            Text('This app is not for life-threatening emergency.', style: TextStyle(fontSize: 16, color: Colors.red)),
          ],
        ),
      )
    );
  }

  Widget _girlIconImage(){
    return Container(
      margin: const EdgeInsets.all(1),
      height: 60,
      width: 60,
      child: Image.asset(
        "./image/girl_icon.png", 
        fit: BoxFit.cover),
    );
  }

  Widget _row1Column2(){
    final DocumentReference documentReference = firestore.collection('patient_users').doc(user!.uid);
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<DocumentSnapshot?>(
            stream: documentReference.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const ErrorPage();
              }
              else if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              else {
                final DocumentSnapshot<Object?>? documentSnapshot = snapshot.data;
                _name = documentSnapshot!['Name'];
                return text1('Good day, $_name.',35);
              }
            }
          ),
          text1('How are you feeling today?',15),
        ],
      ),
    );
  }

  Widget _notificationIcon(){
    return Container(
      margin: const EdgeInsets.only(left: 0),
      height: 50,
      width: 50,
      child: Image.asset(
        "./image/notification_icon.png", 
        fit: BoxFit.cover
      ),
    );
  }

  Widget _row1(){
    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _girlIconImage(),
          Expanded(child: _row1Column2()),
          // _notificationIcon()
        ],
      ),
    );
  }

  Widget _row2(){
    return Container(
      margin: const EdgeInsets.only(bottom: 0, left: 10, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: text2('Saturday, 26 November', 20, 0, 0, true)
            )
          ),
          // SizedBox(
          //   height: 20,
          //   width: 80,
          //   child: ElevatedButton(
          //     onPressed: (){
          //       //go to the all health status route
          //     },
          //     child: const Text('View more', style: TextStyle(fontSize: 10))
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _imageHealthStatus(String image){
    return Container(
      margin: const EdgeInsets.all(1),
      height: 90,
      width: 90,
      child: Image.asset(
        image, 
        fit: BoxFit.fill),
    ); 
  }

  Widget _buttonHealthStatus(String picName, String words, String words2){
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: SizedBox(
        width: 156,
        height: 160,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => HomepageDialog(healthField: words2),
            );
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
          ), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _imageHealthStatus(picName),
              Container(
                margin: const EdgeInsets.only(top: 1, bottom: 2),
                child: Text(
                  words, style: const TextStyle(fontSize: 21, color: Colors.black, fontWeight: FontWeight.bold)
                )
              ),
              Container(
                margin: const EdgeInsets.only(top: 1, bottom: 1),
                child: Text(
                  words2, style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.normal)
                )
              ),
            ]
          ),
        )
      ),
    );
  }
  
  Widget _allHealthButton(){
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: StreamBuilder(
        stream: _database.child('HealthData').child(user!.uid).orderByKey().onValue,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> values = snapshot.data!.snapshot.value;
            List<Widget> children = [];
            values.forEach((key, value) {
              children.add(_buttonHealthStatus('./image/$key.png', value, key));
            });
            return Wrap(
              spacing: 8,
              runSpacing: 4,
              children: children,
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }

  Widget _row5(){
    return Container(
      margin: const EdgeInsets.only(bottom: 3, left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: text2('Today\'s Goal', 20, 0, 0, true)
            )
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.indigo[900]
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: ((context) => const GoalsMore())));
            }, 
            child: const Text('View more', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
          )
        ],
      ),
    );
  }

  Widget _row6n7(){
    final DocumentReference documentReference = firestore.collection('goals_server').doc(user!.uid);
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 20, right: 19),
      child: StreamBuilder<DocumentSnapshot?>(
        stream: documentReference.snapshots(),
        builder: (context,  snapshot) {
          if (snapshot.hasData) {
            final DocumentSnapshot<Object?>? documentSnapshot = snapshot.data;
            final int _ongoingNum = documentSnapshot!['ongoing'];
            final int _completedNum = documentSnapshot['completed'];
            if (_ongoingNum+_completedNum!=0){
              _progressValue=_completedNum/(_ongoingNum+_completedNum);
              final double _percentageLeft=double.parse((100-_progressValue*100).toStringAsFixed(1));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 8,
                    margin: const EdgeInsets.only(bottom: 6),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey[400],  
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),  
                      value: _progressValue,
                    ),
                  ),
                  if (_progressValue==1) ... [
                    const Text('Congrats! You\'ve achieved all your goals!', style: TextStyle(fontSize: 11))
                  ] else ... [
                    Text('You\'re almost there! $_percentageLeft% more in achieving your goals.', style: const TextStyle(fontSize: 11))
                  ]
                ]
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 8,
                    margin: const EdgeInsets.only(bottom: 6),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey[400],  
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),  
                      value: 0,
                    ),
                  ),
                  const Text('You have no goals yet. Set a goal!', style: TextStyle(fontSize: 11))
                ]
              );
            }
          }
          else {
            return Container();
          }
        },
      )
    );
  }

  Widget _imageOtherRows(String image){
    return SizedBox(
      height: 50,
      width: 50,
      child: Image.asset(
        image, 
        fit: BoxFit.cover),
    );
  }

  Widget _otherRows(String image, String words, Function() f){
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 15, left: 10, right: 10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
        ),
        onPressed: f,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _imageOtherRows(image),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                child: Text(words, style: const TextStyle(fontSize: 18)),
              )
            ),
            _imageOtherRows('./image/arrow_right.png')
          ],
        ),
      )
    );
  }

  void _pushTracker(){
    Navigator.push(context, MaterialPageRoute(builder: ((context) => const Tracker())));
  }

  void _pushSearchDoctors(){
    Navigator.push(context, MaterialPageRoute(builder: ((context) => const SearchDoctor())));
  }

  void _pushAppointment(){
    Navigator.push(context, MaterialPageRoute(builder: ((context) => Appointment())));
  }

  void _pushMedicine(){
    Navigator.push(context, MaterialPageRoute(builder: ((context) => const SearchMedicine())));
  }

  void _pushAddPatientHealthRecord(){
    Navigator.push(context, MaterialPageRoute(builder: ((context) => AddPatientHealthRecord(patient_uid: user!.uid,))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telemedicine App'),
      ),
      body: CustomScrollView(
        anchor: 0.0,
        slivers: <Widget>[
          silverListConstant(_topRow(), 1),
          silverListConstant(_row1(), 1),
          silverListConstant(_row2(), 1),
          silverListConstant(_allHealthButton(), 1),
          silverListConstant(_row5(), 1),
          silverListConstant(_row6n7(), 1),
          silverListConstant(_otherRows('./image/search_doctor.png', 'Search Doctors', _pushSearchDoctors), 1),
          silverListConstant(_otherRows('./image/tracker_icon.png', 'Symptoms Tracker', _pushTracker), 1),
          silverListConstant(_otherRows('./image/location_icon.png', 'Appointments', _pushAppointment), 1),
          silverListConstant(_otherRows('./image/records.png', 'Health Records', _pushAddPatientHealthRecord), 1),
        ],
      )
    );
  }
}