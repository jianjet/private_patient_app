import 'package:flutter/material.dart';

  Widget silverListConstant(Widget widgetAccepted, int l){
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            child: widgetAccepted,
          );
        },
        childCount: l,
      ),
    );
  }

  Widget text1(String words, double size){
    return Container(
      margin: const EdgeInsets.all(1),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          words, style: TextStyle(fontSize: size)
        ),
      )
    );
  }

  Widget _imageOtherRows(String image){
    return SizedBox(
      height: 50,
      width: 50,
      child: Image.asset(
        image, 
        fit: BoxFit.cover),
    );
  }

  Widget text2(String words, double size, double marginTop, double marginBottom, bool x){
    return Container(
      margin: EdgeInsets.only(left: 10, top: marginTop, bottom: marginBottom),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          words, style: TextStyle(fontSize: size, fontWeight: x ? FontWeight.bold : FontWeight.normal)
        ),
      )
    );
  }