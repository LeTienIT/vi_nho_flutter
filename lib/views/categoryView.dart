import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vi_nho/widgets/category/categoryItem.dart';
import 'package:vi_nho/widgets/dashboard/menu.dart';
import '../viewmodels/categoryVM.dart';

class CategoryView extends StatelessWidget{
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryVM = context.watch<CategoryVM>();

    if(!categoryVM.isLoad){
      return CircularProgressIndicator();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Phân loại chi tiêu'
        ),
        centerTitle: true,
      ),
      drawer: Drawer(child: Menu(),),
      body: ListView.builder(
        itemCount: categoryVM.categoryList.length-1,
        itemBuilder: (context, index){
          final item = categoryVM.categoryList[index];
          return Dismissible(
              key: Key(categoryVM.categoryList[index].name),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete),
              ),
              direction: categoryVM.checkValueDefault(item.name) ? DismissDirection.none : DismissDirection.endToStart,
              confirmDismiss: (key) async {
                final result = await categoryVM.deleteCategory(categoryVM.categoryList[index].name);
                if(result['status']){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']),duration: Duration(seconds: 1),));
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(result['message']),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.red,
                  ));
                }
                return result['status'];
              },
              child: CategoryItem(
                  item: item,
                  isActive: categoryVM.isActive(item.name),
                  onTap: (){
                    categoryVM.setActiveItem(
                      categoryVM.isActive(item.name) ? null : item.name
                    );
                  },
                  onDetailPressed: (){
                    Navigator.pushNamed(context, '/category-edit',arguments: item);
                  }
              ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.pushNamed(context, '/category-add')},
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.add),
      ),
    );
  }

}