import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/painting.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hb_check_code/hb_check_code.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pakn2021/core/services/congDongService.dart';
import 'package:pakn2021/core/models/phanAnhKienNghiJson.dart';
import 'package:pakn2021/core/models/phanAnh_PhucDap_Json.dart';
import 'package:pakn2021/ui/main/showThongBao.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:html/parser.dart' show parse;

class thongTinKienNghi extends StatefulWidget {
  final int id;
  final String title;

  thongTinKienNghi({Key key, this.id, this.title}) : super(key: key);

  @override
  _thongTinKienNghiState createState() => _thongTinKienNghiState();
}

class _thongTinKienNghiState extends State<thongTinKienNghi> {
  bool isLoading = false;
  List dataList = [];
  List dataListBL = [];
  List dataListPD = [];
  var rating = 0.0;
  var ratingNX = 2.0;
  var ratingCD = 0.0;
  int random;
  int DonVi = 0;
  var vanBan = null;
  var vanBanPD = null;
  RxBool checkplay = false.obs;
  RxBool checkplayTL = false.obs;
  final HtmlEditorController controller = HtmlEditorController();
  TextEditingController textEditingControllerMaBaoMat =
      new TextEditingController();
  int code;

  File selectedfile;
  String base64PDF = "";
  var player = new AudioPlayer();
  var player1 = new AudioPlayer();
  var now = new DateTime.now();
  Random rnd = new Random();
  TextEditingController textEditingControllerHoTen =
      new TextEditingController();
  TextEditingController textEditingControllerEmail =
      new TextEditingController();
  TextEditingController textEditingControllerSDT = new TextEditingController();
  TextEditingController textEditingControllerTieuDe =
      new TextEditingController();
  TextEditingController textEditingControllerDiaChi =
      new TextEditingController();
  TextEditingController textEditingControllerDoanhNghiep =
      new TextEditingController();
  List chua = [];
  String TiengViet = "";
  String TiengVietND = "";
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  int SoDiem1 = 0;

  int SoDiem2 = 0;
  int SoDiem3 = 0;
  int SoDiem4 = 0;
  int SoDiem5 = 0;
  double tong = 0.0;
  var datas ;

