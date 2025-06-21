import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:vi_nho/models/categoryModel.dart';
import 'package:vi_nho/services/database.dart';
import 'package:vi_nho/services/imageService.dart';

class CategoryVM extends ChangeNotifier{
  bool _isInserting = false;
  bool get isInserting => _isInserting;
  bool isLoad = false;
  final _db = DatabaseService();
  final List<CategoryModel> _categoryList = [];
  CategoryModel? categorySelect;
  String? _activeItemId;

  final ImageService _imageService = ImageService();

  List<CategoryModel> get categoryList => _categoryList;

  void setSelect(CategoryModel c){
    categorySelect = c;
    notifyListeners();
  }
  void clearSelect(){
    categorySelect = null;
    notifyListeners();
  }

  void setActiveItem(String? id) {
    _activeItemId = id;
    notifyListeners();
  }

  bool isActive(String id) {
    return _activeItemId == id;
  }

  Future<void> initData() async{
    final data = await _db.selectAllCategory();
    _categoryList.addAll(data);
    CategoryModel c = CategoryModel(name: 'Khác');
    _categoryList.add(c);
    isLoad = true;
    notifyListeners();
  }

  Future<void> insertCategory(CategoryModel t) async {
    _isInserting = true;
    notifyListeners();

    if (t.icon?.isNotEmpty == true) {
      final original = File(t.icon!);
      final saved = await _imageService.compressAndSaveIcon(original);
      if (saved != null) {
        t = t.copyWith(icon: saved.path);
      }
    }
    await _db.insertC(t);
    _categoryList.add(t);

    _isInserting = false;
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
    notifyListeners();
  }

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