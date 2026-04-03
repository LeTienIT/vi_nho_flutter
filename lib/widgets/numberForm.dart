import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumberForm extends StatelessWidget {
  final TextEditingController amount;
  final String title;
  final String? hint;
  final String? Function(String?)? validator;
  final bool readOnly;

  const NumberForm({
    super.key,
    required this.amount,
    required this.title,
    this.hint,
    this.validator,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: amount,
        keyboardType: TextInputType.number,
        readOnly: readOnly,
        validator: validator,
        decoration: InputDecoration(
          labelText: title,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}