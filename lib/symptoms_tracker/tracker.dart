import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:patient_app/symptoms_tracker/symptoms_list.dart';
import 'package:patient_app/symptoms_tracker/symptoms_list_more.dart';
import '../errorpage.dart';
import 'moreSymptoms.dart';
import 'package:flutter/material.dart';
import '../useful_widget.dart';
import '../classes_enums_dicts/diff_symptoms.dart';

DiffSymptoms records = DiffSymptoms();

class Tracker extends StatefulWidget {
  const Tracker({Key? key}) : super(key: key);

  @override
  TrackerState createState() => TrackerState();
}

class TrackerState extends State<Tracker>{

  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  
  Widget _imageSymptoms(String image){
    return SizedBox(
      height: 90,
      width: 90,
      child: Image.asset(
        image, 
        //fit: BoxFit.fill
      ),
    );
  }

  Widget _buttonSymptoms(String picName, String words, bool buttonState, Function f){
    return SizedBox(
      width: 160,
      height: 160,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            buttonState=!buttonState;
            f(buttonState);
          });
        },
        style: ButtonStyle(
          backgroundColor: buttonState ? MaterialStateProperty.all(Colors.amber[200]) : MaterialStateProperty.all(Colors.blue[50]),
          padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
        ), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _imageSymptoms(picName),
            Text(
              words, style: const TextStyle(fontSize: 17, color: Colors.black)
            ),
          ],
        )
      )
    );
  }

  Widget _moreButton(String picName, String words, var buttonState, Function f){
    return SizedBox(
      width: 160,
      height: 160,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const MoreSypmtoms()),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue[50]),
          padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
        ), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _imageSymptoms(picName),
            Text(
              words, style: const TextStyle(fontSize: 17, color: Colors.black)
            ),
          ],
        )
      )
    );
  }

  Widget _allSymptomsButton(){
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _buttonSymptoms('./image/fs.png', 'Face swelling', records.getsFS, records.setsFS),
          _buttonSymptoms('./image/dob.png', 'Diffculty of\nbreathing', records.getsDOB, records.setsDOB),
          _buttonSymptoms('./image/loa.png', 'Loss of\nappetite', records.getsLOA, records.setsLOA),
          _buttonSymptoms('./image/c.png', 'Confusion', records.getsC, records.setsC),
          _buttonSymptoms('./image/ls.png', 'Leg\nswollen', records.getsLS, records.setsLS),
          _buttonSymptoms('./image/cpp.png', 'Chess pain/\npressure', records.getsCPP, records.setsCPP),
          _buttonSymptoms('./image/f.png', 'Fever', records.getsFever, records.setsFever),
          _buttonSymptoms('./image/fatigue.png', 'Fatigue', records.getsFatigue, records.setsFatigue),
          _moreButton('./image/dots.png', 'More', records.getsMore, records.setsMore)
        ],
      ),
    );
  }

  Widget _submitButton(){
    return Container(
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async {
          try {
            await firestore.collection('symptoms_server').doc(user!.uid).collection('symptoms').add({
              'Face Swelling': records.getsFS,
              'Difficulty of Breathing': records.getsDOB,
              'Loss of appetite': records.getsLOA,
              'Confusion': records.getsC,
              'Leg Swollen': records.getsLS,
              'Chess pain or pressure': records.getsCPP,
              'Fever': records.getsFever,
              'Fatigue': records.getsFatigue,
              'More': records.getsMore,
              'time': DateTime.now().millisecondsSinceEpoch
            });
          } catch (e) {
            print("You got an error! $e");
          }
          // print(records.getName);
          // print(records.getAge);  
          // print(records.getHeartrate);
          // print(records.getTemperature);
          // print(records.getSpo2);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Processing Data')),
          );
          records.setFalseAll();
        },
        //margin: const EdgeInsets.all(16),
        child: const Text('Submit')
      ),
    );
  }

  Widget _lastBox(){
    return Container(
      margin: const EdgeInsets.all(10),
      color: Colors.blue[200],
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.indigo[900]
              ),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: ((context) => SymptomsMore())));
              }, 
              child: const Text('View more', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
            ),
          ),
          _symptomsList(),
        ]
      ),
    );
  }

  Widget _symptomsList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('symptoms_server')
        .doc(user!.uid)
        .collection('symptoms')
        .orderBy('time', descending: true)
        .limit(3)
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
              return SymptomsList(
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
        title: const Text('Symptoms Tracker'),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            text2('Do you have any symptoms today?', 25, 30, 0, true),
            text2('You may select more than 1 symptom that you\'re currently facing.', 15, 8, 10, false),
            _allSymptomsButton(),
            _submitButton(),
            text2('Past History of Symptoms', 25, 30, 0, true),
            _lastBox(),
          ],
        )
      )
    );
  }
}