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
    _categoryList.insert(_categoryList.length - 1, t);

    _isInserting = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> updateCategory(CategoryModel t, String id, String newPath) async {
    try {
      if (newPath.trim().isNotEmpty) {
        if (t.icon != null && t.icon!.trim().isNotEmpty) {
          await _imageService.deleteFile(t.icon!);
        }

        final original = File(newPath);
        final saved = await _imageService.compressAndSaveIcon(original);
        if (saved == null) {
          return {'status': false, 'message': 'Lưu icon thất bại'};
        }

        t = t.copyWith(icon: saved.path);
      }

      await _db.updateC(t, id);

      final index = _categoryList.indexWhere((e) => e.name == id);
      if (index == -1) {
        return {'status': false, 'message': 'Không tìm thấy danh mục cần cập nhật'};
      }
      _categoryList[index] = t;
      notifyListeners();
      return {'status': true, 'message': 'Cập nhật thành công'};
    } catch (e) {
      return {'status': false, 'message': 'Lỗi: $e'};
    }
  }


  bool checkValueDefault(String name){
    return name == 'Khác';
  }

  Future<Map<String, dynamic>> deleteCategory(String id) async{
    final usedCount = await _db.countTransactionsWithCategory(id);
    if (usedCount > 0) {
      notifyListeners();
      return{'status': false, 'message':'Không thể xóa loại giao dịch này vì nó đang được dùng bởi 1 bản ghi trong dánh sách giao dịch'};
    }
    CategoryModel? c = findName(id);
    if(c!=null){
      if(c.icon!=null && c.icon!.isNotEmpty){
        await _imageService.deleteFile(c.icon!);
      }
      await _db.deleteC(id);
      _categoryList.removeWhere((t) => t.name == id);
      notifyListeners();
      return{'status': true, 'message':'Xóa thành công'};
    }
    return{'status': false, 'message':'Xóa thất bại'};
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