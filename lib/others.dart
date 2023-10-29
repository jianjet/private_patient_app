import 'package:flutter/material.dart';

class Others extends StatefulWidget {
  const Others({Key? key}) : super(key: key);
  @override
  OthersState createState() => OthersState();
}

class OthersState extends State<Others> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Others'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.all(0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Others",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
              ]
            ),
          )
        ),
      )
    );
  }
}