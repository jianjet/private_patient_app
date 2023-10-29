import 'package:flutter/material.dart';
import 'package:patient_app/search_doctors/doctor_details.dart';

class DoctorList extends StatefulWidget{
  String name;
  String about;
  String uid;
  DoctorList({Key? key, 
    required this.name,
    required this.about,
    required this.uid
  }) : super(key: key);
  @override
  DoctorListState createState() => DoctorListState();
}

class DoctorListState extends State<DoctorList> {
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
          Navigator.push(context, MaterialPageRoute(builder: ((context) => DoctorDetails(doctor_uid: widget.uid,doctor_name: widget.name, about: widget.about,))));
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
                            Text(widget.about,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                          ],
                        ),
                      ),
                    ),
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