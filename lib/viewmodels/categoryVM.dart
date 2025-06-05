import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vi_nho/models/categoryModel.dart';
import 'package:vi_nho/services/database.dart';

class CategoryVM extends ChangeNotifier{
  bool isLoad = false;
  final _db = DatabaseService();
  final List<CategoryModel> _categoryList = [];

  List<CategoryModel> get categoryList => _categoryList;

  Future<void> initData() async{
    final data = await _db.selectAllCategory();
    _categoryList.addAll(data);
    isLoad = true;
  }

  Future<void> insertCategory(CategoryModel t) async{
    await _db.insertC(t);
    _categoryList.add(t);
    notifyListeners();
  }

  Future<void> updateCategory(CategoryModel t, String id) async{
    await _db.updateC(t, id);

    int indexPrivate =_categoryList.indexWhere((t) => t.name == id) as int;
    if(indexPrivate != -1){
      _categoryList[indexPrivate] = t;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String id) async{
    await _db.deleteC(id);
    _categoryList.removeWhere((t) => t.name == id);
    notifyListeners();  }
}