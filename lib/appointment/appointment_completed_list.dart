import 'package:flutter/material.dart';
import 'package:patient_app/appointment/appointment_rating_dialog.dart';

class AppointmentCompletedList extends StatefulWidget{
  String doctorName;
  String service;
  String time;
  String date;
  String doctorUid;
  String patientName;
  String documentId;
  bool rated;
  AppointmentCompletedList({Key? key, 
    required this.doctorName,
    required this.service,
    required this.time,
    required this.date,
    required this.doctorUid,
    required this.patientName,
    required this.documentId,
    required this.rated
  }) : super(key: key);
  @override
  AppointmentCompletedListState createState() => AppointmentCompletedListState();
}

class AppointmentCompletedListState extends State<AppointmentCompletedList> with TickerProviderStateMixin{

  late String _date;
  late String _time;

  @override
  void initState() {
    _getDateAndTime();
    super.initState();
  }

  void _getDateAndTime(){
    _time = widget.time;
    _date = widget.date;
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
          padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    const CircleAvatar(
                      backgroundImage: AssetImage('./image/girl_icon.png'),
                      maxRadius: 30,
                    ),
                    const SizedBox(width: 16,),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.doctorName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                            const SizedBox(height: 3,),
                            Text(widget.service,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_date,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                                const SizedBox(width: 5),
                                Text(_time,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    //rated button
                    if (widget.rated==false) ... [
                      TextButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                        onPressed: (){
                          showDialog(
                            context: context,
                            builder: (context) => AppointmentRatingDialog(doctor_uid: widget.doctorUid, patient_name: widget.patientName, document_id: widget.documentId,),
                          );
                        }, 
                        child: const Text('Rate', style: TextStyle(fontSize: 15, color: Colors.white))
                      ),
                    ] else ... [
                      const TextButton(
                        onPressed: null,
                        child: Text('Rated', style: TextStyle(fontSize: 15))
                      ),
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