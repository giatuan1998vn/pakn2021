import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;
import 'package:pakn2021/core/models/phanAnhKienNghiJson.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/ui/main/showThongBao.dart';
import 'package:pakn2021/ui/taiKhoanCB/components/coQuanTL.dart';
import 'package:pakn2021/ui/taiKhoanCB/phanAnh.dart';

class phanXuLy extends StatefulWidget {
  final int id;

  phanXuLy({Key key, this.id}) : super(key: key);

  @override
  _phanXuLyState createState() => _phanXuLyState();
}

class _phanXuLyState extends State<phanXuLy> {
  bool isLoading = false;
  List dataList = [];
  var rating = 0.0;
  var ratingCD = 0.0;
  int random;
  var vanBan = null;
  String idLoaiVBN = "";
  List<ListData> vanbanList = [];
  TextEditingController _controller = TextEditingController(text: 5.toString());

  var IDCoQuan;
  List<ListData> ListDataCQ = [];

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
            (vanban as List).map((e) => ListData.fromJson(e)).toList();
        lstData.forEach((element) {
          ListDataCQ.add(element);
          vanbanList = ListDataCQ;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phân xử lý"),
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
    String nd = "";
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
                          "Trả lời cơ quan trả lời",
                          style: TextStyle(
                              color: Color(0xff021029),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.53,
                  height: size.height / 15,
                  // padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 10, right: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8))),

                  child: SearchServer(
                    listData: vanbanList,
                    multipleSelection: true,
                    // text: Text("Hya"),
                    title: "Hãy chọn đơn vị",
                    // searchHintText: 'Tìm kiếm',
                    onSaved: (value) {
                      print("value" + value.toString());
                      if (mounted) {
                        setState(() {
                          idLoaiVBN = value.join(',');
                          print(value.join(','));
                          // displays 'onetwothree'

                          // for(var item in value){
                          //   if(idLoaiVBN != null){
                          //     idLoaiVBN += (item.toString()) +"," ;
                          //   }
                          //   print(idLoaiVBN);
                          // }
                          // if(idLoaiVBN != null && idLoaiVBN.length>0)
                          //   idLoaiVBN =  idLoaiVBN.substring(0,idLoaiVBN.length-1);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Thời gian xử lý",
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.53,
                  //height: size.height /8,
                  // padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 10, right: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8))),

                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _controller,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          // inputFormatters: <TextInputFormatter>[
                          //   WhitelistingTextInputFormatter.digitsOnly
                          // ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          MaterialButton(
                            // minWidth: 1.0,
                            child: Icon(Icons.arrow_drop_up),
                            onPressed: () {
                              int currentValue = int.parse(_controller.text);
                              setState(() {
                                currentValue++;
                                _controller.text = (currentValue)
                                    .toString(); // incrementing value
                              });
                            },
                          ),
                          MaterialButton(
                            //minWidth: 1.0,
                            child: Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              int currentValue = int.parse(_controller.text);
                              setState(() {
                                print("Setting state");
                                currentValue--;
                                _controller.text = (currentValue)
                                    .toString(); // decrementing value
                              });
                            },
                          ),
                        ],
                      ),
                      Spacer(
                        flex: 1,
                      )
                    ],
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
                              fontSize: 14),
                          overflow: TextOverflow.visible,
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
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 0),
                  child: TextButton.icon(
                      icon: Icon(Icons.send_and_archive),
                      label: Text('Cập nhật',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        EasyLoading.show();
                        // var thoiGian = _dateController
                        //     .text.toString();
                        var thanhcong = await CongAPI.postPhanXL(
                            widget.id,
                            "P"
                            "hanXuLy",
                            idLoaiVBN,
                            _controller.text);

                          EasyLoading.dismiss();

                          Navigator.of(context).pop();
                        showAlertDialogPXL(
                              context, json.decode(thanhcong)['Message']);


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
                      // child: Text("Đóng lại",style: TextStyle(fontWeight: FontWeight.bold),),
                      icon: Icon(Icons.delete_forever),
                      label: Text('Đóng lại',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        EasyLoading.dismiss();
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
