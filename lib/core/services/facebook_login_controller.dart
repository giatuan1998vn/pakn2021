import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/ui/main/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:pakn2021/ui/main/showThongBao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FacebookSignInController with ChangeNotifier
{
  Map userData;
  logisn() async{
    var result = await FacebookAuth.i.login(
      permissions: ["public_profile","email"],
    );

    if(result.status == LoginStatus.success)
      {
        final requestData =  await FacebookAuth.i.getUserData(
          fields: "email,name,picture",
        );
        userData =  requestData;
        await CongAPI.PostDangKyGG(userData["email"],userData["name"]);
        if(userData != null){
          loginV(userData["email"],"");
        }  else{
          EasyLoading.dismiss();
          Get.defaultDialog(title: "Thông báo ",middleText: "Xác thực không thành "
              "công");
        }

        // Navigator.of(context)
        //     .pushReplacement(MaterialPageRoute(builder:
        //     (_) =>  homePage() ,));


        notifyListeners();
      }



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

      // sharedToken.setBool("rememberme", rememberMe);
      // tendangnhapAll =  username;
      // if (rememberMe) {
      //   sharedToken.setString("username", username);
      //   sharedToken.setString("password", password);
      // }
      // await GetInfoUser(username);
      //
      // sharedToken.setString("expires_in", expiresOut.toString());
      // await updateTokenFirebase(getToken);
   var thanhcong =   await CongAPI.SendToken(username,username,getToken,"4");
      bool Erros = true;
      Erros = json.decode(thanhcong)['Erros'] != null
          ? json.decode(thanhcong)['Erros']
          : true;
      if (Erros == false) {


        Get.to( homePage() );
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        Get.defaultDialog(title: "Thông báo ",middleText: "Xác thực không thành "
            "công");

      }


    }

  }

  logIut() async{
    await FacebookAuth.i.logOut();
    userData =  null;
    notifyListeners();
  }

}