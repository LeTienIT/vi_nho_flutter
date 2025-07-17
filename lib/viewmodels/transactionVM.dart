import 'package:flutter/material.dart';
import 'package:vi_nho/core/tool.dart';
import 'package:vi_nho/models/filterModel.dart';
import 'package:vi_nho/models/planModel.dart';
import 'package:vi_nho/models/transactionModel.dart';
import 'package:vi_nho/services/database.dart';
class TransactionVM extends ChangeNotifier{
  bool isLoad = false;
  final _db = DatabaseService();
  int? _activeItemId;
  FilterCondition? _filterCondition;

  final List<TransactionModel> _transactionList = [];
  List<TransactionModel> _transactionFilter = [];

  List<TransactionModel> get listCore => _transactionList;
  List<TransactionModel> get transactionList => _transactionFilter;

  void setActiveItem(int? id) {
    _activeItemId = id;
    notifyListeners();
  }

  bool isActive(int id) {
    return _activeItemId == id;
  }

  Future<void> initData() async{
    final data = await _db.selectAllTransaction();
    _transactionList.addAll(data);
    _transactionFilter = List.from(_transactionList);
    isLoad = true;
    notifyListeners();
  }

  Future<void> insertTransaction(TransactionModel t) async{
    final id = await _db.insert(t);
    t.id = id;
    _transactionList.insert(0,t);
    if(_filterCondition == null){
      _transactionFilter = List.from(_transactionList);
      notifyListeners();
    }
    else{
      _filterTransaction();
    }
  }

  Future<void> updateTransaction(TransactionModel t, int id) async{
    await _db.update(t, id);

    int indexPrivate =_transactionList.indexWhere((t) => t.id == id) as int;
    if(indexPrivate != -1){
      _transactionList[indexPrivate] = t;
      if(_filterCondition == null){
        _transactionFilter = List.from(_transactionList);
        notifyListeners();
      }
      else{
        _filterTransaction();
      }
    }
  }

  Future<void> deleteTransaction(int id) async{
    await _db.delete(id);
    _transactionList.removeWhere((t) => t.id == id);
    if(_filterCondition == null){
      _transactionFilter = List.from(_transactionList);
      notifyListeners();
    }
    else{
      _filterTransaction();
    }
  }

  void _filterTransaction(){
    if(_filterCondition == null){
      _transactionFilter = List.from(_transactionList);
      notifyListeners();
      return;
    }

    final condition = _filterCondition!;
    _transactionFilter = _transactionList.where((e){
      switch(condition.field){
        case FilterField.month:
          final date = e.dateTime;
          final filterValue = condition.value as int;
          return date.month == filterValue && date.year == DateTime.now().year;
        case FilterField.amount:
          final amount = e.amount;
          final filterValue = condition.value as double;
          switch (condition.operator) {
            case FilterOperator.greaterThan:
              return amount > filterValue;
            case FilterOperator.lessThan:
              return amount < filterValue;
            case FilterOperator.equal:
              return amount == filterValue;
            default:
              return true;
          }
        case FilterField.date:
          final date = e.dateTime;
          final filterValue = condition.value as DateTime;
          return date.year == filterValue.year &&
              date.month == filterValue.month &&
              date.day == filterValue.day;

        case FilterField.category:
          final cat = e.category.toLowerCase();
          final val = (condition.value as String).toLowerCase();
          return cat.contains(val);

        case FilterField.note:
          if(e.note != null){
            final note = e.note!.toLowerCase();
            final val = (condition.value as String).toLowerCase();
            return note.contains(val);
          }
          else {
            return false;
          }
      }
    }).toList();

    notifyListeners();
  }

  void applyFilter(FilterCondition? condition){
    _filterCondition = condition;
    _filterTransaction();
  }

  void clearFilter(){
    _filterCondition = null;
    _filterTransaction();
  }

  void deleteSavingID(int id){
    _transactionList.removeWhere((t)=>t.savingID == id);
    if(_filterCondition == null){
      _transactionFilter = List.from(_transactionList);
      notifyListeners();
    }
    else{
      _filterTransaction();
    }
  }

