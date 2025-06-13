import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/models/categoryModel.dart';
import 'package:vi_nho/viewmodels/categoryVM.dart';

class CategoryPicker extends StatelessWidget{
  const CategoryPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryVM = context.watch<CategoryVM>();
    // print(categoryVM.categorySelect == null ? 'null' : categoryVM.categorySelect!.name);
    return Padding(
        padding: EdgeInsets.only(top: 16, right: 16, left: 5),
        child:  DropdownButtonFormField<CategoryModel>(
          value: categoryVM.categorySelect,
          decoration: InputDecoration(
              labelText: 'Chọn danh mục',
              border: OutlineInputBorder()
          ),
          items: categoryVM.categoryList.map((c){
            return DropdownMenuItem<CategoryModel>(
                value: c,
                child: Text(c.name)
            );
          }).toList(),
          onChanged: (value){
            if(value != null) {
              categoryVM.setSelect(value);
            }
          },
          validator: (value) {
            if (value == null) {
              return 'Vui lòng chọn danh mục';
            }
            return null;
          },
        ),
    );
  }
}