import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../user_authentication/utils.dart';
import 'package:flutter/material.dart';

class AppointmentRatingDialog extends StatefulWidget {
  String doctor_uid;
  String patient_name;
  String document_id;
  AppointmentRatingDialog({
    Key? key,
    required this.doctor_uid,
    required this.patient_name,
    required this.document_id
  }) : super(key: key);

  @override
  State<AppointmentRatingDialog> createState() => _AppointmentRatingDialogState();
}

class _AppointmentRatingDialogState extends State<AppointmentRatingDialog> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _feedbackController = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  double _rating = 0;
  bool get _canSubmit => _rating != 0;

  Widget _feedback() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextFormField(
        maxLines: null,
        controller: _feedbackController,
        decoration: const InputDecoration(
          border: OutlineInputBorder()
        ),
      ),
    );
  }

  Widget _words(String words){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Align(
        //alignment: AlignmentDirectional.centerStart,
        child: Text(words, style: const TextStyle(fontSize: 15)),
      ),
    );
  }

  Widget _rateServices(){
    return RatingBar.builder(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating=rating;
        });
      },
    );
  }

  // Widget _rateSatisfaction(){
  //   return RatingBar.builder(
  //     initialRating: 3,
  //     itemCount: 5,
  //     tapOnlyMode: true,
  //     itemBuilder: (context, index) {
  //       switch (index) {
  //       case 0:
  //         return const Icon(
  //           Icons.sentiment_very_dissatisfied,
  //           color: Colors.red,
  //         );
  //       case 1:
  //         return const Icon(
  //           Icons.sentiment_dissatisfied,
  //           color: Colors.redAccent,
  //         );
  //       case 2:
  //         return const Icon(
  //           Icons.sentiment_neutral,
  //           color: Colors.amber,
  //         );
  //       case 3:
  //         return const Icon(
  //           Icons.sentiment_satisfied,
  //           color: Colors.lightGreen,
  //         );
  //       case 4:
  //         return const Icon(
  //           Icons.sentiment_very_satisfied,
  //           color: Colors.green,
  //         );
  //       default: 
  //         return Container();
  //       }
  //     },
  //     onRatingUpdate: (rating) {
  //       print(rating);
  //     },
  //   );
  // }

  Future _setAppointmentRating() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    try {
      await firestore.collection('appointment_server').doc(widget.document_id).update({
        'rated': true
      });
      await firestore.collection('doctor_users').doc(widget.doctor_uid).collection('Rating').add({
        'patient_uid': user!.uid,
        'appointment_id': widget.document_id,
        'service_rating': _rating,
        'feedback': _feedbackController.text.trim(),
        'time': DateTime.now().millisecondsSinceEpoch
      });
    } on FirebaseException catch (e){
      Utils.showSnackbar(e.message);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Center(
                  child: Text("Rating and Feedback", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const SizedBox(height: 10),
                _words('Services:'),
                _rateServices(),
                const SizedBox(height: 10),
                // _words('Satisfaction:'),
                // _rateSatisfaction(),
                _words('Feedback:'),
                _feedback(),
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, 
                        child: const Text("Cancel")
                      ),
                      ElevatedButton(
                        onPressed: _canSubmit ? () {
                          _setAppointmentRating();
                        } : null,
                        child: const Text("Submit")
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}