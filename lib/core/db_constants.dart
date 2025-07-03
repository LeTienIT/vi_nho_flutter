class DBConstants{
  static const String dbName = 'database_chinote.db';
  static const int dbVersion = 6;

  static const String tableTransaction = 'transactions';
  static const String tableCategory = "category";
  static const String tableSaving = "saving";

  static const String columnId = 'id';
  static const String columnType = 'type';
  static const String columnAmount = 'amount';
  static const String columnCategory = 'categoryName';
  static const String columnNote = 'note';
  static const String columnDateTime = 'dateTime';
  static const String columnSavingId = 'savingID';

  static const String columnName = 'name';
  static const String columnIcon = 'icon';
  static const String columnColor = 'color';

  static const String columnNamePlan = 'tenKeHoach';
  static const String columnStartDate = 'ngayBatDau';
  static const String columnEndDate = 'ngayKetThuc';
  static const String columnChuKy = 'chuKy';
  static const String columnTongTien = 'tongSoTien';
  static const String columnTienChuKy = 'tienMoiKy';
  static const String columnHoanThanh = 'hoanThanh';
  static const String columnThanhCong = 'thanhCong';
}