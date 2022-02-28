import 'dart:convert';
import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/ui/congDong/thongTinChiTiet.dart';
import 'package:html/parser.dart' show parse;

class traCuuWidget extends StatefulWidget {
  @override
  _traCuuWidgetState createState() => _traCuuWidgetState();
}

class _traCuuWidgetState extends State<traCuuWidget> {
  List dataList = [];
  bool isLoading = false;
  int tongSo = 0;
  int length = 20;
  ScrollController _scrollerController = new ScrollController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  TextEditingController _Tilte = TextEditingController();

  String ActionXL = "GetListItemTraCuu";
  @override
  void initState() {
    super.initState();
    GetDataDL();
    setState(() {
      refreshList();
    });
  }
  @override
  void dispose(){
    super.dispose();
    //dataList.clear();
    GetDataDL();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      // GetDataHSCV();
      // refreshList();
      // HoSoList;
    });
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
  Future<void> destroy() {

    return GetDataDL();
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

  GetDataDL() async {
    String getData = await CongAPI.getDataDetailVBTraCuu(ActionXL,"","","","",length);

    if(mounted){
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

      });

    }



  }
  GetDataKeyWord(String title,String tungay,String denngay) async {
    String getData1 = await CongAPI.getDataDetailVBPA(title,tungay,denngay);
    if(mounted){
      setState(() {
        dataList=(json.decode(getData1)['OData']);
        isLoading = true;
      });

    }



  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar:   AppBar(

          backgroundColor: Color(0xff3064D0),
          title: Center(
            child: Text('Danh sách phản ánh kiến nghị'),
          ),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.vertical(
          //     bottom: Radius.circular(30),
          //   ),
          // ),
          // leading: new IconButton(
          //   icon: new Icon(Icons.close),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight+20),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(children: [
              TextField(
                onChanged: (val){
                  setState(() {
                    GetDataKeyWord(val,"","");
                  });
                },
                controller: _Tilte,
                cursorColor: Colors.black45,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                decoration: new InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Nhập từ khoá tìm kiếm',
                  hintStyle: TextStyle(
                    color: Color(0xffC0C0C0),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                  contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

            ],),
          )
      )

      ),
      body:Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 50,),
              Text("Tổng số ",style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),),
              Text(tongSo.toString(),style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal, color: Colors.red
              ),),
              Text(" phản ánh, kiến nghị được phúc đáp.",style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),),
              SizedBox(height: 10,),
            ],),
          Expanded(
            child: Container(
              child: GetData(),
            ),
          )
        ],
      ),


    );
  }

  Widget GetData() {
    if (dataList ==null || dataList.length < 0 || isLoading == false) {
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
    return RefreshIndicator(key: refreshKey,
        child: ListView.builder(
          itemCount: dataList == null ? 0 : dataList.length,
          padding: EdgeInsets.all(10),
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
                builder: (context) =>
                    thongTinKienNghi(id: sMIDField, title: vbdiTrichYeuField),
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
                            color: Colors.lightBlueAccent,
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
                      padding:
                      EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 10),
                      child: Row(
                        children: [
                          Row(
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
                                padding: EdgeInsets.only(left: 10),
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
                        ],
                      ),
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
    String parsedString = parse(document.body.text).documentElement.text;
    callback(parsedString);
  }
}