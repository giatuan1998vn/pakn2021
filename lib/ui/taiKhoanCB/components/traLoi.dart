import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:html/parser.dart' show parse;
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pakn2021/core/models/phanAnhKienNghiJson.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/ui/main/showThongBao.dart';
import 'package:pakn2021/core/services/congDongService.dart';

class TraLoi extends StatefulWidget {
  final int id;


  TraLoi({Key key, this.id}) : super(key: key);
  @override
  _tuChoiState createState() => _tuChoiState();
}

class _tuChoiState extends State<TraLoi> {
  bool isLoading = false;
  List dataList = [];
  var rating = 0.0;
  var ratingCD = 0.0;
  int random;
  var vanBan = null;
  String TiengViet = "";
  String TiengAnh = "";
  String TiengTrung = "";
  String TiengNhat = "";
  String TiengHan = "";
  final HtmlEditorController controllerHTMlTV = HtmlEditorController();
  final HtmlEditorController controllerHTMlTA = HtmlEditorController();
  final HtmlEditorController controllerHTMlTT = HtmlEditorController();
  final HtmlEditorController controllerHTMlTN = HtmlEditorController();
  final HtmlEditorController controllerHTMlTH = HtmlEditorController();

  var IDCoQuan;
  List<ListDataCoQuan>  ListDataCQ = [];

  @override
  void initState() {
    super.initState();
    GetDataChiTiet();
    GetDataCoQuan();

  }

