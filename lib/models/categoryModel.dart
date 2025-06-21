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
        icon: category[DBConstants.columnIcon] ?? '',
        color: category[DBConstants.columnColor] ?? '',
        note: category[DBConstants.columnNote] ?? '',
    );
  }

  CategoryModel copyWith({String? name, String? icon}) {
    return CategoryModel(
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }
}