import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pakn2021/core/services/congDongService.dart';

import 'package:pakn2021/ui/main/homePage.dart';
import 'package:pakn2021/ui/main/showThongBao.dart';
import 'package:pakn2021/ui/taiKhoanCB/phanAnh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWidgetCanBo extends StatefulWidget {
   LoginWidgetCanBo({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginWidgetCanBo> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;
  bool _showPass = true;
  var user;
  

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xCCFFFF),
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
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/hb-logo.jpg"),
        //     fit: BoxFit.cover,
        //   ),
        // ),
          child: SafeArea(
            child: Padding(
                padding: EdgeInsets.all(20),
                child:

                ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 121.88,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Image(
                        height: 100,
                        image: AssetImage('assets/user.png'),
                      ),
                    ),
                    SizedBox(
                      height: 28.52,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xff021029),
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          // shadows: [
                          //   Shadow(
                          //     blurRadius: 10.0,
                          //     color: Colors.white,
                          //     offset: Offset(5.0, 5.0),
                          //   )
                          // ]
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 23,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: new Theme(
                                data: new ThemeData(
                                  primaryColor: Colors.black45,
                                ),
                                child: new TextField(
                                  controller: usernameController,
                                  cursorColor: Colors.black45,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  decoration: new InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                      const BorderSide(color: Color(0xffC0C0C0),
                                          width: 1
                                      ),borderRadius: BorderRadius.circular(10),
                                    ),
                                    border: new OutlineInputBorder(
                                        borderSide:
                                        new BorderSide(color: Colors.black45)),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Color(0xffC0C0C0),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                    // prefixIcon: const Icon(
                                    //   Icons.person,
                                    //   color: Colors.black,
                                    // ),
                                    prefixText: ' ',
                                  ),
                                ),
                              )),
                          Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: [
                              Container(
                                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),

                                  child: new Theme(
                                    data: new ThemeData(
                                      primaryColor: Colors.black45,
                                    ),
                                    child: new TextField(
                                      obscureText: _showPass,
                                      controller: passwordController,
                                      cursorColor: Colors.black45,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      decoration: new InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                          const BorderSide(color: Color(0xffC0C0C0),
                                              width: 1
                                          ),borderRadius: BorderRadius.circular(10),
                                        ),
                                        border: new OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.white)),
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            color: Color(0xffC0C0C0),
                                            fontSize: 15),
                                        // prefixIcon: const Icon(
                                        //   Icons.lock,
                                        //   color: Colors.black,
                                        // ),
                                      ),
                                    ),
                                  )),
                              GestureDetector(
                                  onTap: onToggleShowPass,
                                  child: Container(
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 0, 20, 0),

                                    child: Image(height: 30,color: Color(0xffC0C0C0),
                                      image: _showPass ? AssetImage
                                        ('assets/logo_eye.png'): AssetImage('assets/logo_disseye.png'),
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(height: 20,),

                          Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: [

                              Container(
//                   color: Colors.white,
                                width: MediaQuery.of(context).size.width*0.885,
                                height: 72,
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: RaisedButton(
                                  color: Color(0xff3064D0),
                                  shape: RoundedRectangleBorder(
                                      side: new BorderSide(
                                        color: Color(0xff3064D0),
                                      ),
                                      //the outline color
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(10))),
                                  child: Text('Đăng nhập',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        // color: Colors.white,
                                      )),
                                  onPressed: () {
                                    if (mounted) {setState(() {
                                      isLoading = true;

                                    });}
                                    login(usernameController.text.trim(),
                                        passwordController.text);
                                  },
                                ),
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                  ],
                )),
          )),
    );
  }

  void onToggleShowPass() {
    if (mounted) {
      setState(() {
        _showPass = !_showPass;
      });
    }
  }



  Future<void> login(String username, String password) async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      EasyLoading.show(maskType: EasyLoadingMaskType.black,
      status: "Vui lòng chờ..");

     // var ural =  "http://hotlinevp.ungdungtructuyen.vn/AppMobile/token";
      var ural =  "http://pakn.vinhphuc.gov.vn/AppMobile/token";
      var details = {
        'username': username,
        'password': password,
        'grant_type': 'password'
      };
      var url = Uri.parse(ural);

      var parts = [];
      details.forEach((key, value) {
        parts.add('${Uri.encodeQueryComponent(key)}='
            '${Uri.encodeQueryComponent(value)}');
      });
      var formData = parts.join('&'); //nối đường dẫn
      var response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: formData,
      );

      var getToken, expires_in;
      SharedPreferences sharedToken = await SharedPreferences.getInstance();
      DateTime now = DateTime.now();

      if (response.statusCode == 200) {
        getToken = json.decode(response.body)['access_token'];

        expires_in = json.decode(response.body)['expires_in'];
        await sharedToken.setString("token", getToken);
        await sharedToken.setString("username", username);
        var expiresOut = now.add(new Duration(seconds: expires_in));
        print(expiresOut.toString());
      var thanhcong=  await CongAPI.SendToken(username,username,getToken,"1");
        bool Erros = true;
        Erros = json.decode(thanhcong)['Erros'] != null
            ? json.decode(thanhcong)['Erros']
            : true;
        if (Erros == false) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => phanAnhWidget()),
                  (Route<dynamic> route) => false);
          EasyLoading.dismiss();
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          EasyLoading.dismiss();
          showAlertDialog(context, "Xác thực không thành công");
        }
      } else {
        if (mounted) { setState(() {
          isLoading = false;

        });}
        EasyLoading.dismiss();
        showAlertDialog(context, "Tài khoản hoặc mật khẩu không đúng");
      }
    } else {
      if (mounted) { setState(() {
        isLoading = false;
      });}
      EasyLoading.dismiss();
      showAlertDialog(context, "Tài khoản và mật khẩu không được trống");
    }
  }
}
