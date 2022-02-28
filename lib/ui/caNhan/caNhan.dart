import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:pakn2021/core/services/callApi.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/ui/caNhan/thongTinChiTiet.dart';
import 'package:pakn2021/ui/congDong/thongTinChiTiet.dart';
import 'package:pakn2021/ui/main/AppBar.dart';
import 'package:html/parser.dart' show parse;
import 'package:pakn2021/ui/main/CustomAppBar.dart';


class caNhan extends StatefulWidget {


  @override
  _congDongState createState() => _congDongState();
}

class _congDongState extends State<caNhan> {
  List dataList = [];
  bool isLoading = false;
  int tongSo = 0  ;
  String ActionXL = "GetListItemUser";
  int length =20  ;
  ScrollController _scrollerController = new ScrollController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    GetDataDL();
    refreshList();

  }

  GetDataDL() async {


    String getData= await CongAPI.getDataDetailVBCN(ActionXL,CurrentID.toString());
    if (mounted) {
      setState(() {
        dataList.addAll(json.decode(getData)['OData']);
        length+=10;
        tongSo = json.decode(getData)['TotalCount'];
        isLoading = true;
        _scrollerController.addListener(() {
          if (_scrollerController.position.pixels == _scrollerController.position.maxScrollExtent) {
            GetDataDL();
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
        dataList;
        // GetDataHSCV();
      });
    }


    return null;
  }
  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
    return   Scaffold(
        backgroundColor:  Color(0xffFFFFFF),
        // appBar:MainAppBar(title: 'Phản ánh - Kiến nghị',    ) ,

        body: Stack(children: [
          MainAppBarCN(title: 'Phản ánh cá nhân'.toUpperCase(),   ),
          Padding(
            padding: const EdgeInsets.only(top: 110),
            child: GetData(),
          )
        ],),
      // drawer:Drawer(
      //   child: ListView(
      //     children: <Widget>[
      //       Container(
      //         color:Colors.white12,
      //         height: MediaQuery.of(context).size.height /13,
      //         child: DrawerHeader(
      //           child:InkWell(
      //             onTap: (){
      //
      //             } ,
      //             child:  Container(
      //               child: Text("",
      //                 style: TextStyle(
      //                     fontSize: 18,
      //                     color: Color(0xff000000)
      //                 ),
      //               ),
      //             ),),
      //         ),
      //       ),
      //
      //
      //
      //     ],
      //   ),
      // ),
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
    return RefreshIndicator(key: refreshKey,
        child: ListView.builder(
          itemCount: dataList == null ? 0 : dataList.length,padding: EdgeInsets.all(10),
          itemBuilder: (context, index) {
            if(index == tongSo){
              _buildProgressIndicator();
            }else{
              return getCard(dataList[index]);
            }
          },
          controller: _scrollerController,
        ),
        onRefresh: refreshList);


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
    var trangthai = item['TrangThaiXuLy'] != null ? item['TrangThaiXuLy'] : 0;
    var vbdiTrichYeuField = item['Title'] != null ?item['Title'] : "";
    var DiaChi = item['DiaChi'] != null ?item['DiaChi'] : "";
    var ID = item['ID'] != null ? item['ID']: 0;
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
                builder: (context) => thongTinKienNghi(id:ID,
                    title:vbdiTrichYeuField
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
                trangthai ==3? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   Padding(
                      padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                      child: Container(
                          padding: EdgeInsets.only(top: 10,left: 10,right:
                          10,bottom: 10),
                          height:MediaQuery.of(context).size.height*0.045,
                          width:MediaQuery.of(context).size.width*0.34 ,color:
                      Color(0xffFFEAEC),
                          child: Text(
                            "Kiến nghị bị từ chối",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff9D131F),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          )) ,
                    ),

                    Row(children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.7,
                        child:  Column(children: [
                        Container(
                            padding: EdgeInsets.only(top: 10,left: 10),
                            width: MediaQuery.of(context).size.width*0.9 ,
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

                        Container(
                          width: MediaQuery.of(context).size.width*0.9 ,
                          padding: EdgeInsets.only(top:8,left: 10),
                          child: Text(
                            noiDung != null?"Nội dung: "+noiDung:"",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,),
                            maxLines: 3,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],),),
                      // Container(
                      //   padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                      //   width: MediaQuery.of(context).size.width*0.23,
                      //   child:  Image(
                      //     // height: 122,
                      //     width: MediaQuery.of(context).size.width,
                      //     image: AssetImage('assets/duan.jpg'),
                      //   ),
                      //
                      // )
                    ],),

                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10,top:12,
                          bottom: 10),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                        ],),
                    )

                  ],
                )
                    :Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    trangthai ==1?Padding(
                      padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                      child: Container(
                          padding: EdgeInsets.only(top: 10,left: 10,right:
                          10,bottom: 10),
                          height:MediaQuery.of(context).size.height*0.045,
                          width:MediaQuery.of(context).size.width*0.2 ,color:
                      Color(0xffFBEFD7),
                          child: Text(
                            "Đang xử lý",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xffFC8415),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          )) ,
                    ):SizedBox(),
                   trangthai==2?Padding(
                      padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                      child: Container(
                          padding: EdgeInsets.only(top: 10,left: 10,right:
                          10,bottom: 10),
                          height:MediaQuery.of(context).size.height*0.045,
                          width:MediaQuery.of(context).size.width*0.18 ,color:
                      Color(0xffCDFFF3),
                          child: Text(
                            "Đã trả lời",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xff14C196),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          )) ,
                    ):SizedBox(),

                    Container(
                        padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                        width: MediaQuery.of(context).size.width*0.9 ,
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
                    SizedBox(height: 8,),

                    Container(
                      width: MediaQuery.of(context).size.width*0.9,
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Text(
                        noiDung != null?"Nội dung: "+noiDung:"",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,),
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [ Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
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



                      ],)
                  ],
                ),

              ],
            ),
          ),
        ));
  }

}class HtmlTags {

  static void removeTag({ htmlString, callback }){
    var document = parse(htmlString);
    //String parsedString = parse(document.body!.text).documentElement!.text;
    String parsedString = parse(document.body.text).documentElement.text;
    callback(parsedString);
  }
}