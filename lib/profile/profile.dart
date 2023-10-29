import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:patient_app/profile/editDialog.dart';
import 'package:patient_app/profile/past_visit_list.dart';
import '../errorpage.dart';
import 'qr_code.dart';
import 'package:flutter/material.dart';
import '../useful_widget.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../others.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser!;
  bool status = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? email;

  @override
  void initState() {
    super.initState();
    email = user.email;
  }
  
  Widget _girlIconImage(){
    return Container(
      margin: const EdgeInsets.all(1),
      height: 60,
      width: 60,
      child: Image.asset(
        "./image/girl_icon.png", 
        fit: BoxFit.cover),
    );
  }

  Widget _row1Column2(String name){
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          text1(email!,15),
        ],
      ),
    );
  }

  Widget _editButton(){
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blueGrey[800]),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const editDialog(),
          );
        },
        child: const Text('Edit', style: TextStyle(fontSize: 10)),
      )
    );
  }

  Widget _row1(String name){
    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _girlIconImage(),
          Expanded(child: _row1Column2(name)),
          _editButton()
        ],
      ),
    );
  }

  Widget _row2box(double marginBottom, double marginTop, double marginLeft, double marginRight, double height, double width, Widget widget, Color c){
    return Container(
      decoration: BoxDecoration(
        color: c,
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      margin: EdgeInsets.only(bottom: marginBottom, top: marginTop, left: marginLeft, right: marginRight),
      child: SizedBox(
        height: height,
        width: width,
        child: widget
      ),
    );
  }

  Widget _text1(String words, double size, double marginTop, double marginBottom, bool x){
    return Container(
      margin: EdgeInsets.only(top: marginTop, bottom: marginBottom, left: 5, right: 5),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          words, style: TextStyle(fontSize: size, color: Colors.white, fontWeight: x ? FontWeight.bold : FontWeight.normal)
        ),
      )
    );
  }

  Widget _row2stuff(String words1, String words2){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _text1(words1, 20, 0, 5, true),
        _text1(words2, 13, 0, 0, false)
      ],
    );
  }

  Widget _row2(){
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _row2box(20,10,5,5,80,95,_row2stuff('173 cm','Height'), (Colors.blueGrey[900])!),
            _row2box(20,10,5,5,80,95,_row2stuff('50 kg','Weight'), (Colors.blueGrey[900])!),
            _row2box(20,10,5,5,80,95,_row2stuff('40 y/o','Age'), (Colors.blueGrey[900])!),
            _row2box(20,10,5,5,80,95,_row2stuff('Casein','Allergy'), (Colors.blueGrey[900])!),
          ],
        ),
    );
  }

  Widget _text2(String words, double size, double marginTop, double marginBottom, bool x){
    return Container(
      margin: EdgeInsets.only(left: 15, top: marginTop, bottom: marginBottom),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          words, style: TextStyle(fontSize: size, fontWeight: x ? FontWeight.bold : FontWeight.normal)
        ),
      )
    );
  }

  Widget _imageOtherRows(String image, double h, double w){
    return SizedBox(
      height: h,
      width: w,
      child: Image.asset(
        image, 
        fit: BoxFit.cover),
    );
  }

  Widget _otherRows(String image, String words, double h, double w, Function() f){
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: MaterialStateProperty.all(Colors.blue[100]),
          padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
        ),
        onPressed: f,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _imageOtherRows(image, h, w),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                child: Text(words, style: const TextStyle(fontSize: 13, color: Colors.black)),
              )
            ),
            _imageOtherRows('./image/arrow_right.png', 35, 35)
          ],
        ),
      )
    );
  }

  void _pushOthers(){
    Navigator.push(context, MaterialPageRoute(builder: ((context) => const Others())));
  }

  void _pushQR(){
    Navigator.push(context, MaterialPageRoute(builder: ((context) => const QR())));
  }

  void _pushPastVisit(){
    Navigator.push(context, MaterialPageRoute(builder: ((context) => PastVisitMore())));
  }

  void _signOut(){
    FirebaseAuth.instance.signOut();
  }

  Widget _row3(){
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        children: [
          _text2('Account', 20, 10, 5, true),
          _otherRows('./image/profile.png','RN number', 20, 20, _pushQR),
          _otherRows('./image/list.png','History of Doctor Visits', 20, 20, _pushPastVisit),
          //_otherRows('./image/list.png','Sync Family History', 20, 20, _pushOthers),
        ],
      ),
    );
  }

  Widget _row4(){
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        children: [
          _text2('Other', 20, 10, 5, true),
          _otherRows('./image/contact.png','Contact Us', 20, 20, _pushOthers),
          _otherRows('./image/faq.png','FAQ', 20, 20, _pushOthers),
          _otherRows('./image/privacy.png','Privacy Policy', 20, 20, _pushOthers),
          _otherRows('./image/signout.png','Sign Out', 20, 20, _signOut),
        ],
      ),
    );
  }

  Widget _otherRows2(String image, String words, double h, double w){
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _imageOtherRows(image, h, w),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              child: Text(words, style: const TextStyle(fontSize: 13, color: Colors.black)),
            )
          ),
          FlutterSwitch(
            activeColor: (Colors.blueGrey[900])!,
            width: 45.0,
            height: 25.0,
            valueFontSize: 10.0,
            toggleSize: 18.0,
            value: status,
            borderRadius: 15.0,
            padding: 1.0,
            showOnOff: true,
            onToggle: (val) {
              setState(() {
                status = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _row5(){
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      child: Column(
        children: [
          _text2('Notification', 20, 10, 5, true),
          _otherRows2('./image/notification_icon.png','Pop-up notification', 20, 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DocumentReference documentReference = firestore.collection('patient_users').doc(user.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
            final String name = documentSnapshot!['Name'];
            return CustomScrollView(
              anchor: 0.0,
              slivers: <Widget>[
                silverListConstant(_row1(name), 1),
                //silverListConstant(_row2(), 1),
                silverListConstant(_row3(), 1),
                silverListConstant(_row4(), 1),
                //silverListConstant(_row5(), 1),
              ],
            );
          }
          return const ErrorPage();
        },
      ),
    );
  }
}