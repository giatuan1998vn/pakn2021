import 'package:flutter/material.dart';
import 'package:pakn2021/core/services/callApi.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/ui/congDong/congDong.dart';
import 'package:pakn2021/ui/congDong/cong_dongPAKN.dart';
import 'package:pakn2021/ui/taiKhoanCB/phanAnh.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class MenuLeftCD extends StatefulWidget {
  int page;
  final String year;
  final String username;
  final String  queryLeft;
  final String  ActionXL;
  final int queryID;


  MenuLeftCD({this.page,this.username, this.year,this.queryLeft, this.queryID,
    this.ActionXL});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Menuleft();
  }

}

class _Menuleft extends State<MenuLeftCD>  {
  ScrollController _scrollController = new ScrollController();
  List menuleft = [];
  List data = [];
  bool isLoading = false;
  int _currentIndex =1;
  int indexVB ;
  String urlttVB = '';
  var tendangnhap = "";
  bool checker = false;
  int tappedIndex;
  String nam =  "";
  SharedPreferences sharedStorage;
  SharedPreferences viTriHienTai;
  @override
  void initState() {
    // TODO: implement initState
    //  if(getString("username"))
    this.getMenu();
    isLoading = true;
    //tappedIndex = 0;
    // if (mounted) {setState(() {
    //   // nam =  widget.year;
    // });}

    super.initState();
    // _scrollController.animateTo(
    //   0.0,
    //   curve: Curves.easeOut,
    //   duration: const Duration(milliseconds: 500),
    // );

  }
  getMenu() async {

    isLoading = true;
    String item = await CongAPI.GetMenuLeft(widget.ActionXL);
    if (mounted) {setState(() {
      isLoading = false;
      menuleft = json.decode(item)['OData'];
      for( int i= 0 ; i< menuleft.length; i++)
      {

        print("IDTT: "+IDTT.toString());
        if(menuleft[i]['id'] == IDTT)
          tappedIndex = i;
      }

    });}

  }

  @override
  Widget build(BuildContext context) {
    return  MenuLeftData();
  }

  Widget MenuLeftData() {

    if (menuleft== null|| menuleft.length < 0 || isLoading) {
      //isLoading = !isLoading;
      return Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ));
    } else if (menuleft.length == 0) {
      return Center(
        child: Text("Không có bản ghi"),
      );}
    return ListView.builder(controller: _scrollController,
        itemCount: menuleft == null ? 0 :menuleft.length,
        itemBuilder: (context, index) {
          return
            Container(
              // height: MediaQuery.of(context).size.height,
              //margin: EdgeInsets.only(bottom: 10),
                color: tappedIndex == index  ? Colors.blue : Colors.white,
                child:GetBodyMenuLeft(menuleft[index]))

          ;
        }
    );

  }

  Widget GetBodyMenuLeft(item) {
    var title = item['Title']!= null ?item['Title']:"";
    var TrangThaiXuLy=  item['TrangThaiXuLy']!= null ?item['TrangThaiXuLy']:"";
    var LoaiTiepNhan=  item['LoaiTiepNhan']!= null ?item['LoaiTiepNhan']:"";
    var CongKhai=  item['CongKhai']!= null ?item['CongKhai']:"";
    var ID=  item['id'] != null ? item['id']:0 ;
    var Thongbao=  item['Thongbao']!= null ?item['Thongbao']:0 ;
    var NguoiHoi=  item['NguoiHoi']!= null ?item['NguoiHoi']:"";


    return ListTile(

      title:Row(children: [
        Text(
          title,
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.normal,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20,left: 5),
          child:  Text(
              Thongbao >5? "+5" : Thongbao.toString(),
          maxLines: 1,
          style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 12,color:Colors.red,
          ),
        ) ,)

      ],),

      trailing: Icon(Icons.arrow_right),
      onTap: () {
        checker = true;
        if (mounted) {setState(()   {
          //print(menuleft) ;
          for( int i= 0 ; i< menuleft.length; i++)
          {
            if(menuleft[i]['id'] == ID)
              tappedIndex = i;
            IDTT = ID;
          }


        });}

        //  GetDetailMenuLeft(widget.page,query, widget.year);

        Navigator.of(context).push(MaterialPageRoute
          (builder: (context) =>  congDongPAKN(TrangThaiXuLy:TrangThaiXuLy,
            LoaiTiepNhan : LoaiTiepNhan,CongKhai:CongKhai ,NguoiHoi:NguoiHoi)
        ));


        //Navigator.pop(context);
      },
    );
  }

}