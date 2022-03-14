import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:pakn2021/core/services/callApi.dart';
import 'package:pakn2021/core/services/facebook_login_controller.dart';
import 'package:pakn2021/core/services/google_login_controller.dart';
import 'package:pakn2021/ui/caNhan/caNhan.dart';
import 'package:pakn2021/ui/login/phanQuyen.dart';
import 'package:pakn2021/ui/login/singUp.dart';
import 'package:pakn2021/ui/taoPhanAnh/taoPhanAnh.dart';
import 'package:pakn2021/ui/trangChu/trangChu.dart';
import 'package:provider/provider.dart';

import '../congDong/congDong.dart';



class homePage extends StatefulWidget {
   homePage({Key key,}) : super(key: key);


  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List dataList = [];
  bool isLoading = false;
  int _currentIndex = 0;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffE5E5E5),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          //backgroundColor: Color(0xff3366FF),
          onTap: onTabTapped,
          fixedColor: Color(0xff3064D0),
          unselectedItemColor: Colors.black,
          currentIndex: _currentIndex,
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label:'Trang chủ',
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Phản ánh',
            ),
            new BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),label: 'Cá nhân',

              // title: Text(
              //   'Cá nhân',
              //   style: TextStyle(
              //       fontSize: 14,
              //       fontStyle: FontStyle.normal,
              //       fontWeight: FontWeight.w400),
              // ),
            ),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(backgroundColor: Color(0xff3064D0),
      //   child: new Image.asset(
      //     'assets/edit-text.png',
      //
      //     // fit: BoxFit.fitWidth,
      //   ),
      //   onPressed: () {

      //   },//     Navigator.push(
      //       //       context,
      //       //       MaterialPageRoute(
      //       //         builder: (context) => taoPhanAnh(),
      //       //       ),
      //       //     );
      // ),
      body: body(),
    );

    // return OfflineBuilder(
    //     debounceDuration: Duration.zero,
    //     connectivityBuilder: (
    //         BuildContext context,
    //         ConnectivityResult connectivity,
    //         Widget child,
    //         )
    //     {
    //       if (connectivity == ConnectivityResult.none) {
    //
    //         return Scaffold(
    //           body:Center(
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Center(
    //
    //                   child: Image(
    //                     height: 122,
    //                     image: AssetImage('assets/robot.jpg'),
    //                   ),
    //                 ),
    //                 SizedBox(height: 20,),
    //                 Container(
    //
    //                   alignment: Alignment.center,
    //
    //                   child: Text("Không có kết nối mạng",style:
    //                   TextStyle
    //                     (fontSize:
    //                   16,fontStyle: FontStyle.normal,fontWeight: FontWeight
    //                       .w400,
    //                       color: Color(0xff021029)),),
    //                 ),
    //                 SizedBox(height: 6,),
    //                 Container(
    //
    //                   alignment: Alignment.center,
    //
    //                   child: Text("Kiểm tra lại đường truyền",style:
    //                   TextStyle
    //                     (fontSize:
    //                   12,fontStyle: FontStyle.normal,fontWeight: FontWeight
    //                       .w400,
    //                       color: Color(0xff021029)),),
    //                 ),
    //               ],),
    //           ),
    //         );
    //       }
    //       return child;
    //     },
    //     child:
    //   Scaffold(
    //   key: _scaffoldKey,
    //   backgroundColor: Color(0xffE5E5E5),
    //   bottomNavigationBar: BottomAppBar(
    //     clipBehavior: Clip.antiAlias,
    //     color: Colors.blue,
    //     shape: CircularNotchedRectangle(),
    //     child: BottomNavigationBar(
    //       type: BottomNavigationBarType.fixed,
    //       //backgroundColor: Color(0xff3366FF),
    //       onTap: onTabTapped,
    //       fixedColor: Color(0xff3064D0),
    //       unselectedItemColor: Colors.black,
    //       currentIndex: _currentIndex,
    //       items: [
    //         new BottomNavigationBarItem(
    //           icon: Icon(Icons.home),
    //           label:'Trang chủ',
    //         ),
    //         new BottomNavigationBarItem(
    //           icon: Icon(Icons.group),
    //           label: 'Phản ánh',
    //         ),
    //         new BottomNavigationBarItem(
    //           icon: Icon(
    //             Icons.person,
    //           ),label: 'Cá nhân',
    //
    //           // title: Text(
    //           //   'Cá nhân',
    //           //   style: TextStyle(
    //           //       fontSize: 14,
    //           //       fontStyle: FontStyle.normal,
    //           //       fontWeight: FontWeight.w400),
    //           // ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    //   // floatingActionButton: FloatingActionButton(backgroundColor: Color(0xff3064D0),
    //   //   child: new Image.asset(
    //   //     'assets/edit-text.png',
    //   //
    //   //     // fit: BoxFit.fitWidth,
    //   //   ),
    //   //   onPressed: () {
    //
    //   //   },//     Navigator.push(
    //     //       //       context,
    //     //       //       MaterialPageRoute(
    //     //       //         builder: (context) => taoPhanAnh(),
    //     //       //       ),
    //     //       //     );
    //   // ),
    //   body: body(),
    // ));
  }

  Widget body() {
    switch (_currentIndex) {
      case 0:
        return  WillPopScope(
            child: trangChu(),
            onWillPop:  () async {
              Provider.of<GoogleSignInController>(context, listen:
              false).logOut();
              Provider.of<FacebookSignInController>(context, listen:
              false).logIut();
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (BuildContext context) => phanQuyenLogin()), (Route<dynamic> route) => false);
            }
        );
        break;
        case 1:
          return  WillPopScope(
              child: congDong(),
              onWillPop:  () async {
                onTabTapped(0);
              }
          );
        break;
      case 2:
        return  WillPopScope(
            child: caNhan(),
            onWillPop:  () async {
              onTabTapped(0);
            }
        );
        break;
    }
  }

  void onTabTapped(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}
