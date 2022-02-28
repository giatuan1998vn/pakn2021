import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_version/new_version.dart';


import 'package:pakn2021/ui/login/login.dart';
import 'package:pakn2021/ui/login/loginCanBo.dart';


class phanQuyenLogin extends StatefulWidget {
  const phanQuyenLogin({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashState();
  }
}

class SplashState extends State<phanQuyenLogin> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;
  var user;


  @override
  void initState() {
    super.initState();
    // _checkVersion();
  }

  void _checkVersion() async {
    final newVersion = NewVersion(
      androidId: "com.simaxjsc.pakn2021",
    );
    final status = await newVersion.getVersionStatus();
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: "UPDATE!!!",
      dismissButtonText: "Skip",
      dialogText: "Please update the app from " + "${status.localVersion}" + " to " + "${status.storeVersion}",
      dismissAction: () {
        SystemNavigator.pop();
      },
      updateButtonText: "Lets update",
    );

    print("DEVICE : " + status.localVersion);
    print("STORE : " + status.storeVersion);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        padding:EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(
              flex:1,
              child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Bạn là ai?", style: TextStyle(fontSize: 32,
                          fontWeight: FontWeight.bold)),
                    ],)
              ),
            ),
            Expanded(   flex:3,
              child: Row(children: [
                Expanded(child:
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          highlightColor: Colors.blueAccent.withOpacity(0.5),
                          splashColor: Colors.black38.withOpacity(0.5),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  LoginWidgetCanBo()),
                            );
                          },
                          child: Container(
                            // margin: EdgeInsets.only(bottom: 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Image(

                                image: AssetImage('assets/canboicon.png'),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Cán bộ", style: TextStyle(fontSize: 24,
                                       )),


                                  ],),

                              ],),
                          ),
                        ),

                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          highlightColor: Colors.blueAccent.withOpacity(0.5),
                          splashColor: Colors.black38.withOpacity(0.5),
                          onTap:(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginWidget()),
                            );
                          },
                          child: Container(
                            /// margin: EdgeInsets.only(bottom: 100),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image(

                                      image: AssetImage('assets/congnhanicon.png'),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("Công dân", style: TextStyle(fontSize: 24,
                                        )),


                                    ],),
                                ],)
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
              ],),)



          ],
        ),),
    );
  }


}
