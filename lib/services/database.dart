import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:vi_nho/core/db_constants.dart';
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
        ${DBConstants.columnDateTime} TEXT
        )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async{
    if(oldVersion < newVersion){
      // Thêm code khi muốn cập nhật
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

  Future<List<TransactionModel>> selectAll() async{
    final rs = await (await db).query(DBConstants.tableTransaction, orderBy: 'id DESC');
    return rs.map( (t) => TransactionModel.fromMap(t) ).toList();
  }
}