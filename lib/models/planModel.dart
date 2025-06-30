class PlanModel{
  late int? id;
  late String tenKeHoach;
  late DateTime ngayBD;
  late DateTime ngayKT;
  late String chuKy;
  late double tongSoTien;
  late double tienMoiKy;
  late int hoanThanh;

  PlanModel(this.tenKeHoach, this.ngayBD, this.ngayKT, this.chuKy, this.tongSoTien, this.tienMoiKy, {this.id, this.hoanThanh = 0});

}