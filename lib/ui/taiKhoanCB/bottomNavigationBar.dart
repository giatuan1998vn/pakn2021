import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pakn2021/core/models/phanAnhKienNghiJson.dart';
import 'package:pakn2021/core/services/callApi.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/ui/main/showThongBao.dart';
import 'package:pakn2021/ui/taiKhoanCB/components/cong_khai.dart';
import 'package:pakn2021/ui/taiKhoanCB/components/phanXuLy.dart';
import 'package:pakn2021/ui/taiKhoanCB/components/phucDap.dart';
import 'package:pakn2021/ui/taiKhoanCB/components/sua.dart';
import 'package:pakn2021/ui/taiKhoanCB/components/traLoi.dart';
import 'package:pakn2021/ui/taiKhoanCB/components/tuChoi.dart';

class BottomCN extends StatefulWidget {
  final int id;
  phanAnhKNJson vbanXL;

  BottomCN({Key key, this.id, this.vbanXL}) : super(key: key);

  @override
  _BottomCNState createState() => _BottomCNState();
}
//demo
class _BottomCNState extends State<BottomCN> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey[100]),
          color: Colors.white,
        ),
        height: 56.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 1,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  TrangThaiXuLy == 2 && ModerationStatus !=0
                      ? Padding(
                    padding: EdgeInsets.only(left: 5, right: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          border: Border.all(
                              color: Colors.black26, // Set border color
                              width: 3.0),
                          // Set border width
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                          // Set rounded corner radius
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black26,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                      ),
                      child: InkWell(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  FlatButton.icon(
                                    icon: Icon(Icons.public,
                                        color: Colors.white),
                                    label: Text(
                                      'Công khai',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                congKhai(id: widget.id),
                                          ));
                                    },
                                    textTheme: ButtonTextTheme.primary,
                                  )
                                ],
                              )
                            ]),
                      ),
                    ),
                  )
                      : SizedBox(),
                  TrangThaiXuLy == 0
                      ? Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff6FB3E0),
                          border: Border.all(
                              color: Colors.black26, // Set border color
                              width: 3.0),
                          // Set border width
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                          // Set rounded corner radius
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                      ),
                      child: InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FlatButton.icon(
                                  icon: Icon(Icons.assistant,
                                      color: Colors.white),
                                  label: Text(
                                    'Phân xử lý',
                                   style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () {
                                    Get.to(phanXuLy(id: widget.id));
                                    // onPressButton(context, 0);
                                  },
                                  textTheme: ButtonTextTheme.primary,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),
                  (TrangThaiXuLy == 1 ||
                      (TrangThaiXuLy == 2 && ModerationStatus != 0)) &&
                      PhanXuLy == true
                      ? Padding(
                    padding: EdgeInsets.only(left: 5, right: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          border: Border.all(
                              color: Colors.black26, // Set border color
                              width: 3.0),
                          // Set border width
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                          // Set rounded corner radius
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black26,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                      ),
                      child: InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FlatButton.icon(
                                  icon: Icon(Icons.reply,
                                      color: Colors.white),
                                  label: Text(
                                    'Phúc đáp',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              phucDap(id: widget.id),
                                        ));
                                  },
                                  textTheme: ButtonTextTheme.primary,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),
                  TrangThaiXuLy == 2 && ModerationStatus == 0
                      ? Padding(
                    padding: EdgeInsets.only(left: 5, right: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          border: Border.all(
                              color: Colors.black26, // Set border color
                              width: 3.0),
                          // Set border width
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                          // Set rounded corner radius
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black26,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                      ),
                      child: InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FlatButton.icon(
                                  icon: Icon(
                                      Icons.subdirectory_arrow_left,
                                      color: Colors.white),
                                  label: Text(
                                    'Thu hồi',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Thông báo"),
                                          content:
                                          SingleChildScrollView(
                                              child: Text(
                                                  "Bạn có muốn "
                                                      "thu hồi phản ánh "
                                                      "kiến nghị!")),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Yes'),
                                              onPressed: () async {
                                                EasyLoading.show();
                                                // var thoiGian = _dateController
                                                //     .text.toString();
                                                var thanhcong =
                                                await CongAPI
                                                    .postCongKhai(
                                                  widget.id,
                                                  "ThuHoi",
                                                );

                                                EasyLoading.dismiss();
                                                Navigator.of(context)
                                                    .pop();
                                                showAlertDialog(
                                                    context,
                                                    json.decode(
                                                        thanhcong)[
                                                    'Message']);
                                              },
                                            ),
                                            TextButton(
                                              child: Text('No'),
                                              onPressed: () {
                                                EasyLoading.dismiss();
                                                Navigator.of(context)
                                                    .pop();
                                              },
                                            ),
                                          ],
                                        ));
                                  },
                                  textTheme: ButtonTextTheme.primary,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),
                  TrangThaiXuLy == 0
                      ? Padding(
                    padding: EdgeInsets.only(left: 5, right: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffFFB752),
                          border: Border.all(
                              color: Colors.black26, // Set border color
                              width: 3.0),
                          // Set border width
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                          // Set rounded corner radius
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                      ),
                      child: InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FlatButton.icon(
                                  icon: Icon(Icons.undo_rounded,
                                      color: Colors.white),
                                  label: Text(
                                    'Từ chối',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () {
                                    Get.to(tuChoi(id: widget.id));
                                    // onPressButton(context, 0);
                                  },
                                  textTheme: ButtonTextTheme.primary,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),
                  PhanXuLy == true
                      ? Padding(
                    padding: EdgeInsets.only(left: 5, right: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.deepOrangeAccent,
                          border: Border.all(
                              color: Colors.black26, // Set border color
                              width: 3.0),
                          // Set border width
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                          // Set rounded corner radius
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Colors.black,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                      ),
                      child: InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FlatButton.icon(
                                  icon: Icon(Icons.edit,
                                      color: Colors.white),
                                  label: Text(
                                    'Sửa',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => suaWidget(
                                            id: widget.id,
                                          ),
                                        ));
                                  },
                                  textTheme: ButtonTextTheme.primary,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),
                ],
              );
            }));
  }

  void onPressButton(context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return _getBodyPage(context, index);
        });
  }

  Widget _getBodyPage(context, int index) {
    switch (index) {
      case 0:
        phanXuLy(id: widget.id);
        break;
      case 1:
        suaWidget(id: widget.id);
        break;
    }
  }
}