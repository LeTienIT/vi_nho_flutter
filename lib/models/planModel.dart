import '../core/db_constants.dart';

class PlanModel{
  int? id;
  String tenKeHoach;
  DateTime ngayBD;
  DateTime ngayKT;
  String chuKy;
  double tongSoTien;
  double tienMoiKy;
  int hoanThanh;
  int thanhCong;

  PlanModel(this.tenKeHoach, this.ngayBD, this.ngayKT, this.chuKy, this.tongSoTien, this.tienMoiKy, {this.id, this.hoanThanh = 0, this.thanhCong=0});

  Map<String, dynamic> toMap() => {
    DBConstants.columnId : id,
    DBConstants.columnNamePlan: tenKeHoach,
    DBConstants.columnStartDate: ngayBD.toIso8601String().toString(),
    DBConstants.columnEndDate: ngayKT.toIso8601String().toString()  ,
    DBConstants.columnChuKy: chuKy,
    DBConstants.columnTongTien: tongSoTien,
    DBConstants.columnTienChuKy: tienMoiKy,
    DBConstants.columnHoanThanh: hoanThanh,
    DBConstants.columnThanhCong: thanhCong
  };

  factory PlanModel.fromMap(Map<String, dynamic> plan){
    return PlanModel(
        id: plan[DBConstants.columnId] as int?,
        plan[DBConstants.columnNamePlan] as String,
        DateTime.parse(plan[DBConstants.columnStartDate] as String),
        DateTime.parse(plan[DBConstants.columnEndDate] as String),
        plan[DBConstants.columnChuKy] as String,
        double.parse(plan[DBConstants.columnTongTien]),
        double.parse(plan[DBConstants.columnTienChuKy]),
        hoanThanh: plan[DBConstants.columnHoanThanh] as int,
        thanhCong: plan[DBConstants.columnThanhCong] as int
    );
  }

}