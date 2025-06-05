import '../core/db_constants.dart';

class CategoryModel{
  String name;
  String? icon;
  String? color;
  String? note;

  CategoryModel({required this.name, this.icon, this.color, this.note});

  Map<String, dynamic> toMap() => {
    DBConstants.columnName : name,
    DBConstants.columnIcon: icon,
    DBConstants.columnColor: color,
    DBConstants.columnNote: note
  };

  factory CategoryModel.fromMap(Map<String, dynamic> category){
    return CategoryModel(
        name: category[DBConstants.columnName] as String,
        icon: category[DBConstants.columnIcon] as String,
        color: category[DBConstants.columnColor] as String,
        note: category[DBConstants.columnNote] as String,
    );
  }
}