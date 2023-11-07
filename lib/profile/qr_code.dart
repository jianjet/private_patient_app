import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:patient_app/classes_enums_dicts/roles_enum.dart';
import 'package:patient_app/profile/encryption.dart';
import 'package:patient_app/utils.dart';
import '../errorpage.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QR extends StatefulWidget {
  const QR({Key? key}) : super(key: key);
  @override
  State<QR> createState() => QRState();
}

class QRState extends State<QR> {
  
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  AESEncryptionForPatientId encryption = AESEncryptionForPatientId();
  bool requestStatus = false;
  
  Widget _girlIconImage(){
    return Container(
      margin: const EdgeInsets.only(top: 30),
      height: 130,
      width: 130,
      child: Image.asset(
        "./image/girl_icon.png", 
        fit: BoxFit.cover),
    );
  }

  Widget _text2(String words, double size, double marginTop, double marginBottom, bool x, Color y){
    return Container(
      margin: EdgeInsets.only(left: 10, top: marginTop, bottom: marginBottom),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          words, style: TextStyle(fontSize: size, color: y,fontWeight: x ? FontWeight.bold : FontWeight.normal)
        ),
      )
    );
  }

  Widget _details(String name, String ic){
    //Stream here
    return Column(
      children: [
        _text2(name, 20, 10, 0, true, Colors.black),
        _text2('40 years, Female', 15, 5, 0, false, (Colors.grey[600])!),
        _text2('IC: $ic', 15, 5, 5, false, (Colors.grey[600])!),
      ],
    );
  } 

  Widget _qrgen(String rn){
    return Column(
      children: [
        _text2('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', 20, 10, 0, true, (Colors.grey[400])!),
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 25),
          child: QrImage(
            data: rn,
            version: QrVersions.auto,
            size: 250.0,
          ),
        ),
        //_text2('RN number: $patientDataRequestLogId', 15, 5, 30, false, (Colors.grey[600])!),
        _text2('Scan QR to get patient data!', 15, 5, 30, false, (Colors.grey[600])!),
      ],
    );
  }

  Future<Map<String, String>> _loadData() async {
    String patientName = "";
    String icNumber = "";
    String patientDataRequestLogId = "";
    try {
      final DocumentSnapshot document = await firestore.collection('patient_users').doc(user!.uid).get();
      if (document.exists){
        final data = document.data() as Map<String, dynamic>;
        patientName = data['Name'];
        icNumber = data['IC'];
      }
      QuerySnapshot querySnapshot = await firestore.collection('PatientDataRequestLog').where('PatientId', isEqualTo: user!.uid).get();
      if (querySnapshot.docs.isEmpty){
        CollectionReference collection = firestore.collection('PatientDataRequestLog');
        DocumentReference documentRef = await collection.add({
          "UnderRequest": false,
          'PatientId': user!.uid,
        });
        patientDataRequestLogId = documentRef.id;
      } else {
        patientDataRequestLogId = querySnapshot.docs.first.id;
      }
    } on FirebaseException catch (e) {
      Utils.showSnackbar(e.message);
    }
    return {
      'PatientName': patientName,
      'ICNumber': icNumber,
      'PatientDataRequestLogId': patientDataRequestLogId,
    };
  }

  void _checknderRequestStatus(String patientDataRequestLogId) {
    WidgetsBinding.instance.addPostFrameCallback((_){
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Approve doctor?'),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await firestore.collection('PatientDataRequestLog').doc(patientDataRequestLogId).update({
                    'UnderRequest' : false,
                  });
                  final CollectionReference collection = firestore.collection('PatientDataRequestLog').doc(patientDataRequestLogId).collection('Logs');
                  QuerySnapshot querySnapshot = await collection.where('ApprovalStatus', isEqualTo: ApprovalStatus.pending.name).get();
                  if (querySnapshot.docs.isNotEmpty){
                    DocumentReference documentReference = querySnapshot.docs.first.reference;
                    await documentReference.update({
                      'ApprovalStatus': ApprovalStatus.approved.name,
                    });
                  }
                  Utils.showSnackbar("Doctor approved.");
                  Navigator.of(context).pop();
                }, 
                child: const Text("Approve")
              ),
              ElevatedButton(
                onPressed: () async {
                  await firestore.collection('PatientDataRequestLog').doc(patientDataRequestLogId).update({
                    'UnderRequest' : false,
                  });
                  final CollectionReference collection = firestore.collection('PatientDataRequestLog').doc(patientDataRequestLogId).collection('Logs');
                  QuerySnapshot querySnapshot = await collection.where('ApprovalStatus', isEqualTo: ApprovalStatus.pending.name).get();
                  if (querySnapshot.docs.isNotEmpty){
                    DocumentReference documentReference = querySnapshot.docs.first.reference;
                    await documentReference.update({
                      'ApprovalStatus': ApprovalStatus.rejected.name,
                    });
                  }
                  Utils.showSnackbar("Doctor rejected.");
                  Navigator.of(context).pop();
                }, 
                child: const Text("Reject")
              )
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Data'),
      ),
      body: FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError){
            return const ErrorPage();
          } else {
            Map<String, String> data = snapshot.data!;
            var encryptedValue = encryption.encryptMsg(user!.uid).base64;
            return StreamBuilder(
              stream: firestore.collection('PatientDataRequestLog').doc(data['PatientDataRequestLogId']).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const ErrorPage();
                }
                else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                else if (snapshot.hasData){
                  final documentData = snapshot.data!.data();
                  requestStatus = documentData!['UnderRequest'];
                  if (requestStatus == true) {
                    _checknderRequestStatus(data['PatientDataRequestLogId']!);
                  }
                }
                var encryptedValue = encryption.encryptMsg(user!.uid).base64;
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(0),
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        _girlIconImage(),
                        _details(data['PatientName']!, data['ICNumber']!),
                        _qrgen(encryptedValue),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      )
    );
  }
}