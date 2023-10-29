import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        _text2('IC: $ic-XX-XXXX', 15, 5, 5, false, (Colors.grey[600])!),
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
        _text2('RN number: $rn', 15, 5, 30, false, (Colors.grey[600])!),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final DocumentReference documentReference = firestore.collection('patient_users').doc(user!.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Data'),
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
            final String _name = documentSnapshot!['Name'];
            String _ic = documentSnapshot['IC'];
            var _hashIC = _ic.hashCode.toString();
            print(_hashIC);
            _ic = _ic.substring(0,6);
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(0),
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    _girlIconImage(),
                    _details(_name, _ic),
                    _qrgen(_hashIC),
                  ],
                ),
              ),
            );
          }
          return const ErrorPage();
        },
      )
    );
  }
}