import 'package:flutter/material.dart';
import 'package:pakn2021/ui/res/strings.dart';

class gioiThieu extends StatelessWidget {
  const gioiThieu({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: 50,
                image: AssetImage('assets/logovp.png'),
              ),
              SizedBox(
                width: 15,
              ),
             Column(children: [
               Text(
                 "VĨNH PHÚC",
                 style: TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.w700,
                     fontStyle: FontStyle.normal),
               ),
               Text(
                 "Giới thiệu",
                 style: TextStyle(
                     fontSize: 14,
                     fontWeight: FontWeight.w700,
                     fontStyle: FontStyle.normal),
               ),
             ],)
            ],
          ),
        ),
        backgroundColor: Color(0xff3064D0),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(children: [
            // Padding(
            //   padding: EdgeInsets.all(10),
            //   child:  Align(
            //     alignment: Alignment.bottomRight,
            //     child: Text("Thống kê truy cập: ", style: TextStyle(fontStyle:
            //     FontStyle.normal,fontWeight: FontWeight.w400, fontSize: 14),),
            //   ),),
            Container(
              margin: EdgeInsets.only(top: 10),
              child:Text(
                tieude.toUpperCase(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal),
                textAlign: TextAlign.center,
              ), ),

            Container(
                padding: EdgeInsets.only(top:20),
                child:noiDungGT ),


          ],),
        ),
      )
    );
  }
}
