import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pakn2021/core/services/callApi.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/ui/res/strings.dart';
import 'package:path/path.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html/parser.dart' show parse;
import 'package:hb_check_code/hb_check_code.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pakn2021/ui/main/showThongBao.dart';

class guiTrucTiep extends StatefulWidget {
  guiTrucTiep({Key key}) : super(key: key);

  @override
  _taoPhanAnhState createState() => _taoPhanAnhState();
}

class _taoPhanAnhState extends State<guiTrucTiep> {
  TextEditingController textEditingControllerHoTen =
  new TextEditingController(text: TenUser);
  TextEditingController textEditingControllerEmail =
  new TextEditingController(text:EmailUser);
  TextEditingController textEditingControllerSDT = new TextEditingController
    (text:DienThoaiUser);
  TextEditingController textEditingControllerMaBaoMat =
  new TextEditingController();
  TextEditingController textEditingControllerTieuDe =
  new TextEditingController();
  TextEditingController textEditingControllerDiaChi =
  new TextEditingController(text:DiaChiUser);
  TextEditingController textEditingControllerDoanhNghiep =
  new TextEditingController();
  int id = 1;
  int idCN =1;
  bool idCNT = false;
  int idKN = 3;
  bool idKNT = false;
  String base64PDF = "";
  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  String result = "";
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
  int code;
  final List<String> _todoList = <String>[];
  File selectedfile;
  List<Widget> _listSection = List<Widget>();
  List<String> todoItemsArrayList = [];
  List chua = [];
  var IDCoQuan;
  List<ListDataCoQuan>  ListDataCQ = [];

