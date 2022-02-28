import 'dart:convert';
import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/ui/congDong/thongTinChiTiet.dart';
import 'package:html/parser.dart' show parse;
import 'package:pakn2021/ui/taiKhoanCB/thongTinChiTiet.dart';



class timKiemCB extends StatefulWidget {
  @override
  _timKiemCBState createState() => _timKiemCBState();
}

class _timKiemCBState extends State<timKiemCB> {


  var IDCoQuan;
  List<ListDataCoQuan>  ListDataCQ = [];
  List dataList = [];
  bool isLoading = false;
  int length = 20;
  int tongSo = 0;
  String TuNgay ="";
  String DenNgay = "";
  DateTime _dateTime;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollerController = new ScrollController();
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateControllerTN = TextEditingController();
  TextEditingController _Tilte = TextEditingController();
  TextEditingController _dateControllerDN = TextEditingController();
  static ValueNotifier<DateTime> firstDate = ValueNotifier<DateTime>(DateTime(1900));
  static ValueNotifier<DateTime> lastDate = ValueNotifier<DateTime>(DateTime(2100));
  static ValueNotifier<DateTime> firstDateCheck =
  ValueNotifier<DateTime>(DateTime(1900));
  static ValueNotifier<DateTime> lastDateCheck =
  ValueNotifier<DateTime>(DateTime(2100));
  String tungay = DateFormat('dd/MM/yyyy').format(firstDate.value);
  String denngay = DateFormat('dd/MM/yyyy').format(lastDate.value);
  Future<Null> _selectDateTN(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null)
      if(mounted){setState(() {
        selectedDate = picked;

        var outputFormat = DateFormat('dd/MM/yyyy');
         _dateControllerTN.text = outputFormat.format((selectedDate));
        TuNgay = DateFormat('MM/dd/yyyy').format(selectedDate);
        GetDataKeyWord("", TuNgay,DenNgay,"","");
      });}

  }
  Future<Null> _selectDateDN(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null)
      if(mounted){ setState(() {
        selectedDate = picked;
        var outputFormat = DateFormat('dd/MM/yyyy');
        _dateControllerDN.text = outputFormat.format((selectedDate));
        DenNgay = (DateFormat('MM/dd/yyyy').format(selectedDate.add(Duration(days: 1))));
        GetDataKeyWord("",TuNgay,DenNgay,"","");
      });}

  }
  String ActionXL = "GetListItem";
  @override
  void initState() {
    super.initState();
    GetDataCoQuan();
    GetDataKeyWord("","","","","");
    setState(() {
      refreshList();
    });
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
  // @override
  // void dispose(){
  //   super.dispose();
  //   //dataList.clear();
  //   GetDataDL();
  // }

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

  // @override
  // Future<void> destroy() {
  //
  //   return GetDataDL();
  // }

  // GetDataDL() async {
  //   String getData = await CongAPI.getDataDetailVB(ActionXL,"","","","",length);
  //
  //       if(mounted){
  //         setState(() {
  //           dataList.addAll(json.decode(getData)['OData']);
  //           length+=10;
  //
  //           isLoading = true;
  //           _scrollerController.addListener(() {
  //             if (_scrollerController.position.pixels == _scrollerController.position.maxScrollExtent) {
  //               GetDataDL();
  //               // GetDataByKeyYearVBDen(dropdownValue);
  //               dataList;
  //             }
  //
  //
  //           });
  //         });
  //
  //       }
  //
  //
  //
  // }
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
  GetDataKeyWord(String title,String tungay,String denngay,String cq,String
  tencq) async {
    String getData1 = await CongAPI.getDataDetailVBTK(ActionXL,title,tungay,
        denngay,cq,tencq);
        if(mounted){
          setState(() {
            dataList=(json.decode(getData1)['OData']);
            tongSo = json.decode(getData1)['TotalCount'];
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
            child: Text('Tìm kiếm'),
          ),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.vertical(
          //     bottom: Radius.circular(30),
          //   ),
          // ),
          leading: new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight+150),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(children: [
              TextField(
                onChanged: (val){
                  setState(() {
                    GetDataKeyWord(val,"","","","");
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
              SizedBox(height: 10,),
              Row(children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: InkWell(
                    onTap: () {
                    _selectDateTN(context);
                    },
                    child: Container(
                      width: size.width / 3,
                      height: size.height /18,
                      alignment: Alignment.center,
                   margin:  EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black38,

                          ),
                          borderRadius: BorderRadius.all(Radius
                              .circular(8),)
                      ),
                      child:TextFormField(
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: _dateControllerTN,

                        decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                            hintText: "Từ ngày",
                            // labelText: 'Time',
                            contentPadding: EdgeInsets.only
                              (bottom: 5.0)),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: InkWell(
                    onTap: () {
                     _selectDateDN(context);
                    },
                    child: Container(
                      width: size.width / 3,
                      height: size.height /18,
                      alignment: Alignment.center,
                     // margin:  EdgeInsets.only(left: 20,right: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black38,

                          ),
                          borderRadius: BorderRadius.all(Radius
                              .circular(8),)
                      ),
                      child: TextFormField(
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                        enabled: false,
                        keyboardType: TextInputType.text,
                       controller: _dateControllerDN,
                        decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                            hintText: "Đến ngày",
                            // labelText: 'Time',
                            contentPadding: EdgeInsets.only
                              (bottom: 5.0)),
                      ),
                    ),
                  ),
                ),

              ],),
              Container(
                width: MediaQuery.of(context).size.width * 0.53,
                height: size.height /14,
                // padding: EdgeInsets.all(10),
                margin:  EdgeInsets.only(left: 10,right: 20,top:10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius
                        .circular(8))
                ),

                child:FormField<String>(
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(

                              borderRadius: BorderRadius
                                  .circular(8))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text("Chọn cơ quan"),
                          style: TextStyle(fontSize: 14,color: Colors.black),
                          value: IDCoQuan,alignment: Alignment.center,
                          isDense: false,
                          isExpanded: true,
                          onChanged: (newValue) {
                            if(mounted){

                              setState(() {
                                IDCoQuan=newValue;
                                GetDataKeyWord("","","",IDCoQuan,"");
                              });
                            }
                          },
                          items: ListDataCQ.map((value) {
                            return DropdownMenuItem<String>(
                              value: value.IDCQ.toString(),
                              child: Text(value.text, style: TextStyle(
                                  color: Colors.black.withOpacity(0.75),
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13),overflow: TextOverflow.visible, maxLines: 1,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],),
          )
        )

        ),
        body: Stack(children: [
           GetData(),

        ],),

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
                thongTinChiTietWidget(id: sMIDField, title: vbdiTrichYeuField),
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
class ListDataCoQuan {
  String text;
  int IDCQ;

  ListDataCoQuan({ this.text,this.IDCQ});

  factory ListDataCoQuan.fromJson(Map<String, dynamic> json) {
    return ListDataCoQuan(IDCQ: (json['ID']), text: json['Title']);
  }
}
class HtmlTags {

  static void removeTag({htmlString, callback}) {
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    callback(parsedString);
  }
}