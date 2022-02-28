import "dart:convert";

import "package:http/http.dart" as http;
import "package:pakn2021/core/services/callApi.dart";
import 'package:shared_preferences/shared_preferences.dart';

class CongAPI {
  static Future<String> getUser() async {
    var parts = [];
    var formData = {

    };
    sharedStorage = await SharedPreferences.getInstance();
    String username = sharedStorage.getString("username");
    String url = "api/CongAPI/GetUser?TenDangNhap=$username";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getUserCN() async {
    sharedStorage = await SharedPreferences.getInstance();
    String username = sharedStorage.getString("username");
    var parts = [];
    // parts.add("ItemID=" + idDuThao.toString());

    //parts.add("SYear=" + nam);
    var formData = parts.join("&");
    String url = "api/CongAPI/GetTTUserDoanhNghiep?tendangnhap=$username";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getDataDetailVBPAKN(
      String ActionXL, int length,TrangThaiXuLy,LoaiTiepNhan,CongKhai,
      String NguoiHoi)
  async {

    final formData = {
      "Length": "$length",
      "Skip": "0",
      "TrangThaiXuLy": "$TrangThaiXuLy",
      "LoaiTiepNhan": "$LoaiTiepNhan",
      "CongKhai": "$CongKhai",
      "NguoiHoi": "$NguoiHoi",
      "FieldOrder": "Created",
      "Ascending": "false",



    };

    String url = "api/CongAPI/$ActionXL";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }
  static Future<String> getDataDetailVBPAKNCB(
      String ActionXL, int length,TrangThaiXuLy,LoaiTiepNhan,CongKhai
      )
  async {

    final formData = {
      "Length": "$length",
      "Skip": "0",
      "TrangThaiXuLy": "$TrangThaiXuLy",
      "LoaiTiepNhan": "$LoaiTiepNhan",
      "CongKhai": "$CongKhai",
      "FieldOrder": "ID",
      "Ascending": "false",
      "TraLoiCoQuanTraLoi":"$IDDonVi"
    };

    String url = "api/CongAPI/$ActionXL";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }
  static Future<String> getDataDetailVBPAKNs(
      String ActionXL, String qury, int length) async {
    sharedStorage = await SharedPreferences.getInstance();
    String token = sharedStorage.getString("token");
    var headers = {
      'Token': '$token',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('http://hotlinevp'
        '.ungdungtructuyen.vn/AppMobile/api/CongAPI/GetListItem'));
    request.body = json.encode({
      "Length": 20
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }



    // String url = "api/CongAPI/$ActionXL";
    // var response = await responseDataPost(url, formData);
    // if (response.statusCode == 200) {
    //   var items = (response.body);
    //   return items;
    // }
  }

  static Future<String> getDataPAKN(String ActionXL, int length) async {

    // parts.add("SYear=" + nam);
    var formData = {
      "cfg":'1',
      "length":'$length'
    };
    String url = "api/CongAPI/$ActionXL";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getDataDetailVB(String ActionXL, String title,
      String tungay, String denngay, cquan, int length) async {
    if (tungay == null) {
      tungay = "";
    }
    if (tungay == null) {
      tungay = "";
    }
    var parts = [];
    // parts.add("ItemID=" + idDuThao.toString());
    parts.add("ActionXL=" + ActionXL);
    parts.add("Keyword=" + title);
    parts.add("FromDate=" + tungay);
    parts.add("ToDate=" + denngay);
    parts.add("length=" + length.toString());
    parts.add("skip=0");
    parts.add("TraLoiCoQuanTL=" + cquan);
    // parts.add("SYear=" + nam);
    var formData = parts.join("&");
    String url = "/api/CongAPI/$ActionXL";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getDataDetailVBTraCuu(String ActionXL, String title,
      String tungay, String denngay, cquan, int length) async {
    if (tungay == null) {
      tungay = "";
    }
    if (tungay == null) {
      tungay = "";
    }
    final formData = {
      "Keyword=": "$title",
      "FromDate=": "$tungay",
      "ToDate=": "$denngay",
      "OldID": "0",
      "CongKhai": "1",
      "length=": "$length",
      "skip": "0",
      "TraLoiCoQuanTL=": "$cquan",
    };
    String url = "/api/CongAPI/$ActionXL";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getDataDetailVBTK(String ActionXL, String title,
      String tungay, String denngay, cquan,tencq) async {
    if (tungay == null) {
      tungay = "";
    }
    if (tungay == null) {
      tungay = "";
    }
    final formData ={
      'KeyWord':'$title',
      'FromDate':'$tungay',
      'ToDate':'$denngay',
      'TraLoiCoQuanTL':'$cquan',
      "DonViText":'$tencq',
      "FindInFields":["Title","HinhThuc","MaPAKN"],
      "Length":"20",
      "LocTrung":"0",
    };

    String url = "api/CongAPI/$ActionXL";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }
  static Future<String> getDataDetailVBCN(String ActionXL, String title) async {

    var formData = {
      "NguoiHoi":'$title',
      "Length":'20'
    };
    String url = "/api/CongAPI/$ActionXL";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getDataDetailVBPA(
      String title, String tungay, String denngay) async {
    var parts = [];
    if (tungay == null) {
      tungay = "";
    }
    if (tungay == null) {
      tungay = "";
    }

    //
    final formData = {
      "Keyword": "$title",
      "FromDate": "$tungay",
      "ToDate": "$denngay",
      "length": "10",
      "skip": "0",
      "page": "1",
      "pageSize": "10",
      "sort[0][field]": "Created",
      "sort[0][dir]": "desc"
    };
    String url = "/api/CongAPI/GetListItemTraCuu";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getDataDetail(int id) async {
    var parts = [];

    String url = "api/CongAPI/GetDataDetail?ItemID=$id";
    var response = await responseData(url);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getDataDetailPhucDap(int id) async {
    var parts = [];

    //
    parts.add("ItemID=" + id.toString());
    // parts.add("SitesColection=" + MaDonVi.toString());
    var formData = parts.join("&");
    String url = "/api/CongAPI/GetDataDetailPhucDap?ItemID=$id";
    var response = await responseData(url);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getDataBinhLuan(int id) async {
    var parts = [];

    //
    parts.add("BL_ItemID=" + id.toString());
    // parts.add("SitesColection=" + MaDonVi.toString());
    var formData = parts.join("&");
    String url = "/api/CongAPI/ActionXL=GetListBinhLuan";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getDatadg(int id) async {
    var parts = [];

    // parts.add("SitesColection=" + MaDonVi.toString());
    var formData = "";
    String url = "/api/CongAPI/GetDanhGia?IteamID=$id";
    var response = await responseUser(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getDataDanhGia(int id, diem, DonVi, MaPAKN) async {

    // parts.add("SitesColection=" + MaDonVi.toString());
    var formData = {
      "SoDiemTT":'$diem',
      "Title":'$id',
      "DonVi":'$DonVi',
      "MaPAKN":'$MaPAKN',
    };
    String url = "/api/CongAPI/DanhGia";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> GetMenuLeft(String ActionXL) async {
    var parts = [];

    //
    parts.add("ActionXL=" + ActionXL);
    // parts.add("SitesColection=" + MaDonVi.toString());
    sharedStorage = await SharedPreferences.getInstance();
    String tendangnhap = sharedStorage.getString("username");
    var formData = {
      "TenDangNhap":"$tendangnhap"
    };
    String url = "/api/CongAPI/$ActionXL";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> postSuaCB(
      int id,
      String ActionXL,
      TiengViet,
      TiengAnh,
      TiengTrung,
      TiengNhat,
      TiengHan,
      CauHoi,
      NguoiHoiText,
      DiaChi,
      SDT,
      Email) async {
    //
    // parts.add("ItemID=" + id.toString());
    // parts.add("ActionXL=" + ActionXL);
    // parts.add("strTraLoiVie=" + TiengViet);
    // parts.add("strTraLoiEng=" + TiengAnh);
    // parts.add("strTraLoiJa=" + TiengNhat);
    // parts.add("strTraLoiKo=" + TiengHan);
    // parts.add("strTraLoiChi=" + TiengTrung);
    // parts.add("SearchTitle=" + CauHoi);
    // parts.add("NguoiHoiText=" + NguoiHoiText);
    // parts.add("Email=" + Email);
    // parts.add("SoDienThoai=" + SDT);
    // parts.add("DiaChi=" + DiaChi);

    // parts.add("SitesColection=" + MaDonVi.toString());
    final formData ={
      "ID":'$id',
      "CauHoiTiengViet":'$TiengViet',
      "CauHoiTiengAnh":'$TiengAnh',
      "CauHoiHan":'$TiengHan',
      "CauHoiTrung":'$TiengTrung',
      "SearchTitle":'$CauHoi',
        "Title":'$CauHoi',
      "NguoiHoiText":'$NguoiHoiText',
      "Email":'$Email',
      "SoDienThoai":'$SDT',
      "DiaChi":'$DiaChi',
    };
    String url = "/api/CongAPI/$ActionXL";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> postTuChoi(int id, String ActionXL, TiengViet, TiengAnh,
      TiengTrung, TiengNhat, TiengHan) async {
    var parts = [];

    //
    // parts.add("ItemID=" + id.toString());
    // parts.add("ActionXL=" + ActionXL);
    // parts.add("strTraLoiVie=" + TiengViet);
    // parts.add("strTraLoiEng=" + TiengAnh);
    // parts.add("strTraLoiJa=" + TiengNhat);
    // parts.add("strTraLoiKo=" + TiengHan);
    // parts.add("strTraLoiChi=" + TiengTrung);
    // parts.add("SitesColection=" + MaDonVi.toString());

    var formData = {
      "ID":'$id',
      "CauTraLoiTiengViet":'$TiengViet',
      "CauTraLoiTiengAnh":'$TiengAnh',
      "CauTraLoiTiengHan":'$TiengHan',
      "CauTraLoiTiengTrung":'$TiengTrung',
    };
    String url = "/api/CongAPI/$ActionXL";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> postCongKhai(int id, String ActionXL) async {

    String url = "/api/CongAPI/$ActionXL?ItemID=$id";
    var response = await responseData(url);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }
  static Future<String> GetHuongDan(int loaiPAKN) async {
    var parts = [];

    //
    parts.add("LoaiPAKN=" + loaiPAKN.toString());
    var formData = parts.join("&");
    String url = "api/CongAPI/GetHuongDan?LoaiPAKN=$loaiPAKN";
    var response = await responseDataPost(url,formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> postSua(
      int id, String ActionXL, hoten, email, sdt, diachi) async {
    var parts = [];

    //
    parts.add("ItemID=" + id.toString());
    parts.add("ActionXL=" + ActionXL);
    parts.add("NguoiHoiText=" + hoten);
    parts.add("Email=" + email);
    parts.add("SoDienThoai=" + sdt);
    parts.add("DiaChi=" + diachi);
    // parts.add("SitesColection=" + MaDonVi.toString());
    var formData = parts.join("&");
    String url = "/api/services/XuLyCong";
    var response = await responseDataPost(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> postPhanXL(
      int id, String ActionXL, coQuan, thoigian) async {
    var parts = [];
    parts.add("strThoiGianXuLy=" + thoigian);
    parts.add("ItemID=" + id.toString());
    parts.add("lstiddonvi=" + coQuan);
    var formData = parts.join("&");
    // parts.add("SitesColection=" + MaDonVi.toString());
    // var formData = {
    //   "strThoiGianXuLy":'$thoigian',
    //   "ItemID":'$id',
    //   "lstiddonvi":'$coQuan'
    //   "lstiddonvi":'$coQuan'
    // };
    String url = "/api/CongAPI/$ActionXL?ItemID=$id"
        "&lstiddonvi=$coQuan&thoigianxl=$thoigian";
    var response = await responseUser(url,formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getDataMP3(String MP3) async {
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "http://lgspsi.ungdungtructuyen.vn/APIShare/GetTextToSpeech"));
    request.fields.addAll({"htmldata": "$MP3", "fullurl": '"check"'});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return respStr;
    } else {}

  }

  static Future<String> PostDangKyGG(String email, String hoten) async {
    final formData = {
      "HoVaTen": "$hoten",
      "Email": "$email",
      "Title": "$email",
    };
    String url = "/api/CongAPI/UpdateTaiKhoan";
    var response = await responseDataNoToken(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> PostDangKy(String email, String pass) async {
    var parts = [];
    parts.add("TenTruyCap=" + email.toString());
    parts.add("MatKhau=" + pass);
    parts.add("Title=" + email);
    // parts.add("SitesColection=" + MaDonVi.toString());
    var formData = parts.join("&");
    String url = "/api/CongAPI/PostDangKy";
    var response = await responseDataNoToken(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> getDataCoQuan() async {
    String url = "api/CongAPI/GetListCoQuanTL?take=0";
    var response = await responseGetDataNoToken(url);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> SendToken(
      String emaillogin,
      String usernamelogin,
      String accessToken,
      String logintype,
      ) async {
    final formData = {
      "emaillogin": "$emaillogin",
      "usernamelogin": "$usernamelogin",
      "accessToken": "$accessToken",
      "logintype": "$logintype",
    };

    String url = "api/CongAPI/AddToKen";
    var response = await responseDataNoToken(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }
  static Future<String> RemoveToken(
      String emaillogin,
      String usernamelogin,
      String accessToken,
      String logintype,
      ) async {
    final formData = {
      "emaillogin": "$emaillogin",
      "usernamelogin": "$usernamelogin",
      "accessToken": "$accessToken",
      "logintype": "$logintype",
    };

    String url = "api/CongAPI/RemoveToken";
    var response = await responseDataNoToken(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> postTAOPA(
      String HoTen,
      String TuCach,
      String DiaChi,
      String Email,
      String SDT,
      String TieuDe,
      String TiengViet,
      String TiengAnh,
      String TiengTrung,
      String TiengNhat,
      String TiengHan,
      String namePDF,
      String base64,
      String idCN,
      String idKN,
      Created,
      IDCoQuan) async {
    var parts = [];
    if (base64 == null) base64 = "";

    // parts.add("ItemID=" + idDuThao.toString());
    // parts.add("ActionXL=" + ActionXL);
    // parts.add("SYear=" + nam);
    final formData = {
      "NguoiHoiText": "$HoTen",
      "SoDienThoai": "$SDT",
      "DiaChi": "$DiaChi",
      "Title": "$TieuDe",
      "CauHoiTiengTrung": "$TiengTrung",
      "CauHoiTiengHan": "$TiengHan",
      "Email": "$Email",
      "CauHoiTiengViet": "$TiengViet",
      "CauHoiTiengAnh": "$TiengAnh",
      "CauHoiTiengNhat": "$TiengNhat",
      "TrangThaiAnHien": "$idCN",
      "ShowHide": "$idKN",
      "NameImage": "$namePDF",
      "TuCach": "$TuCach",
      "DataFile": "$base64",
      "Created": "$Created",
      "DonViTraLoi": "$IDCoQuan",
      "NguoiHoi":{"LookupID":"$CurrentID","LookupValue":""},
    };

    String url = "api/CongAPI/Update";
    var response = await responseDataPostTao(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }

  static Future<String> postBinhLuan(
      String id,
      String HoTen,
      String Email,
      String SDT,
      String TiengViet,
      String base64,
      ) async {
    var parts = [];
    if (base64 == null) base64 = "";

    // parts.add("ItemID=" + idDuThao.toString());
    // parts.add("ActionXL=" + ActionXL);
    // parts.add("SYear=" + nam);
    final formData = {
      "strHoTen": "$HoTen",
      "strSDT": "$SDT",
      "ItemID": "$id",
      "Email": "$Email",
      "strNoiDung": "$TiengViet",
      "strattachment": "$base64",
    };

    String url = "/api/CongAPI/UpdateBinhLuan";
    var response = await responseDataNoToken(url, formData);
    if (response.statusCode == 200) {
      var items = (response.body);
      return items;
    }
  }
}
