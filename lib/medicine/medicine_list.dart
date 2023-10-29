import 'package:flutter/material.dart';

class MedicineList extends StatefulWidget{
  String med_name;
  String price;
  int quantity;
  String type;
  String manufactured_by;
  String description;
  MedicineList({Key? key, 
    required this.med_name,
    required this.price,
    required this.quantity,
    required this.type,
    required this.manufactured_by,
    required this.description
  }) : super(key: key);
  @override
  MedicineListState createState() => MedicineListState();
}

class MedicineListState extends State<MedicineList> with TickerProviderStateMixin{

  Widget _imageRows(String image){
    return SizedBox(
      height: 50,
      width: 50,
      child: Image.asset(
        image, 
        fit: BoxFit.cover),
    );
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
          padding: const EdgeInsets.only(left: 16, right: 0, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    _imageRows('./image/medicine.png'),
                    const SizedBox(width: 16,),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.med_name, style: const TextStyle(fontSize: 16),),
                            const SizedBox(height: 6,),
                            Text(widget.manufactured_by,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal),),
                          ],
                        ),
                      ),
                    ),
                    Text('RM${widget.price}',style: const TextStyle(fontSize: 20,color: Colors.black, fontWeight: FontWeight.normal),),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {

                      }, 
                      icon: const Icon(Icons.delivery_dining_outlined)
                    )
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