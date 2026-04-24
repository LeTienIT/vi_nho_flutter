import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/categoryModel.dart';
import '../../viewmodels/categoryVM.dart';

class CategoryPicker extends StatelessWidget {
  final bool enable;
  final EdgeInsetsGeometry padding;
  const CategoryPicker({super.key, this.enable = true, this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8)});

  @override
  Widget build(BuildContext context) {
    final categoryVM = context.watch<CategoryVM>();

    return Padding(
      padding: padding,
      child: DropdownSearch<CategoryModel>(
        enabled: enable,
        items: categoryVM.categoryList,
        selectedItem: categoryVM.categorySelect,
        itemAsString: (c) => c.name,

        onChanged: (value) {
          if (value != null) {
            categoryVM.setSelect(value);
          }
        },

        validator: (value) =>
        value == null ? 'Vui lòng chọn danh mục' : null,

        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: 'Danh mục',
            hintText: 'Chọn danh mục',
            isDense: true, // 🔥 giảm chiều cao
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        /// 🔥 POPUP INLINE (KHÔNG PHẢI SHEET)
        popupProps: PopupProps.menu(
          showSearchBox: true,

          // 🔥 giới hạn chiều cao (rất quan trọng)
          constraints: const BoxConstraints(maxHeight: 250),

          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Tìm...',
              prefixIcon: const Icon(Icons.search, size: 18),
              isDense: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          itemBuilder: (context, item, isSelected) {
            return Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.08)
                  : null,
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          },
        ),

        dropdownButtonProps: const DropdownButtonProps(
          icon: Icon(Icons.keyboard_arrow_down, size: 20),
        ),
      ),
    );
  }
}