import 'package:flutter/material.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = const Color(0xFFB0F847);
    final dark = const Color(0xFF202328);
    final sectionTitleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: dark);
    final headingStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: dark);
    final bulletStyle = TextStyle(fontSize: 14, height: 1.35, color: Colors.grey[800]);

    Widget buildCard({required Widget child}) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3)),
            ],
          ),
          child: child,
        );

    Widget buildBullets(List<String> items) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final t in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 16, height: 1.35)),
                    Expanded(child: Text(t, style: bulletStyle)),
                  ],
                ),
              )
          ],
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chính sách',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: Color(0xFFB0F847)),
        ),
        backgroundColor: dark,
        foregroundColor: accent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
            child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title card
                buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chính sách Mua hàng & Bán hàng', style: headingStyle),
                      const SizedBox(height: 8),
                      Text(
                        'Tài liệu này quy định quyền, nghĩa vụ và quy trình dành cho khách mua và người bán trên nền tảng Stream Cart.',
                        style: bulletStyle,
                      ),
                    ],
                  ),
                ),

                // I. Mua hàng
                buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('I. CHÍNH SÁCH MUA HÀNG', style: sectionTitleStyle),
                      const SizedBox(height: 12),
                      _SectionLabel(text: '1. Điều kiện mua hàng'),
                      buildBullets(const [
                        'Đăng ký tài khoản hợp lệ và cung cấp thông tin đầy đủ, chính xác.',
                        'Tài khoản đã xác thực email/số điện thoại và đang hoạt động.',
                        'Tài khoản bị khóa / vô hiệu / chưa kích hoạt không thể đặt hàng.',
                      ]),
                      _SectionLabel(text: '2. Đặt hàng'),
                      buildBullets(const [
                        'Chỉ sản phẩm còn hàng & trạng thái "Đang bán" mới có thể đặt mua.',
                        'Thông tin sản phẩm hiển thị rõ ràng: tên, mô tả, giá, hình ảnh, tồn kho.',
                        'Người mua phải xác nhận đơn hàng trước thanh toán.',
                        'Sau khi đặt thành công, hệ thống gửi thông báo / email chi tiết.',
                      ]),
                      _SectionLabel(text: '3. Thanh toán'),
                      buildBullets(const [
                        'Hỗ trợ: Thanh toán Online hoặc COD.',
                        'Đơn hàng chỉ xác nhận khi thanh toán online thành công hoặc người mua xác nhận COD.',
                        'Thanh toán thất bại -> đơn hàng tự động huỷ.',
                        'Thông tin thanh toán được bảo vệ, tuân thủ chuẩn bảo mật PCI DSS.',
                      ]),
                      _SectionLabel(text: '4. Vận chuyển & giao hàng'),
                      buildBullets(const [
                        'Người mua cung cấp địa chỉ chính xác.',
                        'Thời gian giao phụ thuộc vị trí & phương thức vận chuyển.',
                        'Có thể theo dõi trạng thái: Pending, Processing, Shipping, Completed, Canceled.',
                        'Giao không thành công nhiều lần có thể dẫn đến hủy đơn.',
                      ]),
                      _SectionLabel(text: '5. Đổi trả & hoàn tiền'),
                      buildBullets(const [
                        'Được đổi trả trong thời gian quy định (theo chính sách từng shop).',
                        'Hàng còn tem, nhãn, chưa sử dụng (trừ hàng lỗi).',
                        'Hoàn tiền qua đúng phương thức thanh toán ban đầu.',
                        'Mọi giao dịch hoàn tiền đều ghi nhận để phòng tránh gian lận.',
                      ]),
                      _SectionLabel(text: '6. Quyền & nghĩa vụ khách hàng'),
                      buildBullets(const [
                        'Quyền khiếu nại khi sản phẩm sai mô tả, lỗi hoặc giao không đúng.',
                        'Bảo mật tài khoản, không chia sẻ mật khẩu.',
                        'Thanh toán đầy đủ & đúng hạn.',
                        'Không lợi dụng chính sách đổi trả/hoàn tiền để trục lợi.',
                      ]),
                    ],
                  ),
                ),

                // II. Bán hàng
                buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('II. CHÍNH SÁCH BÁN HÀNG', style: sectionTitleStyle),
                      const SizedBox(height: 12),
                      _SectionLabel(text: '1. Điều kiện mở shop'),
                      buildBullets(const [
                        'Đăng ký shop với thông tin đầy đủ (tên, địa chỉ, liên hệ).',
                        'Chỉ hoạt động sau khi Admin phê duyệt.',
                        'Mỗi tài khoản quản lý một shop.',
                      ]),
                      _SectionLabel(text: '2. Quản lý sản phẩm'),
                      buildBullets(const [
                        'Chỉ đăng hàng hợp pháp, không vi phạm pháp luật.',
                        'Thông tin đầy đủ: tên, mô tả, giá, tồn kho, hình ảnh chính xác.',
                        'Hệ thống tự động cập nhật đã bán & tồn kho real-time.',
                        'Không chỉnh sửa lịch sử giao dịch đã hoàn tất.',
                      ]),
                      _SectionLabel(text: '3. Xử lý đơn hàng'),
                      buildBullets(const [
                        'Xác nhận & chuẩn bị đơn trong thời hạn quy định.',
                        'Đóng gói & bàn giao vận chuyển đúng hạn.',
                        'Cập nhật trạng thái đơn thường xuyên.',
                      ]),
                      _SectionLabel(text: '4. Giá & khuyến mãi'),
                      buildBullets(const [
                        'Thiết lập giá gốc / giảm / phần trăm giảm.',
                        'Giá hiển thị cho khách luôn là giá cuối cùng.',
                        'Chương trình đặc biệt có thể cần duyệt.',
                      ]),
                      _SectionLabel(text: '5. Nghĩa vụ & trách nhiệm'),
                      buildBullets(const [
                        'Đảm bảo chất lượng đúng mô tả, không giao hàng giả/nhái.',
                        'Hỗ trợ CSKH & đổi trả đúng quy định.',
                        'Chịu trách nhiệm nếu giao sai, trễ hoặc gây thiệt hại.',
                        'Tuân thủ thuế, hoá đơn & pháp luật TMĐT.',
                      ]),
                      _SectionLabel(text: '6. Xử lý vi phạm'),
                      buildBullets(const [
                        'Các mức: Cảnh cáo → Tạm ngưng → Đóng cửa vĩnh viễn.',
                        'Hành vi gian lận nghiêm trọng có thể bị xử lý pháp luật.',
                      ]),
                    ],
                  ),
                ),

                // III. Điều khoản chung
                buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('III. ĐIỀU KHOẢN CHUNG', style: sectionTitleStyle),
                      const SizedBox(height: 12),
                      buildBullets(const [
                        'Cả khách mua & người bán phải tuân thủ đầy đủ quy định hệ thống.',
                        'Mọi giao dịch được ghi nhận & có thể làm bằng chứng khi tranh chấp.',
                        'Hệ thống có quyền điều chỉnh chính sách để đảm bảo công bằng & bảo vệ quyền lợi đôi bên.',
                      ]),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: dark.withOpacity(0.9), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Việc tiếp tục sử dụng nền tảng đồng nghĩa bạn đã đọc và đồng ý với toàn bộ chính sách.',
                                style: TextStyle(fontSize: 13, height: 1.4, color: dark.withOpacity(0.9)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Text(text.toUpperCase(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey[700], letterSpacing: 0.5)),
    );
  }
}