  var now = new DateTime.now();
  Random rnd = new Random();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(selectedDate.toString()));
      });
  }

  @override
  void initState() {
    super.initState();
    GetDataCoQuan();
    formattedDate= DateFormat('dd-MM-yyyy')
        .format(DateFormat('yyyy-MM-dd').parse(now.toString()));
    ramdom();
    ramdom();
  }

  _onDeleteItemPressed(item) {
    chua.removeAt(item);
    setState(() {});
  }

  void ramdom() {
    // for (var i = 0; i < 6; i++) {
    //   code = code + Random().toString();
    // }
    int min = 1000;
    int max = 99999;
    code = min + rnd.nextInt(max - min);
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

  selectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'mp4', 'doc'],
      //allowed extension to choose
    );

    if (result != null) {
      //if there is selected file
      selectedfile = File(result.files.single.path);

      if (selectedfile != null) {
        // var bytes1 = await rootBundle.load(selectedfile.path);
        List<int> Bytes = await selectedfile.readAsBytesSync();
        print(Bytes);
        base64PDF = await base64Encode(Bytes);
        print("hdaf  " + base64PDF);
        chua.add(basename(selectedfile.path));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3064D0),
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(
          child: Text(
            "G???i ph???n ??nh, ki???n ngh??? tr???c ti???p tr??n h??? th???ng",
            style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: htmltt,)
              ],)
            ,
            Container(
              padding: EdgeInsets.only(top: 0, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "H??? v?? t??n ",
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
              // padding: EdgeInsets.all(10),
              //width: size.width /2,
              height: size.height / 20,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 8, left: 16, right: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black38,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(2),
                  )),
              // padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(

                cursorColor: Colors.black,
                controller: textEditingControllerHoTen,
                onChanged: (text) {
                  // do something with tex
                  if (mounted) {
                    setState(() {
                      // HDPL_CMND = text;
                    });
                  }
                },
                // keyboardType: inputType,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "Nh???p ?????y ????? h??? t??n",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal),
                ),
              ),
            ),
            // Container(
            //   padding: EdgeInsets.only(top: 8, left: 16),
            //   child: Text(
            //     "Doanh nghi????p/ Hi????p h????i ",
            //     style: TextStyle(
            //         color: Color(0xff021029),
            //         fontStyle: FontStyle.normal,
            //         fontWeight: FontWeight.w400,
            //         fontSize: 14),
            //   ),
            // ),
            // Container(
            //   // padding: EdgeInsets.all(10),
            //   //width: size.width /2,
            //   height: size.height / 20,
            //   alignment: Alignment.center,
            //   margin: EdgeInsets.only(top: 8, left: 16, right: 16),
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       border: Border.all(
            //         color: Colors.black38,
            //       ),
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(2),
            //       )),
            //   // padding: EdgeInsets.symmetric(horizontal: 20),
            //   child: TextFormField(
            //     cursorColor: Colors.black,
            //     controller: textEditingControllerDoanhNghiep,
            //     onChanged: (text) {
            //       // do something with text
            //       if (mounted) {
            //         setState(() {
            //           // HDPL_CMND = text;
            //         });
            //       }
            //     },
            //     // keyboardType: inputType,
            //     decoration: new InputDecoration(
            //       border: InputBorder.none,
            //       focusedBorder: InputBorder.none,
            //       enabledBorder: InputBorder.none,
            //       errorBorder: InputBorder.none,
            //       disabledBorder: InputBorder.none,
            //       contentPadding:
            //       EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            //       hintText: "",
            //       hintStyle: TextStyle(
            //           fontSize: 14,
            //           fontWeight: FontWeight.w400,
            //           fontStyle: FontStyle.normal),
            //     ),
            //   ),
            // ),
            Container(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "T?? c??ch ",
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
              padding: EdgeInsets.only(top: 5, left: 16, right: 16),
              child: Row(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            id = 1;
                          });
                        },
                      ),
                      Text(
                        'C?? nh??n',
                        style: new TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value:2,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            id = 2;
                          });
                        },
                      ),
                      Text(
                        'T??? ch???c',
                        style: new TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, left: 16, right: 16),
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
              // padding: EdgeInsets.all(10),
              //width: size.width /2,
              height: size.height / 20,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 8, left: 16, right: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black38,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(2),
                  )),
              // padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                cursorColor: Colors.black,
                controller: textEditingControllerDiaChi,
                onChanged: (text) {
                  // do something with text
                  if (mounted) {
                    setState(() {
                      // HDPL_CMND = text;
                    });
                  }
                },
                // keyboardType: inputType,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "Nh???p ?????y ????? ?????a ch??? n??i ???",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
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
              // padding: EdgeInsets.all(10),
              //width: size.width /2,
              height: size.height / 20,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 8, left: 16, right: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black38,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(2),
                  )),
              // padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                cursorColor: Colors.black,

                controller: textEditingControllerEmail,
                onChanged: (text) {
                  // do something with text
                  if (mounted) {
                    setState(() {
                      // HDPL_CMND = text;
                    });
                  }
                },
                // keyboardType: inputType,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "??i???n tho???i di ?????ng",
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
              // padding: EdgeInsets.all(10),
              //width: size.width /2,
              height: size.height / 20,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 8, left: 16, right: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black38,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(2),
                  )),
              // padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                cursorColor: Colors.black,
                controller: textEditingControllerSDT,

                onChanged: (text) {
                  // do something with text
                  if (mounted) {
                    setState(() {
                      // HDPL_CMND = text;
                    });
                  }
                },
                // keyboardType: inputType,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
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
              // padding: EdgeInsets.all(10),
              //width: size.width /2,
              height: size.height / 20,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 8, left: 16, right: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black38,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(2),
                  )),
              // padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                cursorColor: Colors.black,
                controller: textEditingControllerTieuDe,
                onChanged: (text) {
                  if (mounted) {
                    setState(() {
                      // HDPL_CMND = text;
                    });
                  }
                },
                // keyboardType: inputType,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "",
                  hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "C?? quan tr??? l???i",
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
              //width: MediaQuery.of(context).size.width * 0.53,
              height: size.height /14,
              // padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 8, left: 16, right: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(
                  //   color: Colors.black38,
                  // ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(2),
                  )),
              child:FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(

                            borderRadius: BorderRadius
                                .circular(1))),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        alignment: Alignment.center,
                        hint: Text("Ch???n c?? quan"),
                        style: TextStyle(fontSize: 14,color: Colors.black),
                        value: IDCoQuan,
                        isDense: false,
                        isExpanded: true,
                        onChanged: (newValue) {
                          if(mounted){
                            setState(() {
                              IDCoQuan=newValue;
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

            Container(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "???n th??ng tin c?? nh??n ",
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
              padding: EdgeInsets.only(top: 5, left: 16, right: 16),
              child: Row(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: idCN,
                        onChanged: (val) {
                          setState(() {
                            idCN = val;
                            print(val);
                          });
                        },
                      ),
                      Text(
                        'C??',
                        style: new TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: idCN,
                        onChanged: (val) {
                          setState(() {
                            idCN = val;
                            print(val);
                          });
                        },
                      ),
                      Text(
                        'Kh??ng',
                        style: new TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top:5, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "C??ng khai ph???n ??nh ki???n ngh??? ",
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
              padding: EdgeInsets.only(top:5, left: 16, right: 16),
              child: Row(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 3,
                        groupValue: idKN,
                        onChanged: (val) {
                          setState(() {
                            idKN = val;
                          });
                        },
                      ),
                      Text(
                        'C?? nh??n',
                        style: new TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 4,
                        groupValue: idKN,
                        onChanged: (val) {
                          setState(() {
                            idKN = val;
                          });
                        },
                      ),
                      Text(
                        'T??? ch???c',
                        style: new TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "Ng??y g???i",
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
              // padding: EdgeInsets.all(10),
              //width: size.width /2,
              height: size.height / 20,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 8, left: 16, right: 16),
              decoration: BoxDecoration(
                // color: Color(0xffE0F2FF),
                  border: Border.all(
                    color: Colors.black38,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(2),
                  )),
              // padding: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                child: Text(formattedDate.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF021029),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal),
                  textAlign: TextAlign.left,

                  // controller:  selectedDate,

                  // onSaved: (val) {
                  //   _setDate1 = val;
                  // },
                  // decoration: InputDecoration(
                  //     disabledBorder:
                  //         UnderlineInputBorder(borderSide: BorderSide.none),
                  //     // labelText: 'Time',
                  //     contentPadding: EdgeInsets.only(bottom: 15.0)),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "N???i dung ph???n ??nh/Ki???n ngh???",
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
                            )
                        ),
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
                            )
                        ),
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
                            )
                        ),
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
                                  hint: 'N???i dung ...',
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
                                  hint: 'N???i dung ...',
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
                                  hint: 'N???i dung ...',
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
                                  hint: 'N???i dung ...',
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
                                  hint: 'N???i dung ...',
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
                                    // onEnter: () {
                                    //   print("enter/return pressed");
                                    // },
                                    // onFocus: () {
                                    //   print("editor focused");
                                    // },
                                    // onBlur: () {
                                    //   print("editor unfocused");
                                    // },
                                    // onBlurCodeview: () {
                                    //   print("codeview either focused or unfocused");
                                    // },
                                    // onInit: () {
                                    //   print("init");
                                    // },
                                    // //this is commented because it overrides the default Summernote handlers
                                    // /*onImageLinkInsert: (String? url) {
                                    //    print(url ?? "unknown url");
                                    //  },
                                    //  onImageUpload: (FileUpload file) async {
                                    //    print(file.name);
                                    //    print(file.size);
                                    //    print(file.type);
                                    //  },*/
                                    // onKeyDown: (int keyCode) {
                                    //   print("$keyCode key downed");
                                    // },
                                    // onKeyUp: (int keyCode) {
                                    //   print("$keyCode key released");
                                    // },
                                    // onPaste: () {
                                    //   print("pasted into editor");
                                    // },
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
                      ],)
                ) ,
              ),



            ),
            Container(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "M?? b???o m???t",
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(
                flex: 2,
                // child: GestureDetector(
                //     behavior: HitTestBehavior.opaque,
                //     onTap: () => setState(() {}),
                //     child: HBCheckCode(
                //       code: code.toString(),
                //     )
                // ),
                child: Container(
                    height: size.height / 20,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                    child: HBCheckCode(
                      code: code.toString(),
                      backgroundColor: Colors.white,
                    )),
              ),
              Flexible(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                    Icons.cached_outlined,
                    color: Color(0xff0368B6),
                  ),
                  onPressed: () {
                    setState(() {
                      ramdom();
                    });
                  },
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  // padding: EdgeInsets.all(10),
                  //width: size.width /2,
                  height: size.height / 20,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black38,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(2),
                      )),
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    controller: textEditingControllerMaBaoMat,
                    style: TextStyle(
                        color: Color(0xff021029),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal),
                    onChanged: (text) {
                      // do something with text
                      if (mounted) {}
                    },
                    // keyboardType: inputType,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "",
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                ),
              ),
            ]),
            Container(
              padding: EdgeInsets.only(top: 8, left: 16),
              height: size.height*0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "????nh k??m t???p ",textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Color(0xff021029),
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 8,  right: 16),
                          child: FlatButton(
                            child: Text('????nh k??m file...'),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () async {
                              selectFile();
                            },
                          ),
                        ),
                      ],),),
                  Flexible(
                    flex:5,
                    child:ListView.builder(
                      itemCount: chua.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(chua[index],style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                            maxLines:2,),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 18.0,
                              color: Color(0xffDE3E43),
                            ),
                            onPressed: () {
                              _onDeleteItemPressed(index);
                            },
                          ),
                        );
                      },
                    ),
                  )



                ],
              ),),

            Container(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(
                "L??u ??: ????nh k??m t???i ??a 5 files/l???n g???i, m???i file kh??ng qu?? 5MB. M???t ng??y m???t ng?????i kh??ng g???i qu?? 5 l???n",
                style: TextStyle(
                    color: Color(0xffDE3E43),
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 30),
              child: Center(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Padding(padding: EdgeInsets.only(left: 10,right: 10,top: 0),
                      child:   TextButton.icon (
                          icon: Icon(Icons.check),
                          label: Text('G???i',style: TextStyle
                            (fontWeight:
                          FontWeight.bold)),
                          onPressed: () async {
                            if(textEditingControllerHoTen.text== null
                                ||textEditingControllerHoTen.text== ""||
                                textEditingControllerDiaChi.text== null
                                ||textEditingControllerDiaChi.text== ""||
                                textEditingControllerEmail.text== null
                                ||textEditingControllerEmail.text== ""||
                                textEditingControllerSDT.text== null
                                ||textEditingControllerSDT.text== ""||
                                textEditingControllerTieuDe.text== null
                                ||textEditingControllerTieuDe.text== ""||
                                ((TiengViet== null || TiengViet=="")
                                    &&(TiengAnh== null || TiengAnh=="")
                                    &&(TiengTrung== null || TiengTrung=="")
                                    &&(TiengNhat== null || TiengNhat=="")
                                    &&(TiengHan== null || TiengHan=="")) )
                            {
                              showAlertDialog(context,"Nh???p ?????y ????? c??c "
                                  "tr?????ng c???n thi???t (*)");
                            }
                            else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(textEditingControllerEmail.text)) {
                              showAlertDialog(context,"Y??u c???u nh???p ????ng ?????nh d???ng email");
                            } else if (!RegExp('^(?:[+0]9)?[0-9]{10}').hasMatch(textEditingControllerSDT.text)) {
                              showAlertDialog(context,"Y??u c???u nh???p ????ng ?????nh d???ng s??? ??i???n tho???i");
                            }
                            else
                            {
                              if (code.toString() ==
                                  textEditingControllerMaBaoMat.text) {
                                String tenpdf="";
                                if( selectedfile!=null )
                                {
                                  tenpdf=basename(selectedfile.path);
                                }


                                EasyLoading.show();
                                var thanhcong = await CongAPI.postTAOPA(
                                    textEditingControllerHoTen.text,
                                    id.toString(),
                                    textEditingControllerDiaChi.text,
                                    textEditingControllerEmail.text,
                                    textEditingControllerSDT.text,
                                    textEditingControllerTieuDe.text,
                                    TiengViet,TiengAnh,TiengTrung,TiengNhat,TiengHan,
                                    tenpdf,
                                    base64PDF,
                                    idCN.toString(),idKN.toString(),
                                    _dateController.text,IDCoQuan.toString()

                                );
                                EasyLoading.dismiss();
                                Navigator.of(context).pop();
                                showAlertDialog(context, json.decode(thanhcong)['Message']);

                              } else {
                                showAlertDialog(context,"M?? x??c nh???n kh??ng ????ng ");
                                setState(() {
                                  ramdom();
                                });
                              }
                            }


                          },

                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                            foregroundColor: MaterialStateProperty.all<Color>
                              (Colors.white),
                          )
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10,
                        right: 10,top: 0),
                      child:   TextButton.icon (
                        // child: Text("????ng l???i",style: TextStyle(fontWeight: FontWeight.bold),),
                          icon: Icon(Icons.call_missed_rounded),
                          label: Text('V??? trang ch???',style: TextStyle
                            (fontWeight:
                          FontWeight.bold)),
                          onPressed: () {
                            Navigator.of(context).pop(); EasyLoading.dismiss();

                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          )
                      ),
                    ),
                  ],),
