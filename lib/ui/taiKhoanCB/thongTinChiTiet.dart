import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:hb_check_code/hb_check_code.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pakn2021/core/services/callApi.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/core/models/phanAnhKienNghiJson.dart';
import 'package:pakn2021/ui/main/showThongBao.dart';
import 'package:pakn2021/ui/main/show_image.dart';
import 'package:pakn2021/ui/main/show_mp3.dart';
import 'package:pakn2021/ui/taiKhoanCB/bottomNavigationBar.dart';
import 'package:pakn2021/ui/taiKhoanCB/viewPDF.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:html/parser.dart' show parse;

class thongTinChiTietWidget extends StatefulWidget {
  final int id;
  final String title;

  thongTinChiTietWidget({Key key, this.id, this.title}) : super(key: key);

  @override
  _thongTinChiTietWidgetState createState() => _thongTinChiTietWidgetState();
}

class _thongTinChiTietWidgetState extends State<thongTinChiTietWidget> {
  bool isLoading = false;
  List dataList = [];
  var rating = 0.0;
  var ratingCD = 0.0;
  int random;
  var vanBan = null;
  RxBool checkplay = false.obs;
  RxBool checkplayTL = false.obs;
  final HtmlEditorController controller = HtmlEditorController();
  TextEditingController textEditingControllerMaBaoMat = new TextEditingController();
  int code ;
  File selectedfile;
  var player = new AudioPlayer();
  var player1 = new AudioPlayer();
  var now = new DateTime.now();
  Random rnd = new Random();
  String image = "";
  String mp3 = "";
  String pdfVB = "";
  String linkImage = "";
  String linkMp3 = "";
  String linkPdf = "";
  @override
  void initState() {
    super.initState();
    GetDataChiTiet();
    ramdom();
  }
  @override
  void dispose() {
    super.dispose();
    player.stop();
    player1.stop();
  }

  GetDataChiTiet() async {
    String getData = await CongAPI.getDataDetail(widget.id);
    var data = json.decode(getData)['OData'];
    if (mounted) {
      setState(() {
        vanBan = phanAnhKNJson.fromJson(data);
        vanBanTT = vanBan;
        isLoading = true;
      });
    }
  }
  GetDataMP3(String title) async {
    String getData = await CongAPI.getDataMP3(title);
    var data = json.decode(getData)["async"];
    player.play(data);
    if (mounted) {
      setState(() {
      });
    }
  }
  GetDataMP33(String title) async {
    String getData = await CongAPI.getDataMP3(title);
    var data = json.decode(getData)["async"];
    player1.play(data);
    if (mounted) {
      setState(() {

      });
    }
  }
  void ramdom() {
    // for (var i = 0; i < 6; i++) {
    //   code = code + Random().toString();
    // }
    int min = 10000;
    int max = 99999;
    code = min + rnd.nextInt(max - min);

  }
  selectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4', 'doc'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.single.path);
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    phanAnhKNJson vban = vanBan;

