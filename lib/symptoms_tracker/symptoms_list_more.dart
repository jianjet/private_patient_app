import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../errorpage.dart';
import '../useful_widget.dart';

class SymptomsMore extends StatefulWidget{
  SymptomsMore({Key? key,}) : super(key: key);
  @override
  SymptomsMoreState createState() => SymptomsMoreState();
}

class SymptomsMoreState extends State<SymptomsMore> {

  final user = FirebaseAuth.instance.currentUser;

  Widget _symptomsList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('symptoms_server')
        .doc(user!.uid)
        .collection('symptoms')
        .orderBy('time', descending: true)
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
          final List<String> documentsFieldsWithTrueValues = [];
          for (final QueryDocumentSnapshot<Object?> documentSnapshot in snapshot.data!.docs) {
            final List<String> fieldsWithTrueValues = [];
            final Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
            if (data != null) {
              data.forEach((String key, dynamic value) {
                if (value == true) {
                  fieldsWithTrueValues.add(key);
                }
              });
            }
            final String allSymptoms = fieldsWithTrueValues.join(", ");
            documentsFieldsWithTrueValues.add(allSymptoms);
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              return SymptomsListMore(
                symptoms: documentsFieldsWithTrueValues[index],
                date: document['time'],
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
        title: const Text('Past History of Symptoms'),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              _symptomsList()
            ],
          ),
        )
      ),
    );
  }
}

class SymptomsListMore extends StatefulWidget{
  String symptoms; 
  int date;
  SymptomsListMore({Key? key, 
    required this.symptoms,
    required this.date
  }) : super(key: key);
  @override
  SymptomsListMoreState createState() => SymptomsListMoreState();
}

class SymptomsListMoreState extends State<SymptomsListMore> {

  late String _date;

  @override
  void initState() {
    _getDate();
    super.initState();
  }

  void _getDate(){
    DateTime time= DateTime.fromMillisecondsSinceEpoch(widget.date);
    _date = DateFormat('d MMM yyyy').format(time);
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
          text2(widget.symptoms, 18, 0, 15, false),
        ]
      )
    );
  }
}