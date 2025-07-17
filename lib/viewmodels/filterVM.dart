import 'package:flutter/material.dart';
import '../models/filterModel.dart';

class FilterVM extends ChangeNotifier {
  FilterField? selectedField;
  FilterOperator? selectedOperator;
  dynamic inputValue;

  void setField(FilterField? field) {
    selectedField = field;
    selectedOperator = null;
    inputValue = null;
    notifyListeners();
  }

  void setOperator(FilterOperator? operator) {
    selectedOperator = operator;
    notifyListeners();
  }

  void setInputValue(dynamic value) {
    inputValue = value;
    notifyListeners();
  }

  void clear() {
    selectedField = null;
    selectedOperator = null;
    inputValue = null;
    notifyListeners();
  }

  FilterCondition? buildCondition() {
    if(selectedField == FilterField.month)selectedOperator=FilterOperator.equal;
    if (selectedField != null && selectedOperator != null && inputValue != null) {
      return FilterCondition(
        field: selectedField!,
        operator: selectedOperator!,
        value: inputValue!,
      );
    }
    return null;
  }
}
