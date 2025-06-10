import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vi_nho/models/categoryModel.dart';
import 'package:vi_nho/services/database.dart';

class CategoryVM extends ChangeNotifier{
  bool isLoad = false;
  final _db = DatabaseService();
  final List<CategoryModel> _categoryList = [];
  CategoryModel? categorySelect;

  List<CategoryModel> get categoryList => _categoryList;

  void setSelect(CategoryModel c){
    categorySelect = c;
    notifyListeners();
  }
  void clearSelect(){
    categorySelect = null;
    notifyListeners();
  }

  Future<void> initData() async{
    final data = await _db.selectAllCategory();
    _categoryList.addAll(data);
    CategoryModel c = CategoryModel(name: 'Khác');
    _categoryList.add(c);
    isLoad = true;
    notifyListeners();
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

  CategoryModel? findName(String name){
    int index = _categoryList.indexWhere((c) => c.name == name);

    if(index != -1){
      return _categoryList[index];
    }
    else{
      return null;
    }
  }
}