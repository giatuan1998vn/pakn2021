import 'package:intl/intl.dart';


class phanAnhKNJson {
   String ThoiGianTao;
   String NoiDung;
   String CauHoi;
   String DiaChi;
  final String CauHoiTiengViet;
  final String CauHoiTiengAnh;
  final String CauHoiTiengNhat;
  final String CauHoiTiengTrung;
  final String CauHoiTiengHan;
   String NguoiHoiText;
  final String TraLoiNgayTraLoi;
   String SDT;
   String Email;
   String HinhThuc;
  final String linkPDF;
  final List tenPDF;
  final String TraLoiTiengViet;
  final String TraLoiCoQuanTraLoi;
  final String TraLoiNguoiTraLoi;
  final int TrangThaiXuLy;
  final int moderationStatus;
  final int DonVi;

  final String tenCoQuanPD;
  final  String ThoiGianTaoPD;
   final String TraLoiTiengVietPD;
   final bool TrangThaiAnHien;





  //Constructor
  phanAnhKNJson(
      {
      this.ThoiGianTao,
      this.NoiDung,
      this.CauHoi,
      this.DiaChi,
      this.CauHoiTiengViet,
      this.CauHoiTiengAnh,
      this.CauHoiTiengNhat,
      this.CauHoiTiengTrung,
      this.CauHoiTiengHan,
      this.NguoiHoiText,
      this.TraLoiNgayTraLoi,
      this.SDT,
      this.Email,
      this.linkPDF,
      this.HinhThuc,
      this.TrangThaiXuLy,
      this.TraLoiTiengViet,
      this.TraLoiCoQuanTraLoi,
      this.TraLoiNguoiTraLoi,
      this.tenPDF,
      this.DonVi,
      this.tenCoQuanPD,
      this.ThoiGianTaoPD,
      this.TraLoiTiengVietPD,
      this.TrangThaiAnHien,
      this.moderationStatus,
      });
//factory convert json to model
  factory phanAnhKNJson.fromJson(Map<String, dynamic> json) {
    return  phanAnhKNJson(
      NoiDung: json['vbdiNguoiKy'] != null ?
      json['vbdiNguoiKy']: "" ,
      DiaChi: json['DiaChi'] != null ?
      json['DiaChi']: "" ,
      CauHoi: json['Title'] != null ? json['Title']: "" ,
      SDT: json['SoDienThoai'] != null ? json['SoDienThoai']: "" ,
      HinhThuc: json['HinhThuc'] != null ? json['HinhThuc']: "" ,
      Email: json['Email'] != null ? json['Email']: "" ,
      ThoiGianTao: json['NgayGui'] != null ?(json['NgayGui']) : "",
      CauHoiTiengViet: json['CauHoiTiengViet'] != null ? json['CauHoiTiengViet']: "" ,
      CauHoiTiengAnh: json['CauHoiTiengAnh'] != null ? json['CauHoiTiengAnh']: "" ,
      CauHoiTiengNhat: json['CauHoiTiengNhat'] != null ? json['CauHoiTiengNhat']: "" ,
      CauHoiTiengTrung: json['CauHoiTiengTrung'] != null ? json['CauHoiTiengTrung']: "" ,
      CauHoiTiengHan: json['CauHoiTiengHan'] != null ? json['CauHoiTiengHan']: "" ,
      NguoiHoiText: json['NguoiHoiText'] != null ? json['NguoiHoiText']: "" ,
      TraLoiNgayTraLoi: json['TraLoiNgayTraLoi'] != null ? json['TraLoiNgayTraLoi']: "" ,
      TraLoiTiengViet: json['TraLoiTiengViet'] != null ? json['TraLoiTiengViet']: "" ,
      TraLoiCoQuanTraLoi: json['TraLoiCoQuanTraLoi'] != null &&
          json['TraLoiCoQuanTraLoi']['LookupValue'] != null ?
      json['TraLoiCoQuanTraLoi']['LookupValue']: "" ,
      TraLoiNguoiTraLoi: json['TraLoiNguoiTraLoi'] != null &&
          json['TraLoiNguoiTraLoi']['LookupValue'] != null?
      json['TraLoiNguoiTraLoi']['LookupValue']: "" ,
      linkPDF: json['Attachments'] != null && json['Attachments'].length >0  ?
      json['Attachments'][0]['Url']: "" ,
      tenPDF: json['Attachments'] != null && json['Attachments'].length >0  ?
      json['Attachments']: [] ,
      TrangThaiXuLy: json['TrangThaiXuLy'] != null ? json['TrangThaiXuLy']: 0 ,
      DonVi: json['TraLoiCoQuanTraLoi'] != null &&
          json['TraLoiCoQuanTraLoi']['LookupId']!= null?
      json['TraLoiCoQuanTraLoi']['LookupId']: 0 ,
      moderationStatus: json['_ModerationStatus'] != null &&
          json['_ModerationStatus']!= null?
      json['_ModerationStatus']: 0 ,
      tenCoQuanPD: json['TraLoiCoQuanTraLoi'] != null &&
          json['TraLoiCoQuanTraLoi']['LookupValue'] != null ?
      json['TraLoiCoQuanTraLoi']['LookupValue']: "" ,
      TraLoiTiengVietPD:  json['TraLoiTiengViet'] != null ?
      json['TraLoiTiengViet']: "" ,
      ThoiGianTaoPD: json['TraLoiNgayTraLoi'] != null ?
      json['TraLoiNgayTraLoi']: "" ,
      TrangThaiAnHien: json['TrangThaiAnHien'] != null ?
      json['TrangThaiAnHien']: false ,



    );

  }
}
