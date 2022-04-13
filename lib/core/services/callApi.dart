import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//const String DOMAIN = "http://hotlinevp.ungdungtructuyen.vn/HotLineTichHop/";
const String DOMAIN = "https://pakn.vinhphuc.gov.vn/HotLineTichHop/";
SharedPreferences sharedStorage;
String pdf = "";
String TenUser = "";
String DiaChiUser = "";
String EmailUser = "";
String DienThoaiUser = "";
int TrangThaiXuLy =0;
int ModerationStatus =0;
var vanBanTT = null;
int CurrentID =0;
int IDTT =0;
int IDDonVi =0;
bool PhanXuLy = false;
int lookupId;

responseData(String path) async {
  var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String token = sharedStorage.getString("token");
  var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Token':  token

      }

  );
  return response;
}
responseDataPost(String path, final formdata) async {
  var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String token = sharedStorage.getString("token");
  var response =  null ;
  response = await http.post(
      url,
      body: json.encode(formdata),
      headers: {
        'Content-Type': 'application/json',
        'Token':token
      }
  );
  return response;
}
responseUser(String path, final formdata) async {
  var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String token = sharedStorage.getString("token");
  var response =  null ;
  response = await http.post(
    url,
    headers: {

      'Token':token
    },
    body: formdata,
  );

  return response;}
responseDataPost1(String path, final formdata) async {
  var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String token = sharedStorage.getString("token");
  var response =  null ;
  response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      'Token':  token
    },
    body: json.encode(formdata),
  );

  return response;
}
responseDataNoToken(String path, final formdata) async {
  var url = Uri.parse(DOMAIN + path);

  var response =  null ;

  response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: formdata,
  );

  return response;}
responseDataPostTao(String path, final formdata) async {
  var url = Uri.parse(DOMAIN + path);
  sharedStorage = await SharedPreferences.getInstance();
  String token = sharedStorage.getString("token");
  var response =  null ;
  response = await http.post(
      url,
      body: json.encode(formdata),
      headers: {
        'Content-Type': 'application/json',
        'Token':  token
      }
  );
  return response;
}
responseDataMP3(String path, final formdata) async {
  var url = Uri.parse("http://lgspsi.ungdungtructuyen.vn" + path);

  var response =  null ;

  response = await http.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: formdata,
  );

  return response;

}
responseGetDataNoToken(String path) async {
  var url = Uri.parse(DOMAIN + path);

  var response =  null ;

  response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
    },

  );
//demo
  return response;}