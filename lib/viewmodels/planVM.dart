import 'package:flutter/cupertino.dart';
import 'package:vi_nho/models/planModel.dart';
import 'package:vi_nho/services/database.dart';

class PlanVM extends ChangeNotifier{
  bool isLoad = false;
  final _db = DatabaseService();
  final List<PlanModel> _listPlan = [];

  List<PlanModel> get list => _listPlan;

  Future<void> initData() async{
    final data = await _db.selectAllPlan();
    final transactionList = await _db.selectAllTransaction();
    final now = DateTime.now();
    final expiredPlans = data.where((plan) => plan.hoanThanh == 0 && plan.ngayKT.isBefore(DateTime(now.year, now.month, now.day)));
    for (var plan in expiredPlans) {
      plan.hoanThanh = 1;
      double tong = 0;
      for (var t in transactionList) {
        if(t.savingID == plan.id){
          tong+=t.amount;
        }
      }
      if(tong >= plan.tongSoTien){
        plan.thanhCong = 1;
      }
      await _db.updateP(plan, plan.id!);
    }

    _listPlan.addAll(data);
    isLoad = true;
    notifyListeners();
  }


  Future<int> insert(PlanModel p) async{
    int id = await _db.insertP(p);
    p.id = id;
    _listPlan.insert(0, p);
    notifyListeners();
    return id;
  }

  Future<int> delete(int p) async{
    int id = await _db.deleteP(p);
    _listPlan.removeWhere((t) => t.id == p);
    notifyListeners();
    return id;
  }

  int soLuongHoanThanh(){
    return _listPlan.where((p) => p.hoanThanh == 1).length;
  }

  PlanModel getP(int id){
    return _listPlan.firstWhere((p) => p.id == id);
  }
  ///Trả ra kết quả {'rs': giá trị, 'id': giá trị}
  ///
  ///rs = -1 -> id = -1 => Lỗi, có nhiều hơn 1 gói đang mở
  ///
  ///rs = 1 -> id = -1 / id của plan được tìm thấy
  ///
  ///rs = 1 -> id = -1 => Hiện tại không có kế hoạch nào đang mở
  Map<String,int> checkOpenPlan(){
    final openPlans = _listPlan.where((p) => p.hoanThanh == 0).toList();
    if (openPlans.length > 1) {
      return {'rs': -1, 'id': -1};
    } else if (openPlans.length == 1) {
      return {'rs': 1, 'id': openPlans.first.id ?? -1};
    } else {
      return {'rs': 0, 'id': -1};
    }
  }
}