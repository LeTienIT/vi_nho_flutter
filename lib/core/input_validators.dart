class InputValidators{
  static String? categoryValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hãy nhập giá trị';
    }
    return null;
  }

  static String? amountValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hãy nhập giá trị';
    }
    if (double.tryParse(value) == null) {
      return 'Hãy nhập đúng định dạng số tiền';
    }
    return null;
  }

  static String? notEmpty(String? value, {String message = 'Không được để trống'}) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }
}