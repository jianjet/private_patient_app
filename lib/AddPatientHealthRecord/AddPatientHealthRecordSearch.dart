import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/AddPatientHealthRecord/AddPatientHealthRecordList.dart';
import '../errorpage.dart';

class AddPatientHealthRecordSearch extends StatefulWidget {
  const AddPatientHealthRecordSearch({super.key});

  @override
  State<AddPatientHealthRecordSearch> createState() => _AddPatientHealthRecordSearchState();
}

class _AddPatientHealthRecordSearchState extends State<AddPatientHealthRecordSearch> {

  final user = FirebaseAuth.instance.currentUser!;

  Widget _patientList(){
    return Container(
      margin: const EdgeInsets.all(0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection('message_server')
          .where('doctor', isEqualTo: user.uid)
          .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (snapshot.hasError){
            return const ErrorPage();
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 0),
              itemBuilder: ((context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                return AddPatientHealthRecordList(
                  patient_uid: document['patient'],
                );
              })
            );
          }
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
      ),
      body: SafeArea(
        child: _patientList()
      ),
    );
  }
}