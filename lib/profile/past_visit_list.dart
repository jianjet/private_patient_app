import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../errorpage.dart';
import '../useful_widget.dart';

class PastVisitMore extends StatefulWidget{
  PastVisitMore({Key? key,}) : super(key: key);
  @override
  PastVisitMoreState createState() => PastVisitMoreState();
}

class PastVisitMoreState extends State<PastVisitMore> {

  final user = FirebaseAuth.instance.currentUser;

  Widget _pastVisitList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('doctor_visit_server')
        .where('patient_uid', isEqualTo: user!.uid)
        .orderBy('visit_time')
        .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else if (snapshot.hasError){
          return const ErrorPage();
        }
        else if (!snapshot.hasData){
          return Container();
        }
        else {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 0),
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              return PastVisitListMore(
                date: document['visit_time'],
                place: document['visit_place'],
                illness: document['illness'],
                medications: document['medications'],
                doctor_name: document['doctor_name'],
              );
            },
          );
        }
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History of Doctor Visits'),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              _pastVisitList()
            ],
          ),
        )
      ),
    );
  }
}

class PastVisitListMore extends StatefulWidget{
  String place; 
  int date;
  String illness;
  String medications;
  String doctor_name;
  PastVisitListMore({Key? key, 
    required this.place,
    required this.date,
    required this.doctor_name,
    required this.illness,
    required this.medications
  }) : super(key: key);
  @override
  PastVisitListMoreState createState() => PastVisitListMoreState();
}

class PastVisitListMoreState extends State<PastVisitListMore> {

  late String _date;

  @override
  void initState() {
    _getDate();
    super.initState();
  }

  void _getDate(){
    DateTime time= DateTime.fromMillisecondsSinceEpoch(widget.date);
    _date = DateFormat('E, d MMM yyyy').add_jm().format(time);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      padding: const EdgeInsets.only(bottom: 15),
      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      child: Column(
        children: [
          text2(_date, 23, 5, 5, true),
          text2(widget.place, 18, 0, 15, false),
          text2('Sickness: ${widget.illness}', 16, 0, 2, false),
          text2('Medications: ${widget.medications}', 16, 0, 2, false),
          text2('Doctor: ${widget.doctor_name}', 16, 0, 2, false),
        ]
      )
    );
  }
}