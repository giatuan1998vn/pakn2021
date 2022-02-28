
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pakn2021/core/services/congDongService.dart';

Widget html = Html(
    data: """
     <div>
    <p>Thông tin có dấu <span>(*)</span> là thông tin bắt buộc. Đề nghị tổ 
    chức, cá nhân cung cấp chính xác ít nhất một trong 2 thông tin: địa chỉ email hoặc số điện thoại di động để được nhận thông báo từ Hệ thống khi phản ánh, kiến nghị được phúc đáp.</p>
  </div>
  """,
    style: {
      "span": Style(color: Colors.red),
    }
);
Widget htmlPhone = Html(
    data: """
     <div>
    <p>Chức năng này chỉ nhận khi gọi điện thoại trực tiếp vào số <span>0211 
    1022</span>.</p>
    <span>Lưu ý:</span> Độc giả phải chịu cước phí như sử dụng điện thoại thông thường. Phải nghiêm túc, không được có những phát ngôn mang tính kích động, thô tục, phản động. Mỗi cuộc gọi không quá 10 phút. Không gọi quá 5 cuộc mỗi ngày. Nếu vi phạm quy định của Hệ thống có thể bị dừng cung cấp dịch vụ cho số điện thoại 6 tháng.
  </div>
  """,
    style: {
      "span": Style(fontWeight: FontWeight.bold),
    }
);
Widget htmlSMS = Html(
    data: """
     <div>
    <p>Chức năng này chỉ tiếp nhận qua tin nhắn SMS của điện thoại di động với cú pháp: <span>VP "Nội dung phản ánh, kiến nghị" Gửi tới số 8088</span>.</p>
    <span>Lưu ý:</span> Độc giả phải chịu cước phí 1000đ/bản tin.
  </div>
  """,
    style: {
      "span": Style(fontWeight: FontWeight.bold),
    }
);
Widget htmlGmail = Html(
    data: """
     <div>
    <p>Quý vị đăng nhập vào email của mình và gửi phản ánh, kiến nghị đến địa
     chỉ:<a>duongdaynong@vinhphuc.gov.vn.</a></p>
     <span>Lưu ý:</span> Nội dung mỗi email không quá 1000 từ. Đính kèm tối đa 5 files/lần gửi, mỗi file không quá 5MB. Một ngày một người không gửi quá 5 lần.
  </div>
  """,
    style: {
      "span": Style(fontWeight: FontWeight.bold),
    }
);
Widget htmltt = Html(
    data: """
     <div>
    <p>Thông tin có dấu<span> * </span>là thông tin bắt buộc. Đề nghị tổ 
    chức, cá nhân 
    cung cấp chính xác ít nhất một trong 2 thông tin: địa chỉ email hoặc số điện thoại di động để được nhận thông báo từ Hệ thống khi phản ánh, kiến nghị được phúc đáp</p>
  </div>
  """,
    style: {
      "span": Style(color: Colors.red),
    }
);

String tieude ="GIỚI THIỆU HỆ THỐNG TIẾP NHẬN, GIẢI QUYẾT CÁC PHẢN ÁNH, KIẾN "
    "NGHỊ CỦA TỔ CHỨC, CÁ NHÂN VỚI CHÍNH QUYỀN TỈNH VĨNH PHÚC";

Widget noiDungGT = Html(
    data: """
     <div>
      <p>Hệ thống tiếp nhận, giải quyết phản ánh, kiến nghị của tổ chức, cá nhân tỉnh Vĩnh Phúc (Gọi tắt là Hệ thống đường dây nóng) được xây dựng trên cơ sở nâng cấp Cổng thông tin đối thoại Doanh nghiệp – Chính quyền tỉnh Vĩnh Phúc (Cổng đối thoại). Trong suốt thời gian hoạt động từ 2013 đến trước thời điểm được nâng cấp, Cổng đối thoại đã phục vụ việc tiếp nhận, giải quyết nhanh nhất các khó khăn, vướng mắc mà doanh nghiệp gặp phải trong quá trình hoạt động sản xuất kinh doanh, được cộng đồng doanh nghiệp ghi nhận.</p>
 <p>Nhằm tiếp tục phát huy vai trò hỗ trợ doanh nghiệp, đồng thời mở rộng phạm vi hỗ trợ, giải quyết phản ánh, kiến nghị của mọi tổ chức, cá nhân, người dân trên địa bàn tỉnh, UBND tỉnh Vĩnh Phúc xây dựng
    <span>Hệ thống tiếp nhận, giải quyết các phản ánh, kiến nghị của tổ chức,
     cá nhân</span> với chính quyền tỉnh Vĩnh Phúc.</p>
     <p>Cụ thể:</p>
     <p>- Gọi điện thoại đến số: <span>02111022</span></p>
     <p>- Nhắn tin SMS theo cú pháp: <span>VP nội dung </span>gửi đến số 
     <span>8088</span></p>
     <p>- Gửi email đến địa chỉ: <span>duongdaynong@vinhphuc.gov.vn</span></p>
     <p>- Gửi trực tiếp qua website: <span>duongdaynong.vinhphuc.gov
     .vn</span></p>
     <p>- Gửi email đến địa chỉ: <span>duongdaynong@vinhphuc.gov.vn</span></p>
     <p>Thời gian trả lời: Không quá 5 ngày làm việc (với nội dung thuộc thẩm quyền của tỉnh).</p>
     <p>Mọi thắc mắc về Hệ thống xin vui lòng liên hệ số điện thoại: 
     <span>02113.862.480 </span>để được hỗ trợ, giải đáp.</p>
     <p>Xin chân thành cảm ơn!</p>
  </div>
  """,
    style: {
      "span": Style(fontWeight: FontWeight.bold,fontSize: FontSize(12)),
      "p": Style(fontSize: FontSize(12)),
    }
);