//                 child: Container(
// //                   color: Colors.white,
//                   width: MediaQuery.of(context).size.width * 0.35,
//                   height: 50,
//
//                   child: RaisedButton(
//                     color: Colors.blue,
//                     shape: RoundedRectangleBorder(
//                         side: new BorderSide(
//                           color: Color(0xff3064D0),
//                         ),
//                         //the outline color
//                         borderRadius:
//                         new BorderRadius.all(new Radius.circular(10))),
//                     child: Text('G???i ',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                           fontStyle: FontStyle.normal,
//                           fontWeight: FontWeight.w400,
//                           // color: Colors.white,
//                         )),
//                     onPressed: () async {
//                       if(textEditingControllerHoTen.text== null
//                           ||textEditingControllerHoTen.text== ""||
//                           textEditingControllerDiaChi.text== null
//                           ||textEditingControllerDiaChi.text== ""||
//                           textEditingControllerEmail.text== null
//                           ||textEditingControllerEmail.text== ""||
//                           textEditingControllerSDT.text== null
//                           ||textEditingControllerSDT.text== ""||
//                           textEditingControllerTieuDe.text== null
//                           ||textEditingControllerTieuDe.text== ""||
//                           ((TiengViet== null || TiengViet=="")
//                               &&(TiengAnh== null || TiengAnh=="")
//                               &&(TiengTrung== null || TiengTrung=="")
//                               &&(TiengNhat== null || TiengNhat=="")
//                               &&(TiengHan== null || TiengHan=="")) )
//                       {
//                         showAlertDialog(context,"Nh???p ?????y ????? c??c "
//                             "tr?????ng c???n thi???t (*)");
//                       }
//                       else
//                       {
//                         if (code.toString() ==
//                             textEditingControllerMaBaoMat.text) {
//                           EasyLoading.show();
//                           var thanhcong = await CongAPI.postTAOPA(
//                               textEditingControllerHoTen.text,
//                               id.toString(),
//                               textEditingControllerDiaChi.text,
//                               textEditingControllerEmail.text,
//                               textEditingControllerSDT.text,
//                               textEditingControllerTieuDe.text,
//                               TiengViet,TiengAnh,TiengTrung,TiengNhat,TiengHan,
//                               basename(selectedfile.path),
//                               base64PDF,
//                               idCN,idKN,
//                               _dateController.text
//
//                           );
//                           EasyLoading.dismiss();
//                           Navigator.of(context).pop();
//                           showAlertDialog(context, json.decode(thanhcong)['Message']);
//
//                         } else {
//                           setState(() {
//                             ramdom();
//                           });
//                         }
//                       }
//
//
//                     },
//                   ),
//                 ),
              ),
            ),

          ],
        ),
      ),
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
class ListDataCoQuan {
  String text;
  int IDCQ;

  ListDataCoQuan({ this.text,this.IDCQ});

  factory ListDataCoQuan.fromJson(Map<String, dynamic> json) {
    return ListDataCoQuan(IDCQ: (json['ID']), text: json['Title']);
  }
}
//conten