import 'dart:convert';
import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pakn2021/core/services/callApi.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/core/services/facebook_login_controller.dart';
import 'package:pakn2021/core/services/google_login_controller.dart';
import 'package:pakn2021/ui/congDong/thongTinChiTiet.dart';
import 'package:pakn2021/ui/login/login.dart';
import 'package:pakn2021/ui/login/phanQuyen.dart';
import 'package:pakn2021/ui/login/splash.dart';
import 'package:pakn2021/ui/main/gioiThieu.dart';
import 'package:pakn2021/ui/main/showThongBao.dart';
import 'package:pakn2021/ui/main/traCuu.dart';
import 'package:pakn2021/ui/res/strings.dart';
import 'package:pakn2021/ui/taoPhanAnh/guiTrucTiep.dart';
import 'package:pakn2021/ui/trangChu/timKiem.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' show parse;


class trangChu extends StatefulWidget {


  @override
  _congDongState createState() => _congDongState();
}

class _congDongState extends State<trangChu> {
  List dataList = [];
  bool isLoading = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  int length = 20 ;
  String ActionXL = "GetListItemTraCuu";
  ScrollController _scrollerController = new ScrollController();
  int tongSo = 0;
  String ndGoi ="";
  String ndSMS ="";
  String ndGmail ="";
  String title="";

