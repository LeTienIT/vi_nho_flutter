enum FilterField { month, amount, date, category, note }
enum FilterOperator { greaterThan, lessThan, equal, contains }

class FilterCondition{
  final FilterField field;
  final FilterOperator operator;
  final dynamic value;

  FilterCondition({required this.field, required this.operator, required this.value});
}