  @override
  void initState() {
    super.initState();
    GetDataChiTietPhucDap();
    GetDataChiTiet();
    GetDataBinhLuan();

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
        isLoading = true;
      });
    }
  }

  GetDataChiTietPhucDap() async {
    String getData = await CongAPI.getDataDetailPhucDap(widget.id);
    var data = json.decode(getData)['OData'];
    for (var i in data) {
      int id = i['ID'];

    }

    if (mounted) {
      setState(() {
        dataListPD.addAll(data);
      });
    }
  }

  GetDataBinhLuan() async {
    String getData = await CongAPI.getDataBinhLuan(widget.id);
    var data = json.decode(getData)['OData'];
    if (mounted) {
      setState(() {
        dataListBL.addAll(data);
      });
    }
  }

  GetDataDanhGia(int id) async {
    String getData = await CongAPI.getDatadg(id);
      datas= json.decode(getData)['OData'];
    SoDiem1 = datas['SoDiem1'] != null ?datas['SoDiem1'] : 0;
    SoDiem2 = datas['SoDiem2'] != null ? datas['SoDiem2'] : 0;
    SoDiem3 = datas['SoDiem3'] != null ? datas['SoDiem3'] : 0;
    SoDiem4 = datas['SoDiem4'] != null ? datas['SoDiem4'] : 0;
    SoDiem5 = datas['SoDiem5'] != null ? datas['SoDiem5'] : 0;

    tong = (SoDiem1 + SoDiem2 + SoDiem3 + SoDiem4 + SoDiem5) / 5;


  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      setState(() {
        dataListBL;
        // GetDataHSCV();
      });
    }

    return null;
  }

  GetDataMP3(String title) async {
    String getData = await CongAPI.getDataMP3(title);
    var data = json.decode(getData)["async"];
    player.play(data);
    if (mounted) {
      setState(() {});
    }
  }

  GetDataMP33(String title) async {
    String getData = await CongAPI.getDataMP3(title);
    var data = json.decode(getData)["async"];
    player1.play(data);
    if (mounted) {
      setState(() {});
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

      if (selectedfile != null) {
        // var bytes1 = await rootBundle.load(selectedfile.path);
        List<int> Bytes = await selectedfile.readAsBytesSync();

        base64PDF = await base64Encode(Bytes);

        //chua.add(basename(selectedfile.path));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'N???i dung chi ti???t ph???n ??nh, ki???n ngh???'.toUpperCase(),
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
    );
  }

  Widget getBody() {
    Size size = MediaQuery.of(context).size;
    phanAnhKNJson vban = vanBan;
    if (vban != null) DonVi = vban.DonVi;
    String TraLoiTiengViet = "";
    String TiengAnh = "";
    String TiengNhat = "";
    String TiengHan = "";
    String TiengTrung = "";
    if (vban.CauHoiTiengViet != null)
      HtmlTags.removeTag(
        htmlString: vban.CauHoiTiengViet,
        callback: (string) {
          TiengViet = string;
        },
      );

    if (vban.TraLoiTiengViet != null)
      HtmlTags.removeTag(
        htmlString: vban.TraLoiTiengViet,
        callback: (string) {
          TraLoiTiengViet = string;
        },
      );

    if (vban.CauHoiTiengAnh != null)
      HtmlTags.removeTag(
        htmlString: vban.CauHoiTiengAnh,
        callback: (string) {
          TiengAnh = string;
        },
      );

    if (vban.CauHoiTiengNhat != null)
      HtmlTags.removeTag(
        htmlString: vban.CauHoiTiengNhat,
        callback: (string) {
          TiengNhat = string;
        },
      );

    if (vban.CauHoiTiengHan != null)
      HtmlTags.removeTag(
        htmlString: vban.CauHoiTiengHan,
        callback: (string) {
          TiengHan = string;
        },
      );

    if (vban.CauHoiTiengTrung != null)
      HtmlTags.removeTag(
        htmlString: vban.CauHoiTiengTrung,
        callback: (string) {
          TiengTrung = string;
        },
      );
    var title1 = "K??nh g???i ban ch??? ?????o covid19 t??i ??ang l??m vi???c t???i doanh "
        "nghi???p c???a t???nh V??nh ph??c v???a qua t??i ??i c??ng t??c 5 th??ng ??? "
        "Tp H??? ch?? minh, s???p t???i t??i ra H?? n???i c??ng t??c v?? c??ch ly t???i nh?? ??? "
        "H?? n???i 7 ng??y theo quy ?????nh sau ???? t??i v??? V??nh ph??c th?? c?? ph???i ??i. Xin tr??n th??nh c???m ??n!";
    var title = "Th???c hi???n ch??? ?????o c???a UBND t???nh t???i v??n b???n 2872/Q?? - UBND , "
        "ng??y 15/10/2021, ????? ngh??? c??ng d??n x??c nh???n l???i v??ng c??ng d??n ?????n/v??? V??nh Ph??c t??? v??ng n??o thu???c H?? N???i ho???c th??nh ph??? H??? Ch?? Minh. Tr?????ng h???p c??ng d??n ?????n t??? ?????a b??n c?? d???ch c???p ????? 4 ho???c v??ng c??ch ly y t???, s??? thu???c di???n c??ch ly ?????";
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
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
                Container(
                    padding: EdgeInsets.only(top: 10, left: 0, right: 10),
                    width: MediaQuery.of(context).size.width * 0.94,
                    child: Text(
                      "N???i dung chi ti???t ph???n ??nh, ki???n ngh???",
                      style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 10, left: 0, right: 10),
                    width: MediaQuery.of(context).size.width * 0.94,
                    child: Text(
                      widget.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff3064D0),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 10, left: 0, right: 10),
                    width: MediaQuery.of(context).size.width * 0.94,
                    child: Text(
                      "Th????i gian ta??o: " +
                          (vban.ThoiGianTao != null && vban.ThoiGianTao != ""
                              ? GetDate(vban.ThoiGianTao)
                              : "") +
                          "  " +
                          (vban.DiaChi != null ? vban.DiaChi : ""),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff021029).withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 10, left: 0, right: 10),
                    width: MediaQuery.of(context).size.width * 0.94,
                    child: Text(
                      TiengViet != null
                          ? "N???i dung: " + TiengViet
                          : (TiengAnh != null
                              ? TiengAnh
                              : (TiengTrung != null
                                  ? TiengTrung
                                  : (TiengHan != null
                                      ? TiengHan
                                      : (TiengNhat != null ? TiengNhat : "")))),
                      style: TextStyle(
                        color: Color(0xff021029).withOpacity(0.75),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 24.26, left: 0, right: 10),
                    width: MediaQuery.of(context).size.width * 0.94,
                    child: Text(
                      "Th??ng tin ph??c ????p",
                      style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    )),
                // SizedBox(
                //   height: 34,
                // ),
                // Center(
                //     child: Text(
                //       "Ng?????i ph???n ??nh",
                //       maxLines: 1,
                //       overflow: TextOverflow.ellipsis,
                //       style: TextStyle(
                //         color: Color(0xff021029),
                //         fontSize: 16,
                //         fontWeight: FontWeight.w400,
                //         fontStyle: FontStyle.normal,
                //       ),
                //     )),
              ],
            ),
          GetDataPhucDap(),


            // Container(
            //     padding: EdgeInsets.only(top: 24.26, left: 0, right: 10),
            //     width: MediaQuery.of(context).size.width * 0.94,
            //     child: Text(
            //       "N???i dung b??nh lu???n",
            //       style: TextStyle(
            //         color: Colors.red,
            //         decoration: TextDecoration.underline,
            //         fontSize: 18,
            //         fontWeight: FontWeight.w500,
            //         fontStyle: FontStyle.normal,
            //       ),
            //     )),
            //  GetData(),
            //
            //
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Container(
            //         padding: EdgeInsets.only(top: 13.52, left: 15, right: 10),
            //         child: Text(
            //           "B??nh lu???n",
            //           maxLines: 1,
            //           overflow: TextOverflow.ellipsis,
            //           style: TextStyle(
            //             color: Colors.red,
            //             decoration: TextDecoration.underline,
            //             fontSize: 18,
            //             fontWeight: FontWeight.w500,
            //             fontStyle: FontStyle.normal,
            //           ),
            //         )),
            //     Container(
            //       padding: EdgeInsets.only(top: 26, left: 16, right: 16),
            //       child: Row(
            //         children: [
            //           Container(
            //             child: Text(
            //               "H??? v?? t??n ",
            //               style: TextStyle(
            //                   color: Color(0xff021029),
            //                   fontStyle: FontStyle.normal,
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 14),
            //             ),
            //           ),
            //           Container(
            //             child: Text(
            //               "(*)",
            //               style: TextStyle(
            //                   color: Color(0xffDE3E43),
            //                   fontStyle: FontStyle.normal,
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 14),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       // padding: EdgeInsets.all(10),
            //       //width: size.width /2,
            //       height: MediaQuery.of(context).size.height / 20,
            //       alignment: Alignment.center,
            //       margin: EdgeInsets.only(top: 8, left: 16, right: 16),
            //       decoration: BoxDecoration(
            //           color: Colors.white,
            //           border: Border.all(
            //             color: Colors.black38,
            //           ),
            //           borderRadius: BorderRadius.all(
            //             Radius.circular(2),
            //           )),
            //       // padding: EdgeInsets.symmetric(horizontal: 20),
            //       child: TextFormField(
            //         cursorColor: Colors.black,
            //         controller: textEditingControllerHoTen,
            //         onChanged: (text) {
            //           // do something with text
            //           if (mounted) {
            //             setState(() {
            //               // HDPL_CMND = text;
            //             });
            //           }
            //         },
            //         // keyboardType: inputType,
            //         decoration: new InputDecoration(
            //           border: InputBorder.none,
            //           focusedBorder: InputBorder.none,
            //           enabledBorder: InputBorder.none,
            //           errorBorder: InputBorder.none,
            //           disabledBorder: InputBorder.none,
            //           contentPadding: EdgeInsets.only(
            //               left: 15, bottom: 11, top: 11, right: 15),
            //           hintText: "Nh???p ?????y ????? h??? t??n",
            //           hintStyle: TextStyle(
            //               fontSize: 14,
            //               fontWeight: FontWeight.w400,
            //               fontStyle: FontStyle.normal),
            //         ),
            //       ),
            //     ),
            //     Container(
            //       padding: EdgeInsets.only(top: 10, left: 16, right: 16),
            //       child: Row(
            //         children: [
            //           Container(
            //             child: Text(
            //               "Email",
            //               style: TextStyle(
            //                   color: Color(0xff021029),
            //                   fontStyle: FontStyle.normal,
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 14),
            //             ),
            //           ),
            //           Container(
            //             child: Text(
            //               "(*)",
            //               style: TextStyle(
            //                   color: Color(0xffDE3E43),
            //                   fontStyle: FontStyle.normal,
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 14),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       // padding: EdgeInsets.all(10),
            //       //width: size.width /2,
            //       height: MediaQuery.of(context).size.height / 20,
            //       alignment: Alignment.center,
            //       margin: EdgeInsets.only(top: 8, left: 16, right: 16),
            //       decoration: BoxDecoration(
            //           color: Colors.white,
            //           border: Border.all(
            //             color: Colors.black38,
            //           ),
            //           borderRadius: BorderRadius.all(
            //             Radius.circular(2),
            //           )),
            //       // padding: EdgeInsets.symmetric(horizontal: 20),
            //       child: TextFormField(
            //         cursorColor: Colors.black,
            //         controller: textEditingControllerEmail,
            //         onChanged: (text) {
            //           // do something with text
            //           if (mounted) {
            //             setState(() {
            //               // HDPL_CMND = text;
            //             });
            //           }
            //         },
            //         // keyboardType: inputType,
            //         decoration: new InputDecoration(
            //           border: InputBorder.none,
            //           focusedBorder: InputBorder.none,
            //           enabledBorder: InputBorder.none,
            //           errorBorder: InputBorder.none,
            //           disabledBorder: InputBorder.none,
            //           contentPadding: EdgeInsets.only(
            //               left: 15, bottom: 11, top: 11, right: 15),
            //           hintText: "Nh???p ?????a ch??? ri??ng",
            //           hintStyle: TextStyle(
            //               fontSize: 14,
            //               fontWeight: FontWeight.w400,
            //               fontStyle: FontStyle.normal),
            //         ),
            //       ),
            //     ),
            //     Container(
            //       padding: EdgeInsets.only(top: 10, left: 16, right: 16),
            //       child: Row(
            //         children: [
            //           Container(
            //             child: Text(
            //               "??i???n tho???i di ?????ng",
            //               style: TextStyle(
            //                   color: Color(0xff021029),
            //                   fontStyle: FontStyle.normal,
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 14),
            //             ),
            //           ),
            //           Container(
            //             child: Text(
            //               "(*)",
            //               style: TextStyle(
            //                   color: Color(0xffDE3E43),
            //                   fontStyle: FontStyle.normal,
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 14),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       // padding: EdgeInsets.all(10),
            //       //width: size.width /2,
            //       height: MediaQuery.of(context).size.height / 20,
            //       alignment: Alignment.center,
            //       margin: EdgeInsets.only(top: 8, left: 16, right: 16),
            //       decoration: BoxDecoration(
            //           color: Colors.white,
            //           border: Border.all(
            //             color: Colors.black38,
            //           ),
            //           borderRadius: BorderRadius.all(
            //             Radius.circular(2),
            //           )),
            //       // padding: EdgeInsets.symmetric(horizontal: 20),
            //       child: TextFormField(
            //         cursorColor: Colors.black,
            //         controller: textEditingControllerSDT,
            //         onChanged: (text) {
            //           // do something with text
            //           if (mounted) {
            //             setState(() {
            //               // HDPL_CMND = text;
            //             });
            //           }
            //         },
            //         // keyboardType: inputType,
            //         decoration: new InputDecoration(
            //           border: InputBorder.none,
            //           focusedBorder: InputBorder.none,
            //           enabledBorder: InputBorder.none,
            //           errorBorder: InputBorder.none,
            //           disabledBorder: InputBorder.none,
            //           contentPadding: EdgeInsets.only(
            //               left: 15, bottom: 11, top: 11, right: 15),
            //           hintText: "Nh???p s??? ??i???n tho???i",
            //           hintStyle: TextStyle(
            //               fontSize: 14,
            //               fontWeight: FontWeight.w400,
            //               fontStyle: FontStyle.normal),
            //         ),
            //       ),
            //     ),
            //     Container(
            //       padding: EdgeInsets.only(top: 10, left: 16, right: 16),
            //       child: Row(
            //         children: [
            //           Container(
            //             child: Text(
            //               "N???i dung ph???n ??nh ki???n ngh???",
            //               style: TextStyle(
            //                   color: Color(0xff021029),
            //                   fontStyle: FontStyle.normal,
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 14),
            //             ),
            //           ),
            //           Container(
            //             child: Text(
            //               "(*)",
            //               style: TextStyle(
            //                   color: Color(0xffDE3E43),
            //                   fontStyle: FontStyle.normal,
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 14),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Container(
            //       height: 290,
            //       padding: EdgeInsets.all(10),
            //       child: GestureDetector(
            //         onTap: () {
            //           if (!kIsWeb) {
            //             controller.clearFocus();
            //           }
            //         },
            //         child: SingleChildScrollView(
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: <Widget>[
            //               HtmlEditor(
            //                 controller: controller, //required
            //                 hint: 'N???i dung ...',
            //                 //initalText: "text content initial, if any",
            //                 options: HtmlEditorOptions(
            //                     // height: 400,
            //                     ),
            //                 callbacks: Callbacks(
            //                   onChange: (String changed) {
            //
            //                     if (mounted) {
            //                       setState(() {
            //                         TiengVietND = changed;
            //                         HtmlTags.removeTag(
            //                           htmlString: TiengVietND,
            //                           callback: (string) {
            //                             TiengVietND = string;
            //                           },
            //                         );
            //                       });
            //                     }
            //                   },
            //                   // onEnter: () {
            //                   //   print("enter/return pressed");
            //                   // },
            //                   // onFocus: () {
            //                   //   print("editor focused");
            //                   // },
            //                   // onBlur: () {
            //                   //   print("editor unfocused");
            //                   // },
            //                   // onBlurCodeview: () {
            //                   //   print("codeview either focused or unfocused");
            //                   // },
            //                   // onInit: () {
            //                   //   print("init");
            //                   // },
            //                   // //this is commented because it overrides the default Summernote handlers
            //                   // /*onImageLinkInsert: (String? url) {
            //                   //    print(url ?? "unknown url");
            //                   //  },
            //                   //  onImageUpload: (FileUpload file) async {
            //                   //    print(file.name);
            //                   //    print(file.size);
            //                   //    print(file.type);
            //                   //  },*/
            //                   // onKeyDown: (int keyCode) {
            //                   //   print("$keyCode key downed");
            //                   // },
            //                   // onKeyUp: (int keyCode) {
            //                   //   print("$keyCode key released");
            //                   // },
            //                   // onPaste: () {
            //                   //   print("pasted into editor");
            //                   // },
            //                 ),
            //
            //                 // toolbar: [
            //                 //   Style(),
            //                 //   Font(buttons: [FontButtons.bold, FontButtons.underline,
            //                 //     FontButtons.italic],
            //                 //   )
            //                 // ]
            //               )
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     Container(
            //       padding: EdgeInsets.only(top: 8, left: 16, right: 16),
            //       child: Row(
            //         children: [
            //           Container(
            //             child: Text(
            //               "M?? b???o m???t",
            //               style: TextStyle(
            //                   color: Color(0xff021029),
            //                   fontStyle: FontStyle.normal,
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 14),
            //             ),
            //           ),
            //           Container(
            //             child: Text(
            //               "(*)",
            //               style: TextStyle(
            //                   color: Color(0xffDE3E43),
            //                   fontStyle: FontStyle.normal,
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 14),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //     Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Flexible(
            //             flex: 2,
            //             child: Container(
            //                 height: size.height / 20,
            //                 alignment: Alignment.center,
            //                 margin:
            //                     EdgeInsets.only(top: 8, left: 16, right: 16),
            //                 child: HBCheckCode(
            //                   code: code.toString(),
            //                   backgroundColor: Colors.white,
            //                 )),
            //           ),
            //           Flexible(
            //             flex: 1,
            //             child: IconButton(
            //               icon: Icon(
            //                 Icons.cached_outlined,
            //                 color: Color(0xff0368B6),
            //               ),
            //               onPressed: () {
            //                 setState(() {
            //                   ramdom();
            //                 });
            //               },
            //             ),
            //           ),
            //           Flexible(
            //             flex: 2,
            //             child: Container(
            //               // padding: EdgeInsets.all(10),
            //               //width: size.width /2,
            //               height: size.height / 20,
            //               alignment: Alignment.center,
            //               margin: EdgeInsets.only(top: 8, left: 16, right: 16),
            //               decoration: BoxDecoration(
            //                   color: Colors.white,
            //                   border: Border.all(
            //                     color: Colors.black38,
            //                   ),
            //                   borderRadius: BorderRadius.all(
            //                     Radius.circular(2),
            //                   )),
            //               // padding: EdgeInsets.symmetric(horizontal: 20),
            //               child: TextFormField(
            //                 cursorColor: Colors.black,
            //                 controller: textEditingControllerMaBaoMat,
            //                 style: TextStyle(
            //                     color: Color(0xff021029),
            //                     fontSize: 14,
            //                     fontWeight: FontWeight.w400,
            //                     fontStyle: FontStyle.normal),
            //                 onChanged: (text) {
            //                   // do something with text
            //                   if (mounted) {
            //                     setState(() {
            //                       // HDPL_CMND = text;
            //                     });
            //                   }
            //                 },
            //                 // keyboardType: inputType,
            //                 decoration: new InputDecoration(
            //                   border: InputBorder.none,
            //                   focusedBorder: InputBorder.none,
            //                   enabledBorder: InputBorder.none,
            //                   errorBorder: InputBorder.none,
            //                   disabledBorder: InputBorder.none,
            //                   contentPadding: EdgeInsets.only(
            //                       left: 15, bottom: 11, top: 11, right: 15),
            //                   hintText: "",
            //                   hintStyle: TextStyle(
            //                       fontSize: 14,
            //                       fontWeight: FontWeight.w400,
            //                       fontStyle: FontStyle.normal),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ]),
            //     Container(
            //       padding: EdgeInsets.only(top: 8, left: 16),
            //       child: Text(
            //         "????nh k??m t???p ",
            //         style: TextStyle(
            //             color: Color(0xff021029),
            //             fontStyle: FontStyle.normal,
            //             fontWeight: FontWeight.w400,
            //             fontSize: 14),
            //       ),
            //     ),
            //     Container(
            //       padding: EdgeInsets.only(top: 8, left: 16, right: 16),
            //       child: FlatButton(
            //         child: Text('????nh k??m file...'),
            //         color: Colors.blueAccent,
            //         textColor: Colors.white,
            //         onPressed: () {
            //           selectFile();
            //         },
            //       ),
            //     ),
            //     Center(
            //       child: Padding(
            //         padding: EdgeInsets.only(left: 0, right: 10, top: 0),
            //         child: TextButton.icon(
            //             icon: Icon(Icons.add_to_photos_rounded),
            //             label: Text('B??nh lu???n',
            //                 style: TextStyle(fontWeight: FontWeight.bold)),
            //             onPressed: () async {
            //               if (textEditingControllerHoTen.text == null ||
            //                   textEditingControllerHoTen.text == "" ||
            //                   textEditingControllerEmail.text == null ||
            //                   textEditingControllerEmail.text == "" ||
            //                   textEditingControllerSDT.text == null ||
            //                   textEditingControllerSDT.text == "" ||
            //                   ((TiengViet == null || TiengViet == ""))) {
            //                 showAlertDialog(
            //                     context,
            //                     "Nh???p ?????y ????? c??c "
            //                     "tr?????ng c???n thi???t (*)");
            //               } else {
            //                 if (code.toString() ==
            //                     textEditingControllerMaBaoMat.text) {
            //                   EasyLoading.show();
            //                   var thanhcong = await CongAPI.postBinhLuan(
            //                       widget.id.toString(),
            //                       textEditingControllerHoTen.text,
            //                       textEditingControllerEmail.text,
            //                       textEditingControllerSDT.text,
            //                       TiengVietND,
            //                       base64PDF);
            //                   EasyLoading.dismiss();
            //                   Navigator.of(context).pop();
            //                   showAlertDialog(
            //                       context, json.decode(thanhcong)['Message']);
            //                 } else {
            //                   setState(() {
            //                     ramdom();
            //                   });
            //                 }
            //               }
            //             },
            //             style: ButtonStyle(
            //               backgroundColor: MaterialStateProperty.all<Color>(
            //                   Colors.lightBlue),
            //               foregroundColor:
            //                   MaterialStateProperty.all<Color>(Colors.white),
            //             )),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        )
      ],
    );
  }

  Widget GetData() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dataListBL == null ? 0 : dataListBL.length,
      itemBuilder: (context, index) {
        return getBodyVB(dataListBL[index]);
      },
    );
    // return ListView.builder(
    //   itemCount: dataList == null ? 0 : dataList.length,padding: EdgeInsets.all(10),
    //   itemBuilder: (context, index) {
    //     return getCard(dataList[index]);
    //   },
    // );
  }

  Widget getBodyVB(item) {
    var title = item['Title'] ?? "";
    var BL_NoiDung = item['BL_NoiDung'] ?? "";
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Color(0xff021029),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        ),
        subtitle: Text(
          BL_NoiDung,
          style: TextStyle(
            color: Color(0xff021029),
            fontSize: 12,
            fontStyle: FontStyle.normal,
          ),
        ),
        leading: Image(image: AssetImage('assets/user.png')),
        onTap: () {},
      ),
    );
  }

  Widget GetDataPhucDap() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dataListPD == null ? 0 : dataListPD.length,
      itemBuilder: (context, index) {
        return getBodyPhucDap(dataListPD[index]);
      },
    );
    // return ListView.builder(
    //   itemCount: dataList == null ? 0 : dataList.length,padding: EdgeInsets.all(10),
    //   itemBuilder: (context, index) {
    //     return getCard(dataList[index]);
    //   },
    // );
  }

  Widget getBodyPhucDap(json) {
    var id = json['ID'] != null ? json['ID'] : 0;
    GetDataDanhGia(id);
    if (datas != null) {
      tong = (SoDiem1 + SoDiem2 + SoDiem3 + SoDiem4 + SoDiem5) / 5;

    }

    String TraLoiTiengVietPD ="";
    var tenCoQuanPD = json['tencoquantl'] != null
        ? json['tencoquantl']
        : "";
   var ndPD= json['cautraloi'] != null ? json['cautraloi'] : "";
    if(ndPD != null)
      HtmlTags.removeTag(
        htmlString: ndPD,
        callback: (string) {
          TraLoiTiengVietPD = string;
        },
      );


    var ThoiGianTaoPD =
        json['ngaytao'] != null ? json['ngaytao'] : "";
    var DiaChi = json['DiaChi'] != null ? json['DiaChi'] : "";
    var MaPAKN = json['MaPAKN'] != null ? json['MaPAKN'] : "";
    double sosao = json['sosao']!= null  && json['sosao'] !='NaN' ? json['sosao']
        :0.0;
    var DonViT = json['ID'] != null
        ? json['ID']
        : 0;

    return  Card(child:
        Container( child: Column(
      children: [
        Container(
            padding: EdgeInsets.only(top: 4, left: 0, right: 10),
            width: MediaQuery.of(context).size.width * 0.94,
            child: Text(
              "T??n c?? quan: " + tenCoQuanPD,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xff3064D0),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            )),
        Container(
          padding: EdgeInsets.only(top: 10, left: 0, right: 10),
          width: MediaQuery.of(context).size.width * 0.94,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  sosao.toStringAsFixed(2),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff021029).withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: SmoothStarRating(

                    isReadOnly: true,
                  // allowHalfRating: false,
                    rating: sosao,
                    color: Color(0xffFECD10),
                    size: 15,
                    starCount: 5,
                    // onRated: (value) async {
                    //   int i = value.toInt();
                    //   var thanhcong = null;
                    //   thanhcong =
                    //   await CongAPI.getDataDanhGia(id, i, DonViT);
                    //   Navigator.of(context).pop();
                    //   showAlertDialog(context, jsonDecode(thanhcong)['Message']);
                    // },
                  )),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 14, left: 0, right: 10),
          width: MediaQuery.of(context).size.width * 0.94,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  "Th????i gian "
                      "ta??o: " +
                      (ThoiGianTaoPD != "" ? GetDate(ThoiGianTaoPD) : "") +
                      "  " +
                      (DiaChi != null ? DiaChi : ""),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff021029).withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.1,
              //   child: Obx(
              //     () => checkplayTL.value == false
              //         ? Align(
              //             alignment: Alignment.topRight,
              //             child: IconButton(
              //               onPressed: () {
              //                 GetDataMP33(TraLoiTiengVietPD);
              //                 player.stop();
              //                 checkplayTL.value = true;
              //                 checkplay.value = false;
              //               },
              //               icon: Icon(
              //                 Icons.volume_down,
              //                 color: Colors.blue,
              //               ),
              //             ))
              //         : Align(
              //             alignment: Alignment.topRight,
              //             child: IconButton(
              //               onPressed: () {
              //                 player1.stop();
              //                 checkplayTL.value = false;
              //               },
              //               icon: Icon(
              //                 Icons.volume_off,
              //                 color: Colors.blue,
              //               ),
              //             )),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.only(top: 13.52, left: 0, right: 10),
            width: MediaQuery.of(context).size.width * 0.94,
            child: Text(
              TraLoiTiengVietPD != null ? TraLoiTiengVietPD : "",
              style: TextStyle(
                color: Color(0xff021029),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            )),
        Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(top: 10, left: 0, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              Text("????nh gi?? ",style:TextStyle(
                color: Color(0xff021029),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),),
              SmoothStarRating(
                allowHalfRating: false,
                rating: rating,
                color: Color(0xffFECD10),
                size: 15,
                starCount: 5,
                onRated: (value) async {
                  var thanhcong = null;
                  thanhcong =
                  await CongAPI.getDataDanhGia(id, value.toInt(), DonViT,MaPAKN);
                  Navigator.of(context).pop();
                  showAlertDialog(context, jsonDecode(thanhcong)['Message']);
                },
              )
            ],)),
      ],
    )),

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
