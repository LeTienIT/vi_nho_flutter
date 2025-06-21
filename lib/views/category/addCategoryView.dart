import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/core/input_validators.dart';
import 'package:vi_nho/models/categoryModel.dart';
import 'package:vi_nho/viewmodels/categoryVM.dart';
import 'package:vi_nho/widgets/category/categoryIconInput.dart';

import '../../widgets/sessionTitle.dart';
import '../../widgets/textForm.dart';

class AddCategoryView extends StatelessWidget{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();

  AddCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryVM vm = context.watch<CategoryVM>();
    String? iconPath = '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm loại giao dịch'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: vm.isInserting,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SessionTitle(title: 'Tên',subtitle: 'không được trùng',required: true,),
                        TextForm(category: _name, title: 'Loại giao dịch', hint: 'VD: Mua sắm', validator: InputValidators.notEmpty),

                        SessionTitle(title: 'Icon',subtitle: 'Icon hiển thị - không bắt buộc',),
                        IconInput(
                          initialIconPath: '',
                          onIconPicked: (path) {
                            if(path!=null){
                              iconPath = path;
                            }
                          },
                        ),
                        Divider(thickness: 1,),
                        FilledButton(
                            onPressed: () async {
                              if(_formKey.currentState!.validate()){
                                CategoryModel c = CategoryModel(name: _name.text, icon: iconPath);
                                await vm.insertCategory(c);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Đã thêm danh mục')),
                                );
                              }
                            },
                            child: Text('Thêm mới')
                        )
                      ],
                    )
                )
            )
          ),
          if (vm.isInserting)
            const Center(child: CircularProgressIndicator()),
        ],
      )

    );
  }

}