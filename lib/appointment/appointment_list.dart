import 'package:flutter/material.dart';

class AppointmentList extends StatefulWidget{
  String name;
  String service;
  String time;
  String date;
  AppointmentList({Key? key, 
    required this.name,
    required this.service,
    required this.time,
    required this.date
  }) : super(key: key);
  @override
  AppointmentListState createState() => AppointmentListState();
}

class AppointmentListState extends State<AppointmentList> with TickerProviderStateMixin{

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
                            Text(widget.name, style: const TextStyle(fontSize: 16),),
                            const SizedBox(height: 6,),
                            Text(widget.service,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                          ],
                        ),
                      ),
                    ),
                    Text(_date,style: const TextStyle(fontSize: 20,color: Colors.black, fontWeight: FontWeight.bold),),
                    const SizedBox(width: 15),
                    Text(_time,style: const TextStyle(fontSize: 20,color: Colors.black, fontWeight: FontWeight.normal),),
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