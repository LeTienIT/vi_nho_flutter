import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:vi_nho/core/db_constants.dart';
import 'package:vi_nho/models/categoryModel.dart';
import 'package:vi_nho/models/planModel.dart';
import 'package:vi_nho/models/transactionModel.dart';
class DatabaseService{
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _db;

  DatabaseService._internal();

  // Cái này dùng để khởi tạo khi sử dụng, sau khi khởi tạo thì mới truy cập biến GET DB ở dưới được
  // Nếu không khởi tạo thì không thể truy cập GET DB do hàm tạo là private rùi => KHÔNG THỂ KHỞI TẠO CLASS Ở BÊN NGOÀI
  factory DatabaseService() => _instance;

  Future<Database> get db async => _db ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path,DBConstants.dbName);

    return openDatabase(
        path,
        version: DBConstants.dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade
    );
  }

  Future<void> _onCreate(Database db, int v) async{
    await db.execute('''
      CREATE TABLE ${DBConstants.tableTransaction} (
        ${DBConstants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBConstants.columnType} TEXT,
        ${DBConstants.columnAmount} REAL,
        ${DBConstants.columnCategory} TEXT,
        ${DBConstants.columnNote} TEXT,
        ${DBConstants.columnDateTime} TEXT,
        FOREIGN KEY(${DBConstants.columnCategory}) REFERENCES ${DBConstants.tableCategory}(name)
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DBConstants.tableCategory} (
        ${DBConstants.columnName} TEXT PRIMARY KEY,
        ${DBConstants.columnIcon} TEXT,
        ${DBConstants.columnColor} TEXT,
        ${DBConstants.columnNote} TEXT
      )
    ''');

    // Thêm dữ liệu mẫu
    await db.insert(DBConstants.tableCategory, {DBConstants.columnName: 'Ăn uống'});
    await db.insert(DBConstants.tableCategory, {DBConstants.columnName: 'Giải trí'});
    await db.insert(DBConstants.tableCategory, {DBConstants.columnName: 'Lương'});
    await db.insert(DBConstants.tableCategory, {DBConstants.columnName: 'Hóa đơn'});
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if(oldVersion < newVersion){
      await db.execute('''
      CREATE TABLE IF NOT EXISTS ${DBConstants.tableSaving} (
        ${DBConstants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBConstants.columnNamePlan} TEXT,
        ${DBConstants.columnStartDate} TEXT,
        ${DBConstants.columnEndDate} TEXT,
        ${DBConstants.columnChuKy} TEXT,
        ${DBConstants.columnTongTien} TEXT,
        ${DBConstants.columnTienChuKy} TEXT,
        ${DBConstants.columnHoanThanh} INTEGER
      )
    ''');

    //   await db.execute('''
    //   ALTER TABLE ${DBConstants.tableTransaction}
    //   ADD COLUMN ${DBConstants.columnSavingId} INTEGER DEFAULT -1
    // ''');

      await db.execute('''
      ALTER TABLE ${DBConstants.tableSaving}
      ADD COLUMN ${DBConstants.columnThanhCong} INTEGER DEFAULT -1
    ''');
    }
  }

  Future<int> insert(TransactionModel t) async{
    return (await db).insert(DBConstants.tableTransaction, t.toMap());
  }

  Future<int> update(TransactionModel t, int id) async{
    return (await db).update(DBConstants.tableTransaction, t.toMap(),where: 'id = ?',whereArgs: [id]);
  }

  Future<int> delete(int id) async{
    return (await db).delete(DBConstants.tableTransaction,where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TransactionModel>> selectAllTransaction() async{
    final rs = await (await db).query(DBConstants.tableTransaction, orderBy: 'id DESC');
    return rs.map( (t) => TransactionModel.fromMap(t) ).toList();
  }

  Future<List<CategoryModel>> selectAllCategory() async{
    final rs = await (await db).query(DBConstants.tableCategory);
    return rs.map( (t) => CategoryModel.fromMap(t) ).toList();
  }

  Future<int> insertC(CategoryModel t) async{
    return (await db).insert(DBConstants.tableCategory, t.toMap());
  }

  Future<int> updateC(CategoryModel t, String name) async{
    return (await db).update(DBConstants.tableCategory, t.toMap(),where: 'name = ?',whereArgs: [name]);
  }

  Future<int> countTransactionsWithCategory(String categoryName) async {
    final dbClient = await db;
    final result = await dbClient.rawQuery(
      'SELECT COUNT(*) as count FROM ${DBConstants.tableTransaction} WHERE ${DBConstants.columnCategory} = ?',
      [categoryName],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> deleteC(String name) async{
    return (await db).delete(DBConstants.tableCategory,where: 'name = ?', whereArgs: [name]);
  }

  Future<List<PlanModel>> selectAllPlan() async{
    final rs = await (await db).query(DBConstants.tableSaving);
    return rs.map( (t) => PlanModel.fromMap(t) ).toList();
  }

  Future<int> insertP(PlanModel t) async{
    return (await db).insert(DBConstants.tableSaving, t.toMap());
  }

  Future<int> updateP(PlanModel t, int id) async{
    return (await db).update(DBConstants.tableSaving, t.toMap(),where: 'id = ?',whereArgs: [id]);
  }

  Future<int> deleteP(int id) async{
    (await db).delete(DBConstants.tableTransaction,where: '${DBConstants.columnSavingId} = ?', whereArgs: [id]);
    return (await db).delete(DBConstants.tableSaving,where: '${DBConstants.columnId} = ?', whereArgs: [id]);
  }
}