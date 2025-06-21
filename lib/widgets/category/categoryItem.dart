
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vi_nho/models/categoryModel.dart';

class CategoryItem extends StatelessWidget{
  final CategoryModel item;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDetailPressed;

  const CategoryItem({
    super.key,
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.onDetailPressed
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? Colors.greenAccent : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
                child: ListTile(
                  leading: (item.icon != null && item.icon!.isNotEmpty) ?
                  CircleAvatar(backgroundImage: FileImage(File(item.icon!)), radius: 20,) :
                  CircleAvatar(radius: 20, child: Icon(Icons.category),),
                  title: Text(item.name),
            )),
            if (isActive)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: onDetailPressed,
                ),
              ),
          ],
        ),
      ),
    );
  }

}