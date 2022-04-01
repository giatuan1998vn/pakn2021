import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:pakn2021/core/services/callApi.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/core/services/facebook_login_controller.dart';
import 'package:pakn2021/core/services/google_login_controller.dart';
import 'package:pakn2021/ui/login/login.dart';
import 'package:pakn2021/ui/login/phanQuyen.dart';
import 'package:pakn2021/ui/login/splash.dart';
import 'package:pakn2021/ui/main/AppBar.dart';
import 'package:flutter_offline/flutter_offline.dart';
//import 'package:connectivity/connectivity.dart';
import 'package:pakn2021/ui/main/gioiThieu.dart';
import 'package:pakn2021/ui/main/menuLeft.dart';
import 'package:pakn2021/ui/main/showThongBao.dart';
import 'package:pakn2021/ui/taiKhoanCB/AppBarCB.dart';
import 'package:pakn2021/ui/taiKhoanCB/thongTinChiTiet.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:html/parser.dart' show parse;
import 'package:shared_preferences/shared_preferences.dart';

class phanAnhWidget extends StatefulWidget {
  String TrangThaiXuLy;
  String LoaiTiepNhan;
  String CongKhai;

  phanAnhWidget({this.TrangThaiXuLy, this.LoaiTiepNhan, this.CongKhai});

  @override
  _phanAnhWidgetState createState() => _phanAnhWidgetState();
}

class _phanAnhWidgetState extends State<phanAnhWidget> {
  List dataList = [];
  bool isLoading = false;
  int length = 20;
  int Skip = 0;
  int take = 20;
  int page = 1;

  bool chckSwitch = false;
  ScrollController _scrollerController = new ScrollController();
  String ActionXL = "GetListItem";
  String ActionXLL = "GetMenuLeft";
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  int tongSo = 0;

  @override
  Future<void> initState() {
    super.initState();
    GetUser();
    GetDataDL();
    refreshList();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      setState(() {
        GetData();
        // GetDataHSCV();
      });
    }

    return null;
  }

  Widget getBodyKN() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image(
              height: 122,
              image: AssetImage('assets/robot.jpg'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "Không có kiến nghị nào",
              style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff021029).withOpacity(0.75)),
            ),
          ),
        ],
      ),
    );
  }

  GetUser() async {
    String getData = await CongAPI.getUser();
    if (mounted) {
      setState(() {
        // dataList += json.decode(vbden)['OData'];
        PhanXuLy = (json.decode(getData)['OData']['PhanXuLy'] != null
            ? json.decode(getData)['OData']['PhanXuLy']
            : false);
        IDDonVi = json.decode(getData)['OData']['DonVi'] != null &&json.decode
           (getData)['OData']['DonVi']['LookupId'] != null ? json.decode
           (getData)['OData']['DonVi']['LookupId']:0;
      });
    }
  }

//demo
  GetDataDL() async {
    if (widget.TrangThaiXuLy == null ||
        widget.CongKhai == null ||
        widget.LoaiTiepNhan == null) {
      setState(() {
        isLoading = true;
      });
    } else {
      String getData = await CongAPI.getDataDetailVBPAKNCB(ActionXL, length,
          widget.TrangThaiXuLy, widget.LoaiTiepNhan, widget.CongKhai);
      if (mounted) {
        setState(() {
          // dataList += json.decode(vbden)['OData'];
          dataList.addAll(json.decode(getData)['OData']);
          length += 10;
          Skip +=10;
          page +=1;
          isLoading = true;
          tongSo = json.decode(getData)['TotalCount'];
          _scrollerController.addListener(() {
            if (_scrollerController.position.pixels ==
                _scrollerController.position.maxScrollExtent) {
              GetDataDL();
              // GetDataByKeyYearVBDen(dropdownValue);
              dataList;
            }
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Color(0xffFFFFFF),
          // appBar:MainAppBar(title: 'Phản ánh - Kiến nghị',    ) ,
          body: Stack(
            children: [
              MainAppBarCB(
                title: 'Phản ánh - Kiến nghị'.toUpperCase(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 170),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Tổng số ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        Text(
                          tongSo.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                              color: Colors.red),
                        ),
                        Text(
                          " phản ánh, kiến nghị được phúc đáp.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        child: GetData(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                Container(
                  color: Colors.white12,
                  height: MediaQuery.of(context).size.height / 13,
                  child: DrawerHeader(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        child: Text(
                          "",
                          style:
                              TextStyle(fontSize: 18, color: Color(0xff000000)),
                        ),
                      ),
                    ),
                  ),
                ),
                MenuLeft(ActionXL: ActionXLL),
                //Divider(),
                Card(
                  color: Colors.white10,
                  //height: MediaQuery.of(context).size.height /13,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 14,
                    child: InkWell(
                      onTap: () async {
                        sharedStorage = await SharedPreferences.getInstance();
                        String token = sharedStorage.getString("token");
                        String username = sharedStorage.getString("username");
                        var thanhcong = await CongAPI.SendToken(
                            username, username, token, "1");
                        bool Erros = true;
                        if(thanhcong != null){
                          Erros = json.decode(thanhcong)['Erros'] != null
                              ? json.decode(thanhcong)['Erros']
                              : true;
                        }
                        if (Erros == false) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      phanQuyenLogin()),
                              (Route<dynamic> route) => false);
                        } else {
                          showAlertDialog(
                              context, "Đăng xuất không thành công!");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Đăng xuất",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff000000)),
                        ),
                      ),
                    ),
                  ),
                ),

                //  Container(
                //   height: MediaQuery.of(context).size.height,
                //   child: ,
                // )
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: (){
          //
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => taoPhanAnh(),
          //       ),
          //     );
          //   },
          //   tooltip: 'Increment',backgroundColor: Color(0xffE85424
          // ),
          //   child: Image(
          //     height: 122,
          //     image: AssetImage('assets/edit-text.png'),
          //   ),
          // ),
        ),
        onWillPop: () async {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => phanQuyenLogin()),
              (Route<dynamic> route) => false);
        });
  }

  Widget GetData() {
    if (dataList.contains(null) || dataList.length < 0 || isLoading == false) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ));
    } else if (dataList.length == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(
                height: 122,
                image: AssetImage('assets/robot.jpg'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Không có kiến nghị nào",
                style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff021029).withOpacity(0.75)),
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
          itemCount: dataList == null ? 0 : dataList.length,
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) {
            if (index == tongSo) {
              _buildProgressIndicator();
            } else {
              return getCard(dataList[index]);
            }
          },
          controller: _scrollerController,
        ),
        onRefresh: refreshList);
    // return ListView.builder(
    //   itemCount: dataList == null ? 0 : dataList.length,padding: EdgeInsets.all(10),
    //   itemBuilder: (context, index) {
    //     return getCard(dataList[index]);
    //   },
    // );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget getCard(item) {
    String noiDung = "";
    String noiDungTA = "";
    String noiDungTT = "";
    String noiDungTN = "";
    String noiDungTH = "";
    var trangthai = item['userId'] != null ? item['userId'] : 0;
    var vbdiTrichYeuField = item['Title'] != null ? item['Title'] : "";
    var DiaChi = item['DiaChi'] != null ? item['DiaChi'] : "";
    var ID = item['ID'] != null ? item['ID'] : 0;
    var noiDung1 =
        item['CauHoiTiengViet'] != null ? item['CauHoiTiengViet'] : "";
    var noiDungTA1 =
        item['CauHoiTiengAnh'] != null ? item['CauHoiTiengAnh'] : "";
    var noiDungTN1 =
        item['CauHoiTiengNhat'] != null ? item['CauHoiTiengNhat'] : "";
    var noiDungTT1 =
        item['CauHoiTiengTrung'] != null ? item['CauHoiTiengTrung'] : "";
    var noiDungTH1 =
        item['CauHoiTiengHan'] != null ? item['CauHoiTiengHan'] : "";
    var temp = DateFormat("yyyy-MM-dd").parse(item['Created']) != null
        ? DateFormat("yyyy-MM-dd").parse(item['Created'])
        : DateFormat("yyyy-MM-dd").parse(item['Created']);
    var ngaytrinh = DateFormat("dd-MM-yyyy").format(temp);

    // var noiDUng = item['HDPL_NoiDung'] != null ?unescape.convert
    //   (item['HDPL_NoiDung']):"" ;

    HtmlTags.removeTag(
      htmlString: noiDung1,
      callback: (string) {
        noiDung = string;
      },
    );
    HtmlTags.removeTag(
      htmlString: noiDungTA1,
      callback: (string) {
        noiDungTA = string;
      },
    );
    HtmlTags.removeTag(
      htmlString: noiDungTT1,
      callback: (string) {
        noiDungTT = string;
      },
    );
    HtmlTags.removeTag(
      htmlString: noiDungTN1,
      callback: (string) {
        noiDungTN = string;
      },
    );
    HtmlTags.removeTag(
      htmlString: noiDungTH1,
      callback: (string) {
        noiDungTH = string;
      },
    );

    return Card(
        // elevation: 1.5,
        child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                thongTinChiTietWidget(id: ID, title: vbdiTrichYeuField),
          ),
        );
        // : print('tapped');
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 0),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      vbdiTrichYeuField,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    )),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    noiDung != null
                        ? "Nội dung: " + noiDung
                        : (noiDungTA != null
                            ? noiDungTA
                            : (noiDungTT != null
                                ? noiDungTT
                                : (noiDungTN != null
                                    ? noiDungTN
                                    : (noiDungTH != null ? noiDungTH : "")))),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          ngaytrinh,
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xff021029).withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          DiaChi,
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xff4491D5),
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Row(
                  //   children: [
                  //
                  //     Container(
                  //       child: Text(
                  //         "fvdv...",
                  //         style: TextStyle(fontSize: 10, color: Color
                  //           (0xff4491D5), fontWeight: FontWeight.w400,
                  //           fontStyle: FontStyle.normal,),
                  //         overflow: TextOverflow.ellipsis,
                  //
                  //       ),
                  //     ),
                  //
                  // ],),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class HtmlTags {
  static void removeTag({htmlString, callback}) {
    var document = parse(htmlString);
    //String parsedString = parse(document.body!.text).documentElement!.text;
    String parsedString = parse(document.body.text).documentElement.text;
    callback(parsedString);
  }
}
