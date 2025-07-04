import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vi_nho/widgets/dashboard/menu.dart';

class AboutView extends StatelessWidget{

  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giới Thiệu',style: Theme.of(context).textTheme.titleLarge,),
      ),
      drawer: Drawer(child: Menu(),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _thankYouCard(context),
            _guideCard(context),
            _buildInfo(context)
          ],
        ),
      ),
    );
  }

  Widget _thankYouCard(BuildContext context){
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                const Icon(Icons.celebration, color: Colors.orange, size: 28),
                const SizedBox(width: 8),
                Expanded( // Thêm dòng này để Text không bị tràn
                  child: Text(
                    'Cảm ơn bạn đã sử dụng app',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'Ứng dụng này là một dự án nhỏ cá nhân ',
                  ),
                  TextSpan(
                    text: 'trong quá trình học Flutter.\n',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: 'Hy vọng nó có thể giúp ích cho bạn ',
                  ),
                  TextSpan(
                    text: 'trong việc quản lý chi tiêu hằng ngày!\n',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(
                    text: 'Nếu bạn có góp ý hoặc phát hiện lỗi, ',
                  ),
                  TextSpan(
                    text: 'mình rất sẵn sàng lắng nghe.',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guideCard(BuildContext context){
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.menu_book, color: Colors.teal, size: 26),
                SizedBox(width: 8),
                Text(
                  'Hướng dẫn',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.monetization_on),
              title: Text('1. Giao dịch', style: Theme.of(context).textTheme.titleMedium,),
              subtitle: Text('Danh sách và báo cáo',style: Theme.of(context).textTheme.bodySmall,),
              childrenPadding: EdgeInsets.only(left: 25),
              children: [
                Text(
                  '+, Giao diện chính của ứng dụng là màn hình báo cáo về các giao dịch trong tháng hiện tại.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                    children: [
                      TextSpan(
                        text: '+, Để đi đến các chức năng khác, hãy lựa chọn menu ',
                        style: Theme.of(context).textTheme.bodyMedium,

                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(Icons.menu, size: 20, color: Colors.teal),
                      ),
                      TextSpan(text: ' ở góc trên cùng bên trái.',style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                _buildGuideItem(context, index: 1, title: 'Tổng quát', description: 'Quay lại trang chính.'),
                _buildGuideItem(context, index: 2, title: 'Báo cáo', description: 'Sẽ đi đến các trang báo cáo khác nhau theo thời gian:\n  - Tuần, Tháng, Năm'),
                _buildGuideItem(context, index: 3, title: 'Danh sách thu chi', description:
                'Là nơi lưu trữ chính thức các giao dịch.\n'
                    ' - Tất cả các tính năng của ứng dụng đều thông qua danh sách giao dịch.\n'
                    ' - Để thêm 1 giao dịch, hãy ấn vào biểu tượng dấu + ở góc dưới màn hình.\n'
                    ' - Để chỉnh sửa 1 giao dịch, hãy ấn vào dòng của giao dịch đó, một icon chỉnh sửa sẽ xuất hiện ở chỗ số tiền.\n'
                    ' - Ấn vào icon đó để vào giao diện chỉnh sửa.\n'
                    ' - Cuối cùng để xóa 1 giao dịch, bạn chỉ vần vuốt nó sang bên trái.'
                ),
                _buildGuideItem(context, index: 4, title: 'Loại giao dịch', description:
                'Là danh sách các loại giao dịch mà bạn phân chia.\n'
                    ' - Tương tự như danh sách giao dịch, bạn cũng có thể thêm / sửa / xoá.\n'
                    ' - Bạn có thể thay thế ảnh cho 1 loại icon nhé.'),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.savings),
              title: Text('2. Kế hoạch tiết kiệm', style: Theme.of(context).textTheme.titleMedium,),
              childrenPadding: EdgeInsets.only(left: 25),
              children: [
                Text(
                  '+, TRONG 1 THỜI GIAN CHỈ TỒN TẠI DUY NHẤT 1 KẾ HOẠCH ĐANG ĐƯỢC THỰC HIỆN.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '+, Hiện tại mình chỉ để có 2 kế hoạch chính.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),

                _buildGuideItem(context, index: 1, title: 'Tiết kiệm lũy tiến', description:
                'Bạn thấy trong các trang mạng ở đầu năm chứ.\n'
                    ' - Bạn sẽ tiết kiệm theo tuần với bắt đầu là: 10.000. \n'
                    ' - Mỗi một tuần số tiền tiết kiệm sẽ tăng lên: 20.000, 30.000, 40.000, ....!\n'
                    ' - Cứ như thế đến hết tuần cuối cùng của năm! Ờ ĐÓ LÀ THỜI GIAN BẮT ĐẦU TÍNH TOÁN CHO TẾT NHỈ!'),
                _buildGuideItem(context, index: 2, title: 'Kế hoạch do bạn tự tạo', description:
                'Bạn chọn:\n'
                    ' - Thời gian\n'
                    ' - Chu kỳ gửi tiền\n'
                    ' - Tổng số tiền của kế hoạch\n'
                    'Và bạn sẽ tiết kiệm lần lượt bằng theo cách chia đều số tiền cho các kỳ.'
                ),
                const SizedBox(height: 8),
                Text(
                  '+, Dữ liệu tiết kiệm của bạn sẽ được lấy từ DANH SÁCH CÁC GIAO DỊCH.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '+, Trong đó chỉ tính các giao dịch mà bạn chọn nó là TIẾT KIỆM.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '+, Khi thời hạn kết thúc - Kế hoạch tiết kiệm của bạn sẽ được đóng vào ngày hôm sau. Đồng nghĩa kế hoạch kết thúc.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

  Widget _buildGuideItem(BuildContext context, {required int index, required String title, required String description}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: RichText(
          textAlign: TextAlign.left, // Bắt buộc: căn trái text
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            children: [
              TextSpan(
                text: '$index. $title: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: description),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context){
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            Row(
              children: const [
                Icon(Icons.campaign, color: Colors.redAccent),
                SizedBox(width: 8),
                Text(
                  'QUẢNG CÁO',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(height: 12),

            // Nội dung chính
            Text(
              'Hì hì, xin phép mọi người cho mình "quảng cáo" một chút nha 😄\n'
                  'Mình là một sinh viên ngành Công nghệ Thông tin, đã tốt nghiệp năm 2024.\n'
                  'Ban đầu mình làm về Web với tư cách Web developer, nhưng từ năm 2025 mình bắt đầu học lập trình app với Android Studio và Java thuần.\n'
                  'Và gần đây mình đang làm quen với Flutter.\n'
                  'Ứng dụng bạn đang dùng chính là một sản phẩm mình tự học và tự làm trong quá trình đó.\n'
                  'Vậy nên nếu có gì thiếu sót, mình rất mong nhận được góp ý từ mọi người!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 12),

            // Nút mở CV
            InkWell(
              onTap: () async{
                final Uri url = Uri.parse('https://letienit.github.io/cv_me/');
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw 'Could not launch https://letienit.github.io/cv_me/';
                  }
              },
              child: Row(
                children: [
                  const Icon(Icons.description, size: 20, color: Colors.blueAccent),
                  const SizedBox(width: 6),
                  Text(
                    'Xem CV của mình tại đây',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Kết thúc
            Text(
              'Cảm ơn mọi người đã đọc ❤️',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}