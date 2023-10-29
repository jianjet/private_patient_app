import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/appointment/appointment_completed_list.dart';
import 'package:patient_app/appointment/appointment_dialog.dart';
import 'package:patient_app/appointment/appointment_list.dart';
import '../errorpage.dart';

class Appointment extends StatefulWidget {
  Appointment({
    Key? key
    }) : super(key: key);
  @override
  AppointmentState createState() => AppointmentState();
}

class AppointmentState extends State<Appointment> with TickerProviderStateMixin {

  final user = FirebaseAuth.instance.currentUser!;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  Widget _doctorAppointmentList(bool status){
    return Container(
      margin: const EdgeInsets.all(0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection('appointment_server')
          .where('patient_uid', isEqualTo: user.uid)
          .where('booking_status', isEqualTo: status)
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
          else if (!snapshot.hasData){
            return Container();
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(top: 0),
              itemBuilder: ((context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                return AppointmentList(
                  name: document['doctor_name'], 
                  service: document['service'],
                  time: document['appointment_time'],
                  date: document['appointment_date'],
                );
              })
            );
          }
        }
      )
    );
  }

  Widget _doctorAppointmentListCompleted(){
    return Container(
      margin: const EdgeInsets.all(0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection('appointment_server')
          .where('patient_uid', isEqualTo: user.uid)
          .where('complete_status', isEqualTo: true)
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
          else if (!snapshot.hasData){
            return Container();
          }
          else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(top: 0),
              itemBuilder: ((context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                return AppointmentCompletedList(
                  doctorName: document['doctor_name'],
                  service: document['service'],
                  time: document['appointment_time'],
                  date: document['appointment_date'],
                  doctorUid: document['doctor_uid'],
                  patientName: document['patient_name'],
                  rated: document["rated"],
                  documentId: document.id,
                );
              })
            );
          }
        }
      )
    );
  }

  Widget _pendingView(){
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.all(0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _doctorAppointmentList(false)
            ]
          ),
        )
      ),
    );
  }

  Widget _confirmedView(){
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.all(0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _doctorAppointmentList(true)
            ]
          ),
        )
      ),
    );
  }

  Widget _completedView(){
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.all(0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _doctorAppointmentListCompleted()
            ]
          ),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment'),
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) => const AppointmentDialog(),
              );
            }, 
            icon: const Icon(Icons.add)
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: "Pending",),
            Tab(text: "Confirmed",),
            Tab(text: "Completed",)
          ]
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _pendingView(),
          _confirmedView(),
          _completedView()
        ],
      )
    );
  }
}