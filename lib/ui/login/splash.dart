import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_keyhash/flutter_facebook_keyhash.dart';


import 'package:pakn2021/ui/login/login.dart';
import 'package:pakn2021/ui/login/phanQuyen.dart';


class SplashWidget extends StatefulWidget {
  const SplashWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<SplashWidget> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;
  final bool _showPass = true;
   var user;
  void printKeyHash() async{

    String key=await FlutterFacebookKeyhash.getFaceBookKeyHash ??
        'Unknown platform version';
    print("Keyhash FB: $key");

  }
  @override
  void initState() {
    super.initState();
    printKeyHash();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) =>  phanQuyenLogin() ,));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white70,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                height: 50,
                image: AssetImage('assets/logovp.png'),
              ),


            ],
          ),
        ),
        backgroundColor: Color(0xff3064D0),
      ),
      body: Container(
          // decoration: new BoxDecoration(
          //
          //     image: new DecorationImage(
          //       image: AssetImage("assets/question.png"),
          //       fit: BoxFit.fitHeight,
          //     )
          // ),
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/hb-logo.jpg"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(30),
                child: isLoading
                    ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.white),
                    ))
                    : ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 133.93,
                    ),

                    Container(

                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Image(height: 100,
                        image: AssetImage('assets/chatin.png'),
                      ),
                    ),SizedBox(
                      height: 33.22,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Ph???n ??nh ki???n ngh???",
                        style: TextStyle(
                            color: Color(0xff021029),
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            // shadows: [
                            //   Shadow(
                            //     blurRadius: 10.0,
                            //     color: Colors.black,
                            //     offset: Offset(5.0, 5.0),
                            //   )
                            // ]
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 33.22,
                    ),
                    // Center(
                    //   child: CircularProgressIndicator(
                    //     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    //   ),
                    // ),
                   // SizedBox(height: 150,),
                Container(
                  child:  Text(" Th??ng tin c?? d???u * l?? th??ng tin b???t bu???c. ????? ngh??? t??? ch???c, c?? nh??n cung c???p ch??nh x??c ??t nh???t m???t trong 2 th??ng tin: ?????a ch??? email ho???c s??? ??i???n tho???i di ?????ng ????? ???????c nh???n th??ng b??o t??? H??? th???ng khi ph???n ??nh, ki???n ngh??? ???????c ph??c ????p"
                      ,style: TextStyle(color: Color(0xff021029),fontWeight:
                    FontWeight.w400,fontSize:
                      14,),
                )

                    ,),




                  ],
                )),
          )),
    );

  }


}