    phanAnhKNJson vbanXL;
    if(vban!= null){
      TrangThaiXuLy = vban.TrangThaiXuLy;
      ModerationStatus = vban.moderationStatus;
       vbanXL = new phanAnhKNJson(NguoiHoiText:vban.NguoiHoiText
          != null?vban.NguoiHoiText:"",
        Email: vban.Email!= null?vban.Email:"",
        DiaChi: vban.DiaChi!= null?vban.DiaChi:"",
        SDT: vban.SDT!= null?vban.SDT:"",

      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nội dung chi tiết phản ánh, kiến nghị'.toUpperCase(),
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal),
        ),
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios_sharp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xff3064D0),
      ),
      body: isLoading == false
          ? Center(
          child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)))
          : getBody(),
      bottomNavigationBar:BottomCN(id:widget.id,vbanXL:vbanXL) ,
    );
  }

  Widget getBody() {
    Size size = MediaQuery.of(context).size;
    phanAnhKNJson vban = vanBan;
    String nd ="";
    String ndTL ="";
    if(vban != null){
      pdf = vban.linkPDF;
    }
    if(vban.CauHoiTiengViet != null)
    HtmlTags.removeTag(
      htmlString: vban.CauHoiTiengViet,
      callback: (string) {
        nd = string;
      },
    );
    if(vban.TraLoiTiengViet!= null)
    HtmlTags.removeTag(
      htmlString: vban.TraLoiTiengViet,
      callback: (string) {
        ndTL = string;
      },
    );

    for(var i in vban.tenPDF){

      if(i['FileName'].contains("png") || i['FileName'].contains("jpg")){
        linkImage = i['Url'];
        image = i['FileName'];
        print("anh" +image.toString());
      }
      if(i['FileName'].contains("mp3")){
        linkMp3 = i['Url'];
        mp3 = i['FileName'];
        print("anh" +mp3.toString());
      }
      if(i['FileName'].contains("pdf")){

        pdfVB = i['FileName'];
        linkPdf = i['Url'];
        print("anh" +pdfVB.toString());
        print("anh" +linkPdf.toString());
      }
    }


    return vban.TrangThaiXuLy ==2 || vban.TrangThaiXuLy ==4
        ? ListView(
      children: [
         Column(
          children: [
            // Center(
            //   child: Padding(
            //     padding: EdgeInsets.all(10),
            //     child: Image(
            //       // height: 122,
            //       width: MediaQuery.of(context).size.width,
            //       image: AssetImage('assets/duan.jpg'),
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                     width: MediaQuery.of(context).size.width * 0.3,
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

                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    widget.title,
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
                     width: MediaQuery.of(context).size.width * 0.3,
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
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.TrangThaiAnHien == true? "Người gửi yêu cầu ẩn thông tin":vban.NguoiHoiText ,
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
                     width: MediaQuery.of(context).size.width * 0.3,
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
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.TrangThaiAnHien == true? "Người gửi yêu cầu ẩn thông tin":vban.Email,
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
                     width: MediaQuery.of(context).size.width * 0.3,
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
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.TrangThaiAnHien == true? "Người gửi yêu cầu ẩn thông tin":vban.DiaChi,
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
                     width: MediaQuery.of(context).size.width * 0.3,
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
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.TrangThaiAnHien == true? "Người gửi yêu cầu ẩn thông tin":vban.SDT,
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
                     width: MediaQuery.of(context).size.width * 0.3,
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
                    width: MediaQuery.of(context).size.width * 0.7,
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
                        child: Text(
                          "Câu hỏi ",
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
                  width: MediaQuery.of(context).size.width * 0.5,
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Obx(
                        () => checkplayTL.value == false
                        ? Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            GetDataMP33(nd);
                            player.stop();
                            checkplayTL.value = true;
                            checkplay.value = false;

                          },
                          icon: Icon(
                            Icons.volume_down,
                            color: Colors.blue,
                          ),
                        ))
                        : Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            player1.stop();
                            checkplayTL.value = false;
                          },
                          icon: Icon(
                            Icons.volume_off,
                            color: Colors.blue,
                          ),
                        )),
                  ),
                ),
              ],
            ),
            Divider(),
            pdfVB!=""&& pdfVB!=null ?
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "PDF",
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
                    InkWell(
                      onTap: (){
                        Get.to(ViewPDFVB(linkpdf:linkPdf));
                        //showAlertDialog(context,"sadgdsagd");

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                        child: Text(
                          pdfVB,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.75),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),

                  ],
                ), Divider(),
              ],
            )
                :SizedBox(),
            image!=""&& image!=null ?
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Ảnh",
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
                    InkWell(
                      onTap: (){
                        Get.to(showImage(linkImage:linkImage));
                        //showAlertDialog(context,"sadgdsagd");

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                        child: Text(
                          image,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.75),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),

                  ],
                ), Divider(),
              ],
            )
                :SizedBox(),

            mp3!=""&& mp3!=null?
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "MP3",
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
                  InkWell(
                    onTap: (){
                      Get.to(showMP3(mp3:mp3,linkMp3:linkMp3));
                      //showAlertDialog(context,"sadgdsagd");

                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                      child: Text(
                        mp3,
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.75),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),

                ],
              ),
              Divider(),
            ],)
                :SizedBox(),

            SizedBox(height: 20,),
            Center(
                child: Text(
                  "Phúc đáp",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xffFC8415),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                )),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                     width: MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Cơ quan",
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
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.TraLoiCoQuanTraLoi != null?vban.TraLoiCoQuanTraLoi:"" ,
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
                     width: MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Người phúc đáp",
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
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.TraLoiNguoiTraLoi != null ?vban.TraLoiNguoiTraLoi:"",
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
                     width: MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Ngày phúc đáp",
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
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
    vban.TraLoiNgayTraLoi!= null && vban.TraLoiNgayTraLoi!=""?  GetDate(vban.TraLoiNgayTraLoi):"",
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
                        child: Text(
                          "Trả lời",
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
                    width: MediaQuery.of(context).size.width * 0.7,
                   padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    ndTL,
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
            pdfVB!=""&& pdfVB!=null ?
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "PDF",
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
                    InkWell(
                      onTap: (){
                        Get.to(ViewPDFVB(linkpdf:linkPdf));
                        //showAlertDialog(context,"sadgdsagd");

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                        child: Text(
                          pdfVB,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.75),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),

                  ],
                ), Divider(),
              ],
            )
                :SizedBox(),
            image!=""&& image!=null ?
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Ảnh",
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
                    InkWell(
                      onTap: (){
                        Get.to(showImage(linkImage:linkImage));
                        //showAlertDialog(context,"sadgdsagd");

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                        child: Text(
                          image,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.75),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),

                  ],
                ), Divider(),
              ],
            )
                :SizedBox(),

            mp3!=""&& mp3!=null?
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            "MP3",
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
                  InkWell(
                    onTap: (){
                      Get.to(showMP3(mp3:mp3,linkMp3:linkMp3));
                      //showAlertDialog(context,"sadgdsagd");

                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                      child: Text(
                        mp3,
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.75),
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),

                ],
              ),
              Divider(),
            ],)
                :SizedBox(),

          ],
        )
      ],
    )
        :ListView(
      children: [
        Column(
          children: [
            // Center(
            //   child: Padding(
            //     padding: EdgeInsets.all(10),
            //     child: Image(
            //       // height: 122,
            //       width: MediaQuery.of(context).size.width,
            //       image: AssetImage('assets/duan.jpg'),
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                     width: MediaQuery.of(context).size.width * 0.3,
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

                    ],
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    widget.title,
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
                     width: MediaQuery.of(context).size.width * 0.3,
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
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.TrangThaiAnHien == true? "Người gửi yêu cầu ẩn thông tin":vban.NguoiHoiText ,
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
                     width: MediaQuery.of(context).size.width * 0.3,
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
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.TrangThaiAnHien == true? "Người gửi yêu cầu ẩn thông tin":vban.Email,
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
                     width: MediaQuery.of(context).size.width * 0.3,
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
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.TrangThaiAnHien == true? "Người gửi yêu cầu ẩn thông tin": vban.DiaChi,
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
                     width: MediaQuery.of(context).size.width * 0.3,
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
                    width: MediaQuery.of(context).size.width * 0.7,
                  padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                  child: Text(
                    vban.TrangThaiAnHien == true? "Người gửi yêu cầu ẩn thông tin": vban.SDT,
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
                     width: MediaQuery.of(context).size.width * 0.3,
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
                    width: MediaQuery.of(context).size.width * 0.7,
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
                     width: MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          "Câu hỏi",
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
                    nd,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.75),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Obx(
                        () => checkplayTL.value == false
                        ? Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            GetDataMP33(nd);
                            player.stop();
                            checkplayTL.value = true;
                            checkplay.value = false;

                          },
                          icon: Icon(
                            Icons.volume_down,
                            color: Colors.blue,
                          ),
                        ))
                        : Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            player1.stop();
                            checkplayTL.value = false;
                          },
                          icon: Icon(
                            Icons.volume_off,
                            color: Colors.blue,
                          ),
                        )),
                  ),
                ),
              ],
            ),
            Divider(),
            pdfVB!=""&& pdfVB!=null ?
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Container(
                                child: Text(
                                  "PDF",
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
                        InkWell(
                          onTap: (){
                            Get.to(ViewPDFVB(linkpdf:linkPdf));
                            //showAlertDialog(context,"sadgdsagd");

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                            child: Text(
                              pdfVB,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.75),
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),

                      ],
                    ), Divider(),
                  ],
                )
           :SizedBox(),
            image!=""&& image!=null ?
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Ảnh",
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
                    InkWell(
                      onTap: (){
                        Get.to(showImage(linkImage:linkImage));
                        //showAlertDialog(context,"sadgdsagd");

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                        child: Text(
                          image,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.75),
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),

                  ],
                ), Divider(),
              ],
            )
                :SizedBox(),

            mp3!=""&& mp3!=null?
                Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        padding: EdgeInsets.only(left: 20.0),
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                "MP3",
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
                      InkWell(
                        onTap: (){
                          Get.to(showMP3(mp3:mp3,linkMp3:linkMp3));
                          //showAlertDialog(context,"sadgdsagd");

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding: EdgeInsets.fromLTRB(15, 15, 10, 10),
                          child: Text(
                            mp3,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.75),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 13),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Divider(),
                ],)
            :SizedBox(),


            SizedBox(height: 20,),
            Center(
                child: Text(
                  "Chưa có thông tin phúc đáp",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xffFC8415),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                )),
            SizedBox(height: 70,),


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
