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

  DateTime? startDate;
  DateTime? endDate;
  int? year;
  int? month;
  int? day;
  int? week;
  String? categoryFilter;

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
      filterTransaction();
    }
  }

  Future<void> updateTransaction(TransactionModel t, int id) async{
    await _db.update(t, id);

    int indexPrivate =_transactionList.indexWhere((t) => t.id == id);
    if(indexPrivate != -1){
      _transactionList[indexPrivate] = t;
      if(_filterCondition == null){
        _transactionFilter = List.from(_transactionList);
        notifyListeners();
      }
      else{
        filterTransaction();
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
      filterTransaction();
    }
  }

  void filterTransaction() {
    final now = DateTime.now();

    _transactionFilter = _transactionList.where((e) {
      final date = e.dateTime;

      if (startDate != null && endDate != null) {
        final start = DateTime(startDate!.year, startDate!.month, startDate!.day);
        final end = DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59, 999,);

        return !date.isBefore(start) && !date.isAfter(end);
      }

      if (year != null || month != null || day != null) {
        final y = year;
        final m = month;
        final d = day;

        if (y != null && date.year != y) return false;

        if (m != null) {
          final usedYear = y ?? now.year;
          if (date.year != usedYear || date.month != m) return false;
        }

        if (d != null) {
          final usedYear = y ?? now.year;
          final usedMonth = m ?? now.month;

          if (date.year != usedYear || date.month != usedMonth || date.day != d) return false;
        }
      }

      else if (week != null) {
        if (_weekOfMonth(date) != week) return false;
      }

      return true;
    }).toList();

    if(categoryFilter!=null){
      _transactionFilter = _transactionList.where((e) {
        return e.category == categoryFilter;
      }).toList();
    }
    notifyListeners();
  }
  int _weekOfMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final offset = firstDay.weekday - 1;
    return ((date.day + offset) / 7).ceil();
  }

  void clearFilter(){
    startDate=null;
    endDate=null;
    year=null;
    month=null;
    day=null;
    week=null;
    categoryFilter=null;
    filterTransaction();
  }

  void setDateRange(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;

    year = null;
    month = null;
    day = null;
    week = null;

    notifyListeners();
  }

  void setYear(int value) {
    year = value;

    startDate = null;
    endDate = null;
    week = null;

    notifyListeners();
  }

  void setMonth(int value) {
    month = value;

    year ??= DateTime.now().year;

    startDate = null;
    endDate = null;
    week = null;

    notifyListeners();
  }

  void setDay(int value) {
    day = value;

    final now = DateTime.now();
    year ??= now.year;
    month ??= now.month;

    startDate = null;
    endDate = null;
    week = null;

    notifyListeners();
  }
  void setWeek(int value) {
    week = value;

    startDate = null;
    endDate = null;
    year = null;
    month = null;
    day = null;

    notifyListeners();
  }

  void setCategoryFilter(String? value){
    categoryFilter = value;
    notifyListeners();
  }
  void deleteSavingID(int id){
    _transactionList.removeWhere((t)=>t.savingID == id);
    if(_filterCondition == null){
      _transactionFilter = List.from(_transactionList);
      notifyListeners();
    }
    else{
      filterTransaction();
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
    double tatolSaved = 0, soDaNop = 0;
    for (var t in savedTransactions) {
      tatolSaved+=t.amount;
      soDaNop+=t.amount;
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
          tatolSaved -= t.amount;
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

        if(tatoal >= requiredAmount){
          tongDu += tatoal - requiredAmount;
        }
        else {
          tongNo += requiredAmount - tatoal;
          soNgayThieu[d] = requiredAmount - tatoal;
        }
      }
      else{
        double requiredAmount = 0;
        if(plan.tenKeHoach == 'fixedUntilLunarNewYear'){
          int tuanHienTai = Tool.getWeekOfYear(d);
          requiredAmount = tuanHienTai * 10000;
        }
        else
        {
          requiredAmount = plan.tienMoiKy;
        }
        tongNo += requiredAmount;
        soNgayThieu[d] = requiredAmount;
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
        ⏳ Hãy bắt đầu nộp bổ sung ${tongNo - tongDu} ngay hôm nay nhé!\n
        🎯 Chúc bạn sớm hoàn thành mục tiêu! 🚀
       ''';
      final List<DateTime> keysToRemove = [];

      for (var entry in soNgayThieu.entries.toList()..sort((a,b) => a.key.compareTo(b.key))) {
        final no = entry.value;
        if (tatolSaved - no >= 0) {
          tatolSaved -= no;
          keysToRemove.add(entry.key); // gom lại
        }
      }
      for (var key in keysToRemove) {
        soNgayThieu.remove(key);
      }
      if(soNgayThieu.isEmpty){
        danhgia = '🎉 Tuyệt vời! Bạn đang hoàn thành kế hoạch tiết kiệm rất tốt!\n';
        if(tatolSaved > 0){
          danhgia += '🌟 Không chỉ đúng tiến độ, bạn còn vượt chỉ tiêu với số tiền nộp dư: $tatolSaved — một nỗ lực xuất sắc!\n'
              '🤣 HAY LÀ BẠN NỘP TRƯỚC CHO CÁC KỲ TIẾP THEO.\n'
              '🤣😂 Hì, không quan trọng, dù sao:\n'
              '👍👑😉 BẠN ĐANG LÀM RẤT TỐT KẾ HOẠCH CỦA MÌNH!\n';
        }
        danhgia += '🔥 Hãy tiếp tục duy trì phong độ này và về đích thành công nhé!\n💪 CHÚC BẠN THÀNH CÔNG!';
        if(plan.ngayKT.year == now.year && plan.ngayKT.month==now.month&&plan.ngayKT.day==now.day){
          danhgia = '🎉 TUYỆT VỜI. CHÚC MỪNG BẠN ĐÃ HOÀN THÀNH KẾ HOẠCH TIẾT KIỆM LẦN NÀY.\n. '
              '🌟 BẠN RẤT XUẤT SẮC, RẤT KIÊN TRÌ, HÃY TẬN HƯỞNG THÀNH QUẢ.\n '
              '🔥 À ĐỪNG QUÊN QUAY LẠI VÀO NGÀY MAI KHI BẠN CÓ KẾ HOẠCH MỚI.';
        }
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
      'tongDaNop': soDaNop,
      'daHoanThanh': soDaNop / plan.tongSoTien,
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