  /// Dashboard cho kế hoạch tiết kiệm
  /// ===========================
  /// Trả về{
  ///   'ten': Tên kế hoạch tiết kiệm,
  ///   'tongDaNop': Tổng tiền đã nộp vào kế hoạch,
  ///   'daHoanThanh': Phần trăm đã hoàn thành của kế hoạch,
  ///   'tongChuKy': Tổng số chu kỳ cần nộp,
  ///   'danhSachNgayCanNop': Danh sách các ngày cần nộp theo chu kỳ,
  ///   'danhSachNgayNopThieu': Ngày và số tiền còn thiếu trong mỗi ngày,
  ///   'tongDu': Tổng số tiền đã nộp dư,
  ///   'tongNo': Tổng số tiền còn thiếu,
  ///   'ngayNopTiepTheo': Ngày sắp tới cần nộp tiếp,
  ///   'danhGia': Câu đánh giá về
  /// }
  Map<String, dynamic > getSavingPlan(PlanModel plan){
    final savedTransactions = _transactionList.where(
            (t) => t.savingID == plan.id!
    ).toList();
    double tatolSaved = 0;
    for (var t in savedTransactions) {
      tatolSaved+=t.amount;
      // print("saved: $tatolSaved - ${t.category} - ${t.amount} - ${t.type}");
    }
    List<DateTime> dates = Tool.getDaysInPeriodOfTime(plan.ngayBD, plan.ngayKT, plan.chuKy);
    DateTime now = DateTime.now();
    int tongChuKy = dates.length;
    double tongNo = 0;
    double tongDu = 0;
    double soTienNopTiepTheo = plan.tienMoiKy;
    Map<DateTime,double> soNgayThieu = {};
    DateTime? ngayNopTiepTheo;
    String ten = 'Kế hoạch tiết kiệm tùy chọn';
    String danhgia;
    for(DateTime d in dates){
      if(d.isAfter(now)){
        ngayNopTiepTheo = d;
        break;
      }

      final listSavedByD = savedTransactions.where((t) => t.dateTime.year == d.year && t.dateTime.month == d.month && t.dateTime.day == d.day).toList();
      if(listSavedByD.isNotEmpty){
        double tatoal = 0;
        for (var t in listSavedByD) {
          tatoal += t.amount;
        }
        double requiredAmount = 0;
        if(plan.tenKeHoach == 'fixedUntilLunarNewYear'){
          int tuanHienTai = Tool.getWeekOfYear(d);
          requiredAmount = tuanHienTai * 10000;
        }
        else
        {
            requiredAmount = plan.tienMoiKy;
        }

        if(tatoal > requiredAmount){
          tongDu += tatoal - requiredAmount;
        }
        else if(tatoal < requiredAmount){
          tongNo += requiredAmount - tatoal;
          soNgayThieu[d] = requiredAmount - tatoal;
        }
      }
      else{
        tongNo += plan.tienMoiKy;
        soNgayThieu[d] = plan.tienMoiKy;
      }
    }
    if(tongDu >= tongNo){
      soNgayThieu.clear();
      danhgia = '🎉 Tuyệt vời! Bạn đang hoàn thành kế hoạch tiết kiệm rất tốt!\n';
      if(tongDu > tongNo){
        danhgia += '🌟 Không chỉ đúng tiến độ, bạn còn vượt chỉ tiêu với số tiền nộp dư — một nỗ lực xuất sắc!\n';
      }
      danhgia += '🔥 Hãy tiếp tục duy trì phong độ này và về đích thành công nhé!\n💪 CHÚC BẠN THÀNH CÔNG!';
      if(plan.ngayKT.year == now.year && plan.ngayKT.month==now.month&&plan.ngayKT.day==now.day){
        danhgia = '🎉 TUYỆT VỜI. CHÚC MỪNG BẠN ĐÃ HOÀN THÀNH KẾ HOẠCH TIẾT KIỆM LẦN NÀY.\n. '
            '🌟 BẠN RẤT XUẤT SẮC, RẤT KIÊN TRÌ, HÃY TẬN HƯỞNG THÀNH QUẢ.\n '
            '🔥 À ĐỪNG QUÊN QUAY LẠI VÀO NGÀY MAI KHI BẠN CÓ KẾ HOẠCH MỚI.';
      }
    }
    else{
      danhgia = '''
        ⚠️ Kế hoạch tiết kiệm của bạn đang bị **chậm tiến độ**.\n
        📌 Hãy kiểm tra lịch phía dưới: các ngày bị **thiếu/hoặc chưa nộp** được đánh dấu ❌ (màu đỏ).\n
        💡 Đừng lo! Bạn vẫn còn thời gian để điều chỉnh và hoàn thành đúng hạn.\n
        ⏳ Hãy bắt đầu nộp bổ sung ngay hôm nay nhé!\n
        🎯 Chúc bạn sớm hoàn thành mục tiêu! 🚀
       ''';
      final List<DateTime> keysToRemove = [];

      for (var entry in soNgayThieu.entries) {
        final no = entry.value;
        if (tongDu - no >= 0) {
          tongDu -= no;
          keysToRemove.add(entry.key); // gom lại
        }
      }
      for (var key in keysToRemove) {
        soNgayThieu.remove(key);
      }
      if(plan.ngayKT.year == now.year && plan.ngayKT.month==now.month&&plan.ngayKT.day==now.day){
        danhgia = '⚠️ HEY! HÔM NAY LÀ NGÀY CUỐI CÙNG CỦA KẾ HOẠCH TIẾT KIỆM NÀY RÙI.\n'
            '⏳ BẠN NÊN HOÀN THÀNH NÓ THÔI. HIỆN TẠI NÓ VẪN CHƯA ĐƯỢC HOÀN THÀNH.\n'
            '🔥 HÃY KẾT THÚC QUÁ TRÌNH NÀY VÀ TẬN HƯỞNG THÀNH QUẢ THÔI.\n'
            '🎯 À ĐỪNG QUÊN QUAY LẠI VÀO NGÀY MAI KHI BẠN CÓ KẾ HOẠCH MỚI.';
      }
    }
    if(plan.tenKeHoach == 'fixedUntilLunarNewYear'){
      ten = 'Kế hoạch tiết kiệm TẾT: ${DateTime.now().year+1}';
      ngayNopTiepTheo ??= dates.last;
      int tuan = Tool.getWeekOfYear(ngayNopTiepTheo);
      soTienNopTiepTheo = 10000.0 * tuan;
    }
    if(ngayNopTiepTheo==null){
      ngayNopTiepTheo = dates.last;
      soTienNopTiepTheo = plan.tienMoiKy;
    }

    return {
      'ten': ten,
      'tongDaNop': tatolSaved,
      'daHoanThanh': tatolSaved / plan.tongSoTien,
      'tongChuKy': tongChuKy,
      'danhSachNgayCanNop': dates,
      'danhSachNgayNopThieu': soNgayThieu,
      'tongDu': tongDu,
      'tongNo': tongNo,
      'ngayNopTiepTheo': ngayNopTiepTheo,
      'soTienNopTiepTheo': soTienNopTiepTheo,
      'danhGia': danhgia
    };
  }

}