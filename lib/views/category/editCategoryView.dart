import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/models/categoryModel.dart';
import 'package:vi_nho/viewmodels/categoryVM.dart';

import '../../core/input_validators.dart';
import '../../widgets/category/categoryIconInput.dart';
import '../../widgets/sessionTitle.dart';
import '../../widgets/textForm.dart';
class EditCategoryView extends StatefulWidget{
  CategoryModel categoryModel;

  EditCategoryView({super.key, required this.categoryModel});

  @override
  State<StatefulWidget> createState() {
    return _EditCategoryView();
  }

}
class _EditCategoryView extends State<EditCategoryView>{
  late final CategoryVM categoryVM;
  late final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late String? iconPath;

  @override
  @override
  void initState() {
    super.initState();
    categoryVM = context.read<CategoryVM>();
    _name = TextEditingController(text: widget.categoryModel.name);
    iconPath = widget.categoryModel.icon;
  }
  @override
  Widget build(BuildContext context) {
    final categoryVM = context.watch<CategoryVM>();
    String newPath = '';
    return Scaffold(
      appBar: AppBar(title: Text('Chỉnh sửa loại giao dịch'),),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: categoryVM.isInserting,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                  SessionTitle(title: 'Tên',subtitle: 'không được trùng',required: true,),
                  TextForm(category: _name, title: 'Loại giao dịch', hint: 'VD: Mua sắm', validator: InputValidators.notEmpty, readOnly: true,),

                  SessionTitle(title: 'Icon',subtitle: 'Icon hiển thị - không bắt buộc',),
                  IconInput(
                    initialIconPath: iconPath ?? '',
                    onIconPicked: (path) {
                      if(path!=null){
                        newPath = path;
                      }
                    },
                  ),
                  Divider(thickness: 1,),
                  FilledButton(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        final result = await categoryVM.updateCategory(widget.categoryModel, widget.categoryModel.name, newPath);
                        if(result['status']){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']),duration: Duration(seconds: 1),));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(result['message']),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ));
                        }
                      }
                    },
                    child: Text('Lưu')
                  )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

