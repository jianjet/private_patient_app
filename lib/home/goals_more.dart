import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/home/goals_dialog.dart';
import 'package:patient_app/home/goals_list.dart';
import '../errorpage.dart';

class GoalsMore extends StatefulWidget {
  const GoalsMore({Key? key}) : super(key: key);

  @override
  State<GoalsMore> createState() => _GoalsMoreState();
}

class _GoalsMoreState extends State<GoalsMore> with TickerProviderStateMixin {

  late TabController _tabController;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget _goalList(String status, bool goal_status){
    return Container(
      margin: const EdgeInsets.all(0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
        .collection('goals_server')
        .doc(user.uid)
        .collection(status)
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
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(top: 0),
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                return GoalsList(
                  goal: document['goal'], 
                  time: document['time'],
                  goalSetTime: document['goal_set_time'],
                  goalStatus: goal_status
                );
              },
            );
          }
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (context) => const GoalsDialog(),
              );
            }, 
            icon: const Icon(Icons.add)
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: "Ongoing",),
            Tab(text: "Completed",)
          ]
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _goalList('ongoing', false),
          _goalList('completed', true)
        ],
      )
    );
  }
}