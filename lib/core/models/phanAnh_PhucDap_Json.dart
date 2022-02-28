import 'package:intl/intl.dart';


class phanAnhPhucDapJson {
  final String tenCoQuanPD;
  final  String ThoiGianTaoPD;
  final String TraLoiTiengVietPD;





  //Constructor
  phanAnhPhucDapJson(
      {
        this.tenCoQuanPD,
        this.ThoiGianTaoPD,
        this.TraLoiTiengVietPD,
      });
//factory convert json to model
  factory phanAnhPhucDapJson.fromJson(Map<String, dynamic> json) {
    return  phanAnhPhucDapJson(

      tenCoQuanPD: json['TraLoiCoQuanTraLoi'] != null ?
      json['TraLoiCoQuanTraLoi']['LookupValue']: "" ,
      TraLoiTiengVietPD:  json['TraLoiTiengViet'] != null ?
      json['TraLoiTiengViet']: "" ,
      ThoiGianTaoPD: json['TraLoiNgayTraLoi'] != null ?
      json['TraLoiNgayTraLoi']: "" ,



    );

  }
}
