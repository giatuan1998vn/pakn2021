
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/ui/main/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GoogleSignInController with ChangeNotifier{
  var _googleSignIn =  GoogleSignIn();
  GoogleSignInAccount googleAccount;




  login() async {
    this.googleAccount =  await _googleSignIn.signIn();
    await CongAPI.PostDangKyGG(googleAccount.email,googleAccount.displayName);
    if(googleAccount != null){
      loginV(googleAccount.email,"");
    }
    // GoogleSignInAuthentication googleSignInAuthentication = await googleAccount.authentication;
    // SharedPreferences sharedToken = await SharedPreferences.getInstance();
    // await sharedToken.setString("token", googleSignInAuthentication.accessToken);

    notifyListeners();
  }

  logOut() async{
    this.googleAccount = await _googleSignIn.signOut();
    notifyListeners();
  }
  Future<void> loginV(String username, String password) async {
    //var ural = "http://appmobile.duongdaynong.ungdungtructuyen.vn/tokenV3";
   var ural =  "http://hotlinevp.ungdungtructuyen.vn/AppMobile/tokenV3";
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

      var thanhcong =   await CongAPI.SendToken(username,username,getToken,"4");
      bool Erros = true;
      if(thanhcong != null){
        Erros = json.decode(thanhcong)['Erros'] != null
            ? json.decode(thanhcong)['Erros']
            : true;
      }
      if (Erros == false) {


        Get.to( homePage() );
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        Get.defaultDialog(title:"Xác thực không thành công ");

      }

    }



  }
}