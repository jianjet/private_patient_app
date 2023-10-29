import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../useful_widget.dart';

class SymptomsList extends StatefulWidget{
  String symptoms; 
  int date;
  SymptomsList({Key? key, 
    required this.symptoms,
    required this.date
  }) : super(key: key);
  @override
  SymptomsListState createState() => SymptomsListState();
}

class SymptomsListState extends State<SymptomsList> {

  late String _date;

  @override
  void initState() {
    _getDate();
    super.initState();
  }

  void _getDate(){
    DateTime time= DateTime.fromMillisecondsSinceEpoch(widget.date);
    _date = DateFormat.MMMMd().format(time);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        text2(_date, 15, 2, 1, true),
        text2(widget.symptoms, 13, 2, 10, false),
      ],
    );
  }
}