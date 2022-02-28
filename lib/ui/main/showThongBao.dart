import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pakn2021/ui/taiKhoanCB/phanAnh.dart';

/// hiện thông báo
Future<void> showAlertDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Thông báo'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message ==  null ? "" :message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
                Navigator.of(context).pop();

            },
          ),
        ],
      );
    },
  );
}
Future<void> showAlertDialogPXL(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Thông báo'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message ==  null ? "" :message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Get.offAll(phanAnhWidget());

            },
          ),
        ],
      );
    },
  );
}
Future<void> showAlertDialog2(BuildContext context, String message,String Title) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(Title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message ==  null ? "" :message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
Future<void> showfDialog(BuildContext context, Widget ad,String thongbao)
async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(thongbao),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ad
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}