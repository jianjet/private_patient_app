import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../user_authentication/utils.dart';

class GoalsList extends StatefulWidget {
  String goal;
  int time;
  int goalSetTime;
  bool goalStatus;
  GoalsList({
    required this.goal,
    required this.time,
    required this.goalSetTime,
    required this.goalStatus,
    Key? key
    }) : super(key: key);

  @override
  State<GoalsList> createState() => _GoalsListState();
}

class _GoalsListState extends State<GoalsList> {

  late String _date;
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(widget.time);
    _date = DateFormat("dd/MM/yyyy").format(time);
    super.initState();
  }

  Future _goalCompleted() async {
    try {
      await firestore.collection('goals_server').doc(user!.uid).collection('completed').add({
        'goal': widget.goal,
        'time': widget.time,
        'goal_set_time': widget.goalSetTime
      });
      await firestore.collection('goals_server').doc(user!.uid).update({
        'completed': FieldValue.increment(1)
      });
    } on FirebaseException catch (e){
      Utils.showSnackbar(e.message);
    }
  }

  Future _goalDelete() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('goals_server')
        .doc(user!.uid)
        .collection('ongoing')
        .where('goal_set_time', isEqualTo: widget.goalSetTime)
        .get();
      List<DocumentSnapshot> docs = snapshot.docs;
      for (DocumentSnapshot doc in docs) {
        await doc.reference.delete();
      }
      await firestore.collection('goals_server').doc(user!.uid).update({
        'ongoing': FieldValue.increment(-1)
      });
    } on FirebaseException catch (e){
      Utils.showSnackbar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(border: Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 0.5
        )
      )),
      child: GestureDetector(
        onTap: (){
          
        },
        child: Container(
          padding: const EdgeInsets.only(left: 5,right: 16,top: 10,bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Icon(
                      widget.goalStatus ? Icons.checklist : Icons.crisis_alert, 
                      size: 50,
                    ),
                    const SizedBox(width: 16,),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.goal, style: const TextStyle(fontSize: 16),),
                            const SizedBox(height: 6,),
                            Text('Due: $_date',style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                          ],
                        ),
                      ),
                    ),
                    if (widget.goalStatus==true) ... []
                    else ... [
                      TextButton(
                        onPressed: (){
                          _goalCompleted();
                          _goalDelete();
                        }, 
                        child: const Icon(Icons.check, size: 50, color: Colors.green,)
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: (){
                          _goalDelete();
                        }, 
                        child: const Icon(Icons.close_rounded, size: 50, color: Colors.red,)
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}