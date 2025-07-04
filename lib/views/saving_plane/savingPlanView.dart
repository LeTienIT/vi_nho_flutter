import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/models/planModel.dart';
import 'package:vi_nho/viewmodels/planVM.dart';
import 'package:vi_nho/viewmodels/transactionVM.dart';
import 'package:vi_nho/widgets/dashboard/menu.dart';
import 'package:vi_nho/widgets/infoRow.dart';
import 'package:vi_nho/widgets/saving_plan/calendarWidget.dart';
import 'package:vi_nho/widgets/saving_plan/showCustomPlanDialog.dart';

class SavingPlanView extends StatefulWidget {
  const SavingPlanView({super.key});

  @override
  State<SavingPlanView> createState() => _SavingPlanView();
}

class _SavingPlanView extends State<SavingPlanView> {
  String? _selectedPlan;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlanVM>();
    if(!vm.isLoad){
      return Center(child: CircularProgressIndicator(),);
    }
    if(vm.checkOpenPlan()['rs'] == -1){
      return Scaffold(
        appBar: AppBar(title: const Text('Chọn gói tiết kiệm')),
        drawer: Drawer(child: Menu(),),
        body: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: RichText(
              text: TextSpan(
                text: 'Có lỗi nghiêm trọng!\n',
                style: Theme.of(context).textTheme.titleSmall,
                children: [
                  TextSpan(
                    text: 'Phát hiện có [ > 1 gòi tiết kiệm đang mở ]\n',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer
                    )
                  ),
                  TextSpan(
                      text: 'Hãy mở danh sách để chỉnh sửa\n',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer
                      ),
                    onEnter: (click){

                    }
                  )
                ]
              ),
          ),
        ),
      );
    }
    if(vm.checkOpenPlan()['rs'] == 1){
      final idPlan = vm.checkOpenPlan()['id'];
      PlanModel? plan = vm.list.firstWhere((p) => p.id == idPlan);
      if(plan == null){
        return Scaffold(
            appBar: AppBar(title: const Text('Chọn gói tiết kiệm')),
            drawer: Drawer(child: Menu(),),
            body: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text('Lỗi nghiêm trọng, không thể lấy được kế hoạch hiện tại',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer
              ),),
            ),
        );
      }

      final transactionVM = context.watch<TransactionVM>();
      final dataDashboard = transactionVM.getSavingPlan(plan!);
      _selectedPlan = plan.tenKeHoach == 'fixedUntilLunarNewYear' ? 'fixedUntilLunarNewYear' : 'customRange';
      return Scaffold(
          appBar: AppBar(title: const Text('Bạn đang thực hiện kế hoạch')),
          drawer: Drawer(child: Menu(),),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if(plan.tenKeHoach == 'fixedUntilLunarNewYear')...[
                  _buildPlanCard(
                    nameJson: 'assets/piggy-1.json',
                    planType: 'fixedUntilLunarNewYear',
                    title: "Gói lũy tiến hết năm",
                    description:
                    "- Gửi tiền đều đặn hàng tuần theo cách lũy tiến đến hết năm.\n"
                        "- Bạn sẽ bắt đầu tuần thứ nhất với 10k, tuần thứ 2 với 20k,.....",
                  ),
                ]
                else
                  _buildPlanCard(
                    planType: 'customRange',
                    title: "Gói tùy chọn",
                    description:
                    "- Bạn chọn khoảng thời gian, mục tiêu và tần suất gửi tiền (ngày hoặc tuần).\n"
                        "- Ứng dụng sẽ tính toán số tiền cần gửi mỗi khoảng thời gian.",
                  ),

                _buildCardDaboard(dataDashboard, plan),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/plan-list');
            },
            child: const Icon(Icons.list),
          ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn gói tiết kiệm')),
      drawer: Drawer(child: Menu(),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildPlanCard(
              nameJson: 'assets/piggy-1.json',
              planType: 'fixedUntilLunarNewYear',
              title: "Gói lũy tiến hết năm",
              description:
              "- Gửi tiền đều đặn hàng tuần theo cách lũy tiến đến hết năm.\n"
                  "- Bạn sẽ bắt đầu tuần thứ nhất với 10k, tuần thứ 2 với 20k,.....",
              showRadio: true
            ),
            _buildPlanCard(
              planType: 'customRange',
              title: "Gói tùy chọn",
              description:
              "- Bạn chọn khoảng thời gian, mục tiêu và tần suất gửi tiền (ngày hoặc tuần).\n"
                  "- Ứng dụng sẽ tính toán số tiền cần gửi mỗi khoảng thời gian.",
              showRadio: true,
            ),
            _buildWarning(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _selectedPlan == null ? null : ()async{
                  if(_selectedPlan == 'customRange'){
                    final result = await ShowCustomPlanDialog.showCustomPlanDialog(context);
                    if(result != null){
                      final DateTime start = result['startDate'];
                      final DateTime end = result['endDate'];
                      final String freq = result['frequency'];
                      final double goal = result['goal'];
                      final double perPeriod = result['perPeriod'];

                      PlanModel plan = PlanModel(_selectedPlan!, start, end, freq, goal, perPeriod,hoanThanh: 0,thanhCong: -1);
                      final rs = await _showDialogCommit(context);
                      if(rs){
                        await vm.insert(plan);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Thiết lập kế hoạch tiết kiệm thành công')));
                      }
                    }
                  }else{
                    final rs = await _showDialogCommit(context);
                    if(rs){
                      final now = DateTime.now();
                      PlanModel plan = PlanModel(
                          _selectedPlan!,
                          DateTime(now.year,1,1),
                          DateTime(now.year,12,31),
                          'Tuần',
                          calculateTongTien(calculateTotalWeeks(DateTime(now.year,1,1), DateTime(now.year,12,31))),
                          10000,
                          hoanThanh: 0,
                          thanhCong: -1
                      );
                      await vm.insert(plan);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Thiết lập kế hoạch tiết kiệm thành công')));
                    }
                  }
                },
                child: const Text('Xác nhận'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/plan-list');
        },
        child: const Icon(Icons.list),
      ),
    );
  }

  Widget _buildPlanCard({String? nameJson,required String planType, required String title, required String description,bool showRadio=false, bool showBorder=false})
  {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPlan = planType;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedPlan == planType ? Colors.blue : Colors.grey.shade300,
              width: 2,
            ),
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:  Theme.of(context).colorScheme.onSurface
                          )),
                      const SizedBox(height: 8),
                      Text(description, style: TextStyle(fontSize: 14,color:  Theme.of(context).colorScheme.onSurface)),
                    ],
                  ),
                ),
              ),
              if(showRadio)
                Radio<String>(
                  value: planType,
                  groupValue: _selectedPlan,
                  onChanged: (value) {
                    setState(() {
                      _selectedPlan = value;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarning(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.orange,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Thông tin',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Sau khi chọn kế hoạch xong sẽ không thể thay đổi cho đến khi kế hoạch kết thúc',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _buildCardDaboard(Map<String, dynamic> data, PlanModel plan){
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data['ten'],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Icon(Icons.savings, color: Colors.orange, size: 28),
              ],
            ),
            SizedBox(height: 8,),

            InfoRow(label: 'Thời hạn: ', content: '${DateFormat('dd/MM/yyyy').format(plan.ngayBD)} -> ${DateFormat('dd/MM/yyyy').format(plan.ngayKT)}',),
            SizedBox(height: 8,),

            InfoRow(label: 'Chu kỳ: ', content: plan.chuKy),
            SizedBox(height: 8,),

            InfoRow(label: 'Tổng: ', content: '${data['tongChuKy']} ${plan.chuKy}'),
            SizedBox(height: 8,),

            if(data['ngayNopTiepTheo']!=null)...[
              InfoRow(label: 'Ngày tiết kiệm tiếp theo: ', content: DateFormat('dd/MM/yyyy').format(data['ngayNopTiepTheo'])),
              const SizedBox(height: 12),
              InfoRow(label: 'Số tiết kiệm tiếp theo', content: NumberFormat.currency(locale: 'vi').format(data['soTienNopTiepTheo'])),
              const SizedBox(height: 12),
            ],

            Text('Tiến độ tiết kiệm', style: Theme.of(context).textTheme.titleMedium ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: data['daHoanThanh'],
              backgroundColor: Colors.grey.shade300,
              color: Colors.green,
              minHeight: 8,
            ),
            const SizedBox(height: 6),

            Text('${(data['daHoanThanh'] * 100).toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.titleSmall),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Đánh giá',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Icon(Icons.savings, color: Colors.orange, size: 28),
              ],
            ),
            _danhGia(data['danhGia']),
            CalendarWidget(dates: data['danhSachNgayCanNop'], soNgayThieu: data['danhSachNgayNopThieu'])
          ],
        ),
      ),
    );
  }

  Widget _danhGia(String danhGia){
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          danhGia,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Future<bool> _showDialogCommit(BuildContext context) async{
    return await showDialog<bool>(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Nhắc nhở'),
            content: const Text(
              'Sau khi xác nhận kế hoạch sẽ không thể sửa hoặc xóa\n\n'
                  'Chỉ có thể chọn kế hoạch mới sau khi kế hoạch trước đã kết thúc',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Xác nhận'),
              ),
            ],
          );
        }
    ) ?? false;
  }

  int calculateTotalWeeks(DateTime start, DateTime end) {
    final days = end.difference(start).inDays + 1;
    return (days / 7).floor();
  }

  double calculateTongTien(int soTuan) {
    return (10000 * soTuan * (soTuan + 1) ~/ 2).toDouble();
  }
}
