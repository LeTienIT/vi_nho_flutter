import 'package:flutter/material.dart';
import 'package:vi_nho/models/planModel.dart';
import 'package:vi_nho/widgets/dashboard/menu.dart';
import 'package:vi_nho/widgets/saving_plan/showCustomPlanDialog.dart';

class SelectSavingPlanView extends StatefulWidget {
  const SelectSavingPlanView({super.key});

  @override
  State<SelectSavingPlanView> createState() => _SelectSavingPlanViewState();
}

class _SelectSavingPlanViewState extends State<SelectSavingPlanView> {
  String? _selectedPlan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn gói tiết kiệm')),
      drawer: Drawer(child: Menu(),),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildPlanCard(
            planType: 'fixedUntilLunarNewYear',
            title: "Gói lũy tiến hết năm",
            description:
            "- Gửi tiền đều đặn hàng tuần theo cách lũy tiến đến hết năm.\n"
                "- Bạn sẽ bắt đầu tuần thứ nhất với 10k, tuần thứ 2 với 20k,.....",
          ),
          _buildPlanCard(
            planType: 'customRange',
            title: "Gói tùy chọn",
            description:
            "- Bạn chọn khoảng thời gian, mục tiêu và tần suất gửi tiền (ngày hoặc tuần).\n"
                "- Ứng dụng sẽ tính toán số tiền cần gửi mỗi khoảng thời gian.",
          ),
          _buildWarning(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _selectedPlan == null ? null : ()async{
                if(_selectedPlan == 'customRange'){
                  final result = await ShowCustomPlanDialog.showCustomPlanDialog(context);
                  if(result != null){;
                    print("Người dùng đã chọn: $result");
                    final DateTime start = result['startDate'];
                    final DateTime end = result['endDate'];
                    final String freq = result['frequency'];
                    final double goal = result['goal'];
                    final double perPeriod = result['perPeriod'];

                    PlanModel plan = PlanModel(_selectedPlan!, start, end, freq, goal, perPeriod);
                    final rs = await _showDialogCommit(context);
                    if(rs){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('bạn đã chọn gói: $_selectedPlan')));
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
                        10000
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('bạn đã chọn gói: $_selectedPlan')));
                  }
                }
              },
              child: const Text('Xác nhận'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({required String planType, required String title, required String description,})
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
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(description, style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
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
