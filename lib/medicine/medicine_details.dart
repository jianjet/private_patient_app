import 'dart:developer';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/search_doctors/call/pages/call.dart';
import 'package:patient_app/search_doctors/chat/message.dart';
import 'package:patient_app/search_doctors/make_appointment/make_appointment.dart';
import 'package:patient_app/search_doctors/make_appointment/physical_visit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../errorpage.dart';

class MedicineDetails extends StatefulWidget {
  String doctor_uid;
  String doctor_name;
  String about;
  MedicineDetails({
    required this.about,
    required this.doctor_name,
    required this.doctor_uid,
    Key? key
    }) : super(key: key);
  @override
  MedicineDetailsState createState() => MedicineDetailsState();
}

class MedicineDetailsState extends State<MedicineDetails> {

  late String groupChatId;
  late String combiID;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference messageServerCollection = FirebaseFirestore.instance.collection("message_server");

  Future<void> _checkIfGroupExists(String groupChatId) async {
    final DocumentReference grpRef = FirebaseFirestore.instance.collection('message_server').doc(groupChatId);
    final DocumentSnapshot snapshot = await grpRef.get();
    final pdocumentSnapshot = await firestore.collection('patient_users').doc(user.uid).get();
    final pdata = pdocumentSnapshot.data();
    final String patient_name = pdata!['Name'];
    final ddocumentSnapshot = await firestore.collection('doctor_users').doc(widget.doctor_uid).get();
    final ddata = ddocumentSnapshot.data();
    final String doctor_name = ddata!['Name'];
    if (snapshot.exists==false){
      await firestore.collection('message_server').doc(groupChatId).set({
        'doctor':widget.doctor_uid,
        'patient':user.uid,
        'doctor_name': doctor_name,
        'patient_name': patient_name
      });
    }
  }

  Future<void> _onJoin(String combiID) async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    await Navigator.push(context, MaterialPageRoute(builder: ((context) => Call(channelName: 'telemed', role: ClientRole.Broadcaster))));
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    log(status.toString()); //see whether the request is allowed or not
  }

  Widget _girlIconImage(){
    return Container(
      height: 200,
      width: 200,
      child: Image.asset(
        "./image/girl_icon.png", 
        fit: BoxFit.cover),
    );
  }

  Widget _buttonChat(){
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: ElevatedButton(
        onPressed: () {
          combiID=widget.doctor_uid+user.uid;
          groupChatId=combiID;
          _checkIfGroupExists(groupChatId);
          Navigator.push(context, MaterialPageRoute(builder: ((context) => Message(ChatId: groupChatId, doctor_name: widget.doctor_name, doctor_uid: widget.doctor_uid,))));
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(const CircleBorder()),
          padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
          backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) return Colors.blue[50]; // <-- Splash color
          }),
        ),
        child: const Icon(Icons.message),
      ),
    );
  }

  Widget _buttonAppointment(){
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) => MakeAppointment(doctorName: widget.doctor_name, doctorUid: widget.doctor_uid,))));
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(const CircleBorder()),
          padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
          backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) return Colors.blue[50]; // <-- Splash color
          }),
        ),
        child: const Icon(Icons.calendar_month),
      ),
    );
  }

  Widget _buttonCall(){
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: ElevatedButton(
        onPressed: () {
          combiID=widget.doctor_uid+user.uid;
          _onJoin(combiID);
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(const CircleBorder()),
          padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
          backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) return Colors.blue[50]; // <-- Splash color
          }),
        ),
        child: const Icon(Icons.call),
      ),
    );
  }

  Widget _buttonVisit(){
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: ((context) => PhysicalVisit(doctorName: widget.doctor_name, doctorUid: widget.doctor_uid,))));
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all(const CircleBorder()),
          padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
          backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) return Colors.blue[50]; // <-- Splash color
          }),
        ),
        child: const Icon(Icons.add_location_outlined),
      ),
    );
  }

  Widget _textAll(String words, double size, double marginTop, double marginBottom, bool x){
    return Container(
      margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
        child: Text(
          words, style: TextStyle(fontSize: size, fontWeight: x ? FontWeight.bold : FontWeight.normal)
        )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final DocumentReference documentReference = firestore.collection('doctor_users').doc(widget.doctor_uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Details'),
      ),
      body: StreamBuilder<DocumentSnapshot?>(
        stream: documentReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage();
          }
          else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasData){
            final DocumentSnapshot<Object?>? documentSnapshot = snapshot.data;
            final String name = documentSnapshot!['Name'];
            final String about = documentSnapshot['About'];
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _girlIconImage(),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 15,
                          children: [
                            _buttonAppointment(),
                            _buttonChat(),
                            _buttonCall(),
                            _buttonVisit()
                          ],
                        ),
                        _textAll(name, 30, 20, 5, true),
                        _textAll(about, 18, 5, 10, false)
                      ]
                    ),
                  )
                )
              ),
            );
          }
          return const ErrorPage();
        }
      )
    );
  }
}