  @override
  void initState() {
    super.initState();
    GetDataDL();
    GetUser();
    refreshList();


  }
  Widget getBodyKN(){
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
          SizedBox(height: 20,),
          Container(

            alignment: Alignment.center,

            child: Text("Không có kiến nghị nào",style: TextStyle(fontSize:
            14,fontStyle: FontStyle.normal,fontWeight: FontWeight.w500,
                color: Color(0xff021029).withOpacity(0.75)),),
          ),
        ],),
    );
  }
  GetUser() async {

    String getData= await CongAPI.getUserCN();
    if (mounted) {
      setState(() {
        // dataList += json.decode(vbden)['OData'];
        CurrentID=  (json.decode(getData)['OData']['ID']);

      });}

  }

  GetDataDL() async {
    String getData= await CongAPI.getDataDetailVBTraCuu(ActionXL,"","","","",length);
    if (mounted) {
      setState(() {
        // dataList += json.decode(vbden)['OData'];
        dataList.addAll(json.decode(getData)['OData']);
        tongSo = json.decode(getData)['TotalCount'];
        length+=10;
        isLoading = true;
        _scrollerController.addListener(() {
          if (_scrollerController.position.pixels == _scrollerController.position.maxScrollExtent) {
            GetDataDL();
            // GetDataByKeyYearVBDen(dropdownValue);
            dataList;
          }


        });

      });}

  }
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if(mounted){
      setState(() {
        GetData();
        // GetDataHSCV();
      });
    }


    return null;
  }

  Future<void> _makePhoneCall(String contact, bool direct) async {
    if (direct == true) {
      bool res = await FlutterPhoneDirectCaller.callNumber(contact);
    } else {
      String telScheme = 'tel:$contact';

      if (await canLaunch(telScheme)) {
        await launch(telScheme);
      } else {
        throw 'Could not launch $telScheme';
      }
    }
  }
  openEmail() async {
    launch(
   " mailto:codingwithdhrumil@gmail.com?subject=Test Email&body=Test Description");
  }
  Future Format(int id) async
  {
    var thanhcong = await CongAPI.GetHuongDan(id);
    var thongbao = jsonDecode(thanhcong)["NoiDung"];
     title = jsonDecode(thanhcong)["Title"];

    HtmlTags.removeTag(
      htmlString: thongbao,
      callback: (string) {
        ndGoi = string;
      },
    );
    HtmlTags.removeTag(
      htmlString: thongbao,
      callback: (string) {
        ndSMS = string;
      },
    );
    HtmlTags.removeTag(
      htmlString: thongbao,
      callback: (string) {
        ndGmail = string;
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    Size size =  MediaQuery.of(context).size;
    return  Scaffold(
        backgroundColor:  Color(0xffFFFFFF),
        appBar:AppBar(title: Center(child:Row(
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image(
          height: 50,
          image: AssetImage('assets/logovp.png'),
        ),
          SizedBox(width: 8,),
          Text("VĨNH PHÚC",
          style: TextStyle
          (fontSize: 18,fontWeight: FontWeight.w700,fontStyle: FontStyle.normal),
        ) ],),),
    leading: Builder(builder: (context) => // Ensure Scaffold is in context
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: Image.asset(
          "assets/menuleft.png",
          fit:BoxFit.fill,
          height: 20,
          width: 20,
        ),
      ),
    ),),
        backgroundColor: Color(0xff3064D0),),


        body:  Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: InkWell(
                  onTap: (){
                      Get.to(guiTrucTiep());

                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (context) => LinhVucPage()),
                    //         (Route<dynamic>route) => true);

                  },
                  child:
                  Container(margin: EdgeInsets.only(left: 12,top:12),
                    height: size.height*0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffF32733),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(

                          child: Image(
                            height:size.height*0.05,
                            image: AssetImage('assets/contractp.png'),
                          ),
                        ),

                        SizedBox(height: 11,),
                        Text("GỬI TRỰC TIẾP",style: TextStyle
                          (fontSize: 13,color: Colors.white,
                            fontWeight:FontWeight.bold),),
                        // SizedBox(height: 8,),
                        // Text("THANH NIÊN",style: TextStyle
                        //   (fontSize: 14,color: Colors.white,
                        //     fontWeight:FontWeight.bold),),

                      ],
                    ),//BoxDecoration
                  ),), //Container
              ), //Flexible
              SizedBox(
                width: 12,
              ), //SizedBox
              Flexible(
                flex: 1,
                fit: FlexFit.tight,

                child: InkWell(

                onTap: () async{
                  var ndgoi ="";
                  var thanhcong = await CongAPI.GetHuongDan(2);
                  var thongbao = jsonDecode(thanhcong)["NoiDung"]!=
                      null?jsonDecode(thanhcong)["NoiDung"]:"";
                  var title1 = jsonDecode(thanhcong)["Title"]!= null ?
                  jsonDecode(thanhcong)["Title"]:"";

                  HtmlTags.removeTag(
                    htmlString: thongbao,
                    callback: (string) {
                      ndgoi = string;
                    },
                  );
                  // Format(2) ;
                  showAlertDialog2(context,ndgoi,title1);
                },
                  child: Container(
                      margin: EdgeInsets.only(right: 12,top:12),
                      height: size.height*0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0XFFFFBD3E),
                      ) ,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(

                              child: Image(
                                height:size.height*0.05,
                                image: AssetImage('assets/phone.png'),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text("GỌI ĐIỆN".toUpperCase(),style: TextStyle
                              (fontSize: 13,color: Colors.white,
                                fontWeight:FontWeight.bold),),

                          ],
                        ),
                      )//BoxDecoration
                  ),

                ), //Container
              ), //Flexible
            ], //<Widget>[]

          ),
          SizedBox(height: 12,),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: InkWell(
                  onTap: () async{
                    var ndsms ="";
                    var thanhcong = await CongAPI.GetHuongDan(3);
                    var thongbao = jsonDecode(thanhcong)["NoiDung"]!=
                        null?jsonDecode(thanhcong)["NoiDung"]:"";
                    var title1 = jsonDecode(thanhcong)["Title"]!= null ?
                    jsonDecode(thanhcong)["Title"]:"";

                    HtmlTags.removeTag(
                      htmlString: thongbao,
                      callback: (string) {
                        ndsms = string;
                      },
                    );
                    // Format(2) ;
                    showAlertDialog2(context,ndsms,title1);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 12),
                    height: size.height*0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff7C3EFF),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(

                          child: Image(
                            height:size.height*0.05,
                            image: AssetImage('assets/email.png'),
                          ),
                        ),

                        SizedBox(height: 11,),
                        Text("GỬI TIN NHẮN",style: TextStyle
                          (fontSize: 13,color: Colors.white,
                            fontWeight:FontWeight.bold),),

                      ],
                    ),//BoxDecoration
                  ),), //Container
              ), //Flexible
              SizedBox(
                width: 20,
              ), //SizedBox
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: InkWell(
                  onTap: () async{
                    var ndemail ="";
                    var thanhcong = await CongAPI.GetHuongDan(4);
                    var thongbao = jsonDecode(thanhcong)["NoiDung"]!=
                        null?jsonDecode(thanhcong)["NoiDung"]:"";
                    var title1 = jsonDecode(thanhcong)["Title"]!= null ?
                    jsonDecode(thanhcong)["Title"]:"";

                    HtmlTags.removeTag(
                      htmlString: thongbao,
                      callback: (string) {
                        ndemail = string;
                      },
                    );
                    // Format(2) ;
                    showAlertDialog2(context,ndemail,title1);
                  },
                  child: Container(
                      margin: EdgeInsets.only(right:12),
                      height: size.height*0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0XFF00A137),
                      ) ,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(

                              child: Image(
                                height:size.height*0.05,
                                image: AssetImage('assets/arroba.png'),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text("GỬI EMAIL".toUpperCase(),style: TextStyle
                              (fontSize: 13,color: Colors.white,
                                fontWeight:FontWeight.bold),),




                          ],
                        ),
                      )//BoxDecoration
                  ),

                ), //Container
              ), //Flexible
            ], //<Widget>[]
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(height: 5,),
          Divider(),
          Container(
              margin: EdgeInsets.only(left: 17),
              alignment: Alignment.topLeft,
              child:Text("Phản hồi mới nhất",style: TextStyle(fontSize:
              14,fontWeight: FontWeight.w500),)),
          SizedBox(height: 10,),
          Expanded(child: GetData()),


        ],),
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
         //    Container(
         //      color: Colors.white12,
         // height: MediaQuery.of(context).size.height /13,
         //      child: DrawerHeader(
         //          child:InkWell(
         //            onTap: (){
         //
         //
         //            } ,
         //            child:  Container(
         //            child: Text("",
         //              style: TextStyle(
         //                  fontSize: 18,
         //                  color: Color(0xff000000)
         //              ),
         //            ),
         //          ),),
         //      ),
         //    ),
         //

            ListTile(
              title: Text('Tra cứu',
                style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,
                    fontStyle: FontStyle.normal,color: Color(0xff15182E)),
              ),
              onTap: (){
                Navigator.of(context)
                    .push(MaterialPageRoute(builder:
                    (_) => traCuuWidget() ,));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Tìm kiếm',
                style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,
                    fontStyle: FontStyle.normal,color: Color(0xff15182E)),
              ),
              onTap: (){
                Navigator.of(context)
                    .push(MaterialPageRoute(builder:
                    (_) => timKiem() ,));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Giới thiệu',
                style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,
                    fontStyle: FontStyle.normal,color: Color(0xff15182E)),
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => gioiThieu()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Đăng xuất',
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff000000)
                ),
              ),
              onTap: (){
                Provider.of<GoogleSignInController>(context, listen:
                false).logOut();
                Provider.of<FacebookSignInController>(context, listen:
                false).logIut();
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (BuildContext context) => phanQuyenLogin()), (Route<dynamic> route) => false);
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
  Widget GetData() {
    if (dataList.contains(null) || dataList.length < 0 || isLoading==false) {
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
            SizedBox(height: 20,),
            Container(

              alignment: Alignment.center,

              child: Text("Không có kiến nghị nào",style: TextStyle(fontSize:
              14,fontStyle: FontStyle.normal,fontWeight: FontWeight.w500,
                  color: Color(0xff021029).withOpacity(0.75)),),
            ),
          ],),
      );
    }
    return RefreshIndicator(
      onRefresh: refreshList,
       key: refreshKey,
      child:ListView.builder(
      itemCount: dataList == null ? 0 : dataList.length,padding: EdgeInsets.all(10),
      itemBuilder: (context, index) {
        if(index == tongSo){
          _buildProgressIndicator();
        }else{
          return getCard(dataList[index]);
        }
      },
        controller: _scrollerController,
    ) ,)
      ;
  }
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity:isLoading ? 1.0 : 00,
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
    var vbdiTrichYeuField = item['Title'] != null ?item['Title'] : "";
    var DiaChi = item['DiaChi'] != null ?item['DiaChi'] : "";
    var sMIDField = item['ID'] != null ? item['ID']: 0;
    var noiDung1 = item['CauHoiTiengViet'] != null ? item['CauHoiTiengViet']:"";
    var noiDungTA1 = item['CauHoiTiengAnh'] != null ?
    item['CauHoiTiengAnh']:"";
    var noiDungTN1 = item['CauHoiTiengNhat'] != null ?
    item['CauHoiTiengNhat']:"";
    var noiDungTT1 = item['CauHoiTiengTrung'] != null ?
    item['CauHoiTiengTrung']:"";
    var noiDungTH1= item['CauHoiTiengHan'] != null ?
    item['CauHoiTiengHan']:"";
    var temp =  DateFormat("yyyy-MM-dd").parse(item['Created']) != null ?DateFormat("yyyy-MM-dd").parse
      (item['Created']) : DateFormat("yyyy-MM-dd").parse(item['Created']);
    var ngaytrinh = DateFormat("dd-MM-yyyy").format(temp);

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
                builder: (context) => thongTinKienNghi(id:sMIDField,title:vbdiTrichYeuField
                ),
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
                        padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                        width: MediaQuery.of(context).size.width*0.9 ,
                        child: Text(
                          vbdiTrichYeuField,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        )),
                    SizedBox(height: 8,),

                    Container(
                      width: MediaQuery.of(context).size.width*0.9,
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Text(
                        noiDung != null?"Nội dung: "+noiDung :(noiDungTA !=null
                            ?noiDungTA:(noiDungTT!= null?noiDungTT:
                        (noiDungTN != null? noiDungTN:(noiDungTH
                            !=null?noiDungTH:"")))),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,),
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10,top:12,
                          bottom: 10),
                      child:  Row(
                        children: [
                          Row(children: [ Container(

                            child: Text(
                              ngaytrinh,
                              style: TextStyle(fontSize: 10, color: Color
                                (0xff021029).withOpacity(0.5), fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,),
                              overflow: TextOverflow.ellipsis,

                            ),
                          ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.7,
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                DiaChi,
                                style: TextStyle(fontSize: 10, color: Color
                                  (0xff4491D5), fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,),
                                overflow: TextOverflow.ellipsis,

                              ),
                            ),],),

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



                        ],) ,
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

  static void removeTag({ htmlString, callback }){
    var document = parse(htmlString);
    //String parsedString = parse(document.body!.text).documentElement!.text;
    String parsedString = parse(document.body.text).documentElement.text;
    callback(parsedString);
  }
}