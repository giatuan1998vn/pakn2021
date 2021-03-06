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

class suaWidget extends StatefulWidget {
  final int id;

  suaWidget({Key key, this.id}) : super(key: key);

  @override
  _tuChoiState createState() => _tuChoiState();
}

class _tuChoiState extends State<suaWidget> {
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
  String nd = "";
  final HtmlEditorController controllerHTMlTV = HtmlEditorController();
  final HtmlEditorController controllerHTMlTA = HtmlEditorController();
  final HtmlEditorController controllerHTMlTT = HtmlEditorController();
  final HtmlEditorController controllerHTMlTN = HtmlEditorController();
  final HtmlEditorController controllerHTMlTH = HtmlEditorController();

  var IDCoQuan;
  List<ListDataCoQuan> ListDataCQ = [];

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
    vbhs = await await CongAPI.getDataCoQuan();
    if (mounted) {
      setState(() {
        var vanban = json.decode(vbhs)['OData'];
        var lstData =
            (vanban as List).map((e) => ListDataCoQuan.fromJson(e)).toList();
        lstData.forEach((element) {
          ListDataCQ.add(element);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("S???a ph???n ??nh ki???n ngh???"),
      ),
      body: isLoading == false
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)))
          : getBody(),
    );
  }

  Widget getBody() {
    Size size = MediaQuery.of(context).size;
    phanAnhKNJson vban = vanBan;
    if (vban.CauHoiTiengViet != null)
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
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Ti??u ?????",
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
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: TextEditingController(text: vban.CauHoi),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    onChanged: (newValue) {
                      vban.CauHoi = newValue;
                      print("ti??u ????? "+vban.CauHoi);
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.lightBlue)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Ng?????i g???i",
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
                vban.TrangThaiAnHien == true
                    ?  Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    "Ng?????i g???i y??u c???u ???n th??ng tin",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                )
                    : Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextFormField(
                          controller:
                              TextEditingController(text: vban.NguoiHoiText),
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.75),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                          onChanged: (newValue) => vban.NguoiHoiText = newValue,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.lightBlue)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                          ),
                        ),
                      ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "?????a ch???",
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
                vban.TrangThaiAnHien == true
                    ? Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    "Ng?????i g???i y??u c???u ???n th??ng tin",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                )
                    :  Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: TextEditingController(text: vban.DiaChi),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    onChanged: (newValue) => vban.DiaChi = newValue,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.lightBlue)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "S??? ??i???n tho???i",
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
                vban.TrangThaiAnHien == true
                    ? Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    "Ng?????i g???i y??u c???u ???n th??ng tin",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                )
                    : Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: TextEditingController(text: vban.SDT),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    onChanged: (newValue) => vban.SDT = newValue,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.lightBlue)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
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
                vban.TrangThaiAnHien == true
                    ? Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    "Ng?????i g???i y??u c???u ???n th??ng tin",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                )
                    : Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: TextEditingController(text: vban.Email),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    onChanged: (newValue) => vban.Email = newValue,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.lightBlue)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Ph??c ????p",
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
                vban.TrangThaiAnHien == true
                    ? Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    "Ng?????i g???i y??u c???u ???n th??ng tin",
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                )
                    :  Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: TextEditingController(text: vban.NoiDung),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    onChanged: (newValue) => vban.NoiDung = newValue,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.lightBlue)),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Ng??y t???o",
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
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.ThoiGianTao != null && vban.ThoiGianTao != ""
                        ? GetDate(vban.ThoiGianTao)
                        : "",
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
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "H??nh th???c",
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
                  width: MediaQuery.of(context).size.width * 0.75,
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
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "C??u h???i ti???ng vi???t",
                          style: TextStyle(
                              color: Color(0xff021029),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  height: 350,
                  //padding: EdgeInsets.all(10),
                  child: DefaultTabController(
                    length: 5,
                    child: Scaffold(
                        appBar: TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Colors.black38,
                          tabs: [
                            Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Ti???ng Vi???t',
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
                                    'Ti???ng Anh',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff021029),
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                )),
                            Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Ti???ng Trung',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff021029),
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                )),
                            Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Ti???ng Nh???t',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff021029),
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                )),
                            Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Ti???ng H??n',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff021029),
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                )),
                          ],
                        ),
                        body: TabBarView(
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
                                      controller: controllerHTMlTV,
                                      //required
                                      hint: 'N???i dung ...',
                                      initialText: nd,
                                      //initalText: "text content initial, if any",
                                      options: HtmlEditorOptions(
                                        // height: 400,
                                      ),
                                      callbacks: Callbacks(
                                        onChange: (String changed) {
                                          print("content changed to $changed");
                                          if (mounted) {
                                            setState(() {
                                              nd = changed;
                                              HtmlTags.removeTag(
                                                htmlString: nd,
                                                callback: (string) {
                                                  TiengViet = string;
                                                },
                                              );
                                            });
                                          }
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
                                      hint: 'N???i dung ...',
                                      //initalText: "text content initial, if any",
                                      options: HtmlEditorOptions(
                                        // height: 400,
                                      ),
                                      callbacks: Callbacks(
                                        onChange: (String changed) {
                                          print("content changed to $changed");
                                          if (mounted) {
                                            setState(() {
                                              TiengAnh = changed;
                                              HtmlTags.removeTag(
                                                htmlString: TiengAnh,
                                                callback: (string) {
                                                  TiengAnh = string;
                                                },
                                              );
                                            });
                                          }
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
                                      hint: 'N???i dung ...',
                                      //initalText: "text content initial, if any",
                                      options: HtmlEditorOptions(
                                        // height: 400,
                                      ),
                                      callbacks: Callbacks(
                                        onChange: (String changed) {
                                          print("content changed to $changed");
                                          if (mounted) {
                                            setState(() {
                                              TiengTrung = changed;
                                              HtmlTags.removeTag(
                                                htmlString: TiengTrung,
                                                callback: (string) {
                                                  TiengTrung = string;
                                                },
                                              );
                                            });
                                          }
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
                                      hint: 'N???i dung ...',
                                      //initalText: "text content initial, if any",
                                      options: HtmlEditorOptions(
                                        // height: 400,
                                      ),
                                      callbacks: Callbacks(
                                        onChange: (String changed) {
                                          print("content changed to $changed");
                                          if (mounted) {
                                            setState(() {
                                              TiengNhat = changed;
                                              HtmlTags.removeTag(
                                                htmlString: TiengNhat,
                                                callback: (string) {
                                                  TiengNhat = string;
                                                },
                                              );
                                            });
                                          }
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
                                      hint: 'N???i dung ...',
                                      //initalText: "text content initial, if any",
                                      options: HtmlEditorOptions(
                                        // height: 400,
                                      ),
                                      callbacks: Callbacks(
                                        onChange: (String changed) {
                                          print("content changed to $changed");
                                          if (mounted) {
                                            setState(() {
                                              TiengHan = changed;
                                              HtmlTags.removeTag(
                                                htmlString: TiengHan,
                                                callback: (string) {
                                                  TiengHan = string;
                                                },
                                              );
                                            });
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),

              ],
            ),
            Divider(),

            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 0),
                  child: TextButton.icon(
                      icon: Icon(Icons.send_and_archive),
                      label: Text('C???p nh???t',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        EasyLoading.show();
                        // var thoiGian = _dateController
                        //     .text.toString();
                        //comnent
                        var thanhcong;
                        if(((TiengViet== null || TiengViet=="")
                            &&(TiengAnh== null || TiengAnh=="")
                            &&(TiengTrung== null || TiengTrung=="")
                            &&(TiengNhat== null || TiengNhat=="")
                            &&(TiengHan== null || TiengHan==""))){
                          EasyLoading.dismiss();
                          showAlertDialog(context,"N???i dung c??u h???i kh??ng ???????c ????? tr???ng!");
                        }else{
                           thanhcong = await CongAPI.postSuaCB(
                            widget.id,
                            "SuaPAKN",
                            TiengViet,
                            TiengAnh,
                            TiengTrung,
                            TiengNhat,
                            TiengHan,
                            vban.CauHoi,
                            vban.NguoiHoiText,
                            vban.DiaChi,
                            vban.SDT,
                            vban.Email,
                          );
                          EasyLoading.dismiss();
                          Navigator.of(context).pop();
                          showAlertDialog(
                          context, json.decode(thanhcong)['Message']);

                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.lightBlue[50]),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 0),
                  child: TextButton.icon(
                      // child: Text("????ng l???i",style: TextStyle(fontWeight: FontWeight.bold),),
                      icon: Icon(Icons.delete_forever),
                      label: Text('????ng l???i',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        EasyLoading.dismiss();
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orangeAccent),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      )),
                ),
              ],
            ),
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

String GetDate(String strDt) {
  // return DateFormat('yyyy-MM-dd  kk:mm')
  //     .format(DateFormat('yyyy-MM-dd kk:mm').parse(strDt));
  var parsedDate = DateTime.parse(strDt);
  return ("${parsedDate.day}/${parsedDate.month}/${parsedDate.year}  "
      "${parsedDate.hour}:${parsedDate.minute}");
}

class ListDataCoQuan {
  String text;
  int IDCQ;

  ListDataCoQuan({this.text, this.IDCQ});

  factory ListDataCoQuan.fromJson(Map<String, dynamic> json) {
    return ListDataCoQuan(IDCQ: (json['ID']), text: json['Title']);
  }
}