  GetDataChiTiet() async {
    String getData = await CongAPI.getDataDetail(widget.id);
    var data = json.decode(getData)['OData'];
    if (mounted) {
      setState(() {
        vanBan = phanAnhKNJson.fromJson(data);
        isLoading = true;
      });
    }
  }
  GetDataCoQuan() async {
    String vbhs = "";
    vbhs= await await CongAPI.getDataCoQuan();
    if(mounted){ setState(() {
      var vanban = json.decode(vbhs)['OData'];
      var lstData = (vanban as List).map((e) => ListDataCoQuan.fromJson(e)).toList();
      lstData.forEach((element) {
        ListDataCQ.add(element);
      });
    });}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trả lời phản ánh kiến nghị"),),
      body:  isLoading == false
          ? Center(
          child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)))
          : getBody(),
    );
  }
  Widget getBody() {
    Size size = MediaQuery.of(context).size;
    phanAnhKNJson vban = vanBan;
    String nd = "";
    if(vban.CauHoiTiengViet != null)
      HtmlTags.removeTag(
        htmlString: vban.CauHoiTiengViet,
        callback: (string) {
          nd = string;
        },
      );
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.37,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Tiêu đề",
                          style: TextStyle(
                              color: Color(0xff021029),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
                      Container(
                        child: Text(
                          "(*)",
                          style: TextStyle(
                              color: Color(0xffDE3E43),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.CauHoi,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),

            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.37,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Người gửi",
                          style: TextStyle(
                              color: Color(0xff021029),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.NguoiHoiText,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.37,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Địa chỉ",
                          style: TextStyle(
                              color: Color(0xff021029),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.DiaChi,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.37,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Số điện thoại",
                          style: TextStyle(
                              color: Color(0xff021029),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.SDT,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.37,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Email",
                          style: TextStyle(
                              color: Color(0xff021029),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.Email,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.37,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Ngày tạo",
                          style: TextStyle(
                              color: Color(0xff021029),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.ThoiGianTao!= null&&vban.ThoiGianTao!="" ? GetDate
                      (vban.ThoiGianTao):"",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.37,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Hình thức",
                          style: TextStyle(
                              color: Color(0xff021029),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.HinhThuc,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "Câu hỏi tiếng việt",
                          style: TextStyle(
                              color: Color(0xff021029),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),  overflow: TextOverflow.visible,
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    nd,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Divider(),
            Container(
              height: 350,
              padding: EdgeInsets.all(10),
              child:DefaultTabController(length:5,
                child:
                Scaffold(
                    appBar:  TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor:Colors.black38,
                      tabs: [
                        Tab(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Tiếng Việt',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff021029),
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                        ),
                        Tab(
                            child: Align(
                              alignment: Alignment.center,

                              child: Text(
                                'Tiếng Anh',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff021029),
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                        ),
                        Tab(
                            child: Align(
                              alignment: Alignment.center,

                              child: Text(
                                'Tiếng Trung',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff021029),
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                        ),
                        Tab(
                            child: Align(
                              alignment: Alignment.center,

                              child: Text(
                                'Tiếng Nhật',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff021029),
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                        ),
                        Tab(
                            child: Align(
                              alignment: Alignment.center,

                              child: Text(
                                'Tiếng Hàn',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff021029),
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            )
                        ),



                      ],
                    ) ,
                    body:TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!kIsWeb) {
                              controllerHTMlTV.clearFocus();
                            }
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                HtmlEditor(
                                  controller: controllerHTMlTV, //required
                                  hint: 'Nội dung ...',
                                  //initalText: "text content initial, if any",
                                  options: HtmlEditorOptions(
                                    // height: 400,
                                  ),
                                  callbacks: Callbacks(
                                    onChange: (String changed) {
                                      print("content changed to $changed");
                                      if(mounted){ setState(() {
                                        TiengViet = changed;
                                        HtmlTags.removeTag(
                                          htmlString: TiengViet,
                                          callback: (string) {
                                            TiengViet = string;
                                          },
                                        );
                                      });}
                                    },

                                  ),


                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!kIsWeb) {
                              controllerHTMlTA.clearFocus();
                            }
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                HtmlEditor(
                                  controller: controllerHTMlTA, //required
                                  hint: 'Nội dung ...',
                                  //initalText: "text content initial, if any",
                                  options: HtmlEditorOptions(
                                    // height: 400,
                                  ),
                                  callbacks: Callbacks(
                                    onChange: (String changed) {
                                      print("content changed to $changed");
                                      if(mounted){ setState(() {
                                        TiengAnh = changed;
                                        HtmlTags.removeTag(
                                          htmlString: TiengAnh,
                                          callback: (string) {
                                            TiengAnh = string;
                                          },
                                        );
                                      });}
                                    },

                                  ),


                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!kIsWeb) {
                              controllerHTMlTT.clearFocus();
                            }
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                HtmlEditor(
                                  controller: controllerHTMlTT, //required
                                  hint: 'Nội dung ...',
                                  //initalText: "text content initial, if any",
                                  options: HtmlEditorOptions(
                                    // height: 400,
                                  ),
                                  callbacks: Callbacks(
                                    onChange: (String changed) {
                                      print("content changed to $changed");
                                      if(mounted){ setState(() {
                                        TiengTrung = changed;
                                        HtmlTags.removeTag(
                                          htmlString: TiengTrung,
                                          callback: (string) {
                                            TiengTrung = string;
                                          },
                                        );
                                      });}
                                    },

                                  ),

                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!kIsWeb) {
                              controllerHTMlTN.clearFocus();
                            }
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                HtmlEditor(
                                  controller: controllerHTMlTN, //required
                                  hint: 'Nội dung ...',
                                  //initalText: "text content initial, if any",
                                  options: HtmlEditorOptions(
                                    // height: 400,
                                  ),
                                  callbacks: Callbacks(
                                    onChange: (String changed) {
                                      print("content changed to $changed");
                                      if(mounted){ setState(() {
                                        TiengNhat = changed;
                                        HtmlTags.removeTag(
                                          htmlString: TiengNhat,
                                          callback: (string) {
                                            TiengNhat = string;
                                          },
                                        );
                                      });}
                                    },

                                  ),

                                  // toolbar: [
                                  //   Style(),
                                  //   Font(buttons: [FontButtons.bold, FontButtons.underline,
                                  //     FontButtons.italic],
                                  //   )
                                  // ]
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!kIsWeb) {
                              controllerHTMlTH.clearFocus();
                            }
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                HtmlEditor(
                                  controller: controllerHTMlTH, //required
                                  hint: 'Nội dung ...',
                                  //initalText: "text content initial, if any",
                                  options: HtmlEditorOptions(
                                    // height: 400,
                                  ),
                                  callbacks: Callbacks(
                                    onChange: (String changed) {

                                      print("content changed to $changed");
                                      if(mounted){ setState(() {
                                        TiengHan = changed;
                                        HtmlTags.removeTag(
                                          htmlString: TiengHan,
                                          callback: (string) {
                                            TiengHan = string;
                                          },
                                        );
                                      });}
                                    },

                                  ),

                                )
                              ],
                            ),
                          ),
                        ),
                      ],)
                ) ,
              ),



            ),
            SizedBox(height:50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 0),
                  child:   TextButton.icon (
                      icon: Icon(Icons.send_and_archive),
                      label: Text('Cập nhật',style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        EasyLoading.show();
                        // var thoiGian = _dateController
                        //     .text.toString();
                        var thanhcong = await
                        CongAPI.postTuChoi(widget.id,"TraLoiPAKN",
                          TiengViet,TiengAnh,
                          TiengTrung,
                          TiengNhat,TiengHan,);

                        EasyLoading.dismiss();
                        Navigator.of(context).pop();
                        showAlertDialog(context, json.decode(thanhcong)['Message']);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue[50]),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      )
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10,
                    right: 10,top: 0),
                  child:   TextButton.icon (
                    // child: Text("Đóng lại",style: TextStyle(fontWeight: FontWeight.bold),),
                      icon: Icon(Icons.delete_forever),
                      label: Text('Đóng lại',style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        EasyLoading.dismiss();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      )
                  ),
                ),
              ],),

          ],
        )
      ],
    );
  }
}
class HtmlTags {
  static void removeTag({htmlString, callback}) {
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    callback(parsedString);
  }
}
String GetDate(String strDt){

  // return DateFormat('yyyy-MM-dd  kk:mm')
  //     .format(DateFormat('yyyy-MM-dd kk:mm').parse(strDt));
  var parsedDate = DateTime.parse(strDt);
  return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}  "
      "${parsedDate.hour}:${parsedDate.minute}");
}
class ListDataCoQuan {
  String text;
  int IDCQ;

  ListDataCoQuan({ this.text,this.IDCQ});

  factory ListDataCoQuan.fromJson(Map<String, dynamic> json) {
    return ListDataCoQuan(IDCQ: (json['ID']), text: json['Title']);
  }
}