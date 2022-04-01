import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/core/services/facebook_login_controller.dart';
import 'package:pakn2021/core/services/google_login_controller.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:pakn2021/ui/login/singUp.dart';
import 'package:pakn2021/ui/main/homePage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pakn2021/ui/main/showThongBao.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWidget extends StatefulWidget {
  LoginWidget({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginWidget> with ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;
  bool _showPass = true;
  var user;
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount googleAccount; 

  GoogleSignIn googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    EasyLoading.dismiss();
  }

  loginUI() {
    return Consumer<FacebookSignInController>(builder: (contex, model, child) {
      if (model.userData != null) {
        return loggedInUI(model);
      } else {
        return loginControls(context);
      }
    });
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        Text('- OR -',
            style: TextStyle(
              //decoration: TextDecoration.underline,
              fontSize: 15,
              color: Color(0xff021029),
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              // color: Colors.white,
            )),
        SizedBox(height: 10.0),
        Text('Sign in with',
            style: TextStyle(
              // decoration: TextDecoration.underline,
              fontSize: 15,
              color: Color(0xff021029),
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              // color: Colors.white,
            )),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Get.to(singUp()),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Bạn chưa có tài khoản? ',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff021029),
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                // color: Colors.white,
              ),
            ),
            TextSpan(
                text: 'Đăng ký',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 18,
                  color: Color(0xff021029),
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  // color: Colors.white,
                )
                // style: TextStyle(
                //   color: Colors.white,
                //   fontSize: 18.0,
                //   fontWeight: FontWeight.bold,
                // ),
                ),
          ],
        ),
      ),
    );
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
        alignment: Alignment.center,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/hb-logo.jpg"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 50,
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
                                  borderSide: const BorderSide(
                                      color: Color(0xffC0C0C0), width: 1),
                                  borderRadius: BorderRadius.circular(10),
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
                                      borderSide: const BorderSide(
                                          color: Color(0xffC0C0C0), width: 1),
                                      borderRadius: BorderRadius.circular(10),
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
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Image(
                                  height: 30,
                                  color: Color(0xffC0C0C0),
                                  image: _showPass
                                      ? AssetImage('assets/logo_eye.png')
                                      : AssetImage('assets/logo_disseye.png'),
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // Padding(padding: EdgeInsets.only(left: 20,right: 10,
                      //     top:10),
                      // child: Row(mainAxisAlignment: MainAxisAlignment.end
                      //   ,children: [
                      //
                      //     Align(alignment: Alignment.topRight,
                      //       child:   Container(
                      //           margin: EdgeInsets.only(right: 10),
                      //           alignment: Alignment.topRight,
                      //           child: InkWell(
                      //             onTap: () {
                      //               // Navigator.of(context)
                      //               //     .pushReplacement(MaterialPageRoute(builder:
                      //               //     (_) =>  singUp() ,));
                      //             },
                      //             child: Text("Quên mật khẩu",
                      //                 style: TextStyle(
                      //                   fontSize: 15,
                      //                   color: Color(0xff021029),
                      //                   fontStyle: FontStyle.normal,
                      //                   fontWeight: FontWeight.w400,
                      //                   // color: Colors.white,
                      //                 )),
                      //           )),),
                      //   ],) ,),

                      Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          Container(
//                   color: Colors.white,
                            width: MediaQuery.of(context).size.width * 0.885,
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
                                if (mounted) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                }
                                login(usernameController.text.trim(),
                                    passwordController.text);
                              },
                            ),
                          ),
                        ],
                      ),
                      _buildSignInWithText(),
                      // _buildSocialBtnRow(),
                      loginControls(context),
                      _buildSignupBtn(),

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

  loginControls(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => Provider.of<FacebookSignInController>(context, listen: false)
                .logisn(),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () async {

              googleAccount = await _googleSignIn.signIn();
              await CongAPI.PostDangKyGG(
                  googleAccount.email, googleAccount.displayName);
              if (googleAccount != null) {
                EasyLoading.show();
                loginV(googleAccount.email, "");
                EasyLoading.dismiss();
              }
              else
                {
                  EasyLoading.dismiss();
                  showAlertDialog(context, "Xác thực không thành công");
                }
              // GoogleSignInAuthentication googleSignInAuthentication = await googleAccount.authentication;
              // SharedPreferences sharedToken = await SharedPreferences.getInstance();
              // await sharedToken.setString("token", googleSignInAuthentication.accessToken);

              notifyListeners();
            },
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  loggedInUI(FacebookSignInController model) {}

  Future<void> login(String username, String password) async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      EasyLoading.show(
          maskType: EasyLoadingMaskType.black, status: "Vui lòng chờ..");

      //var ural = "http://hotlinevp.ungdungtructuyen.vn/AppMobile/tokenV2";
      var ural = "http://pakn.vinhphuc.gov.vn/AppMobile/tokenV2";
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
        var thanhcong =
            await CongAPI.SendToken(username, username, getToken, "3");
        bool Erros = true;
        if(thanhcong != null){
          Erros = json.decode(thanhcong)['Erros'] != null
              ? json.decode(thanhcong)['Erros']
              : true;
        }

        if (Erros == false) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => homePage()),
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
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        EasyLoading.dismiss();
        showAlertDialog(context, "Tài khoản hoặc mật khẩu không đúng");
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      EasyLoading.dismiss();
      showAlertDialog(context, "Tài khoản và mật khẩu không được trống");
    }
  }

  Future<void> loginV(String username, String password) async {
   //var ural = "http://hotlinevp.ungdungtructuyen.vn/AppMobile/tokenV3";
    var ural = "http://pakn.vinhphuc.gov.vn/AppMobile/tokenV3";
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
    var thanhcong=  await CongAPI.SendToken(username, username, getToken, "4");
      bool Erros = true;
      if(thanhcong != null){
        Erros = json.decode(thanhcong)['Erros'] != null
            ? json.decode(thanhcong)['Erros']
            : true;
      }
      if (Erros == false) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => homePage()),
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
      //Get.to(homePage() );

    }
    else{
      EasyLoading.dismiss();
      showAlertDialog(context, "Xác thực không thành công");
    }
  }
}
