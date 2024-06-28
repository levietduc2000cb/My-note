import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  const InputForm(
      {super.key,
      required this.keyboardType,
      required this.controller,
      this.textInputAction,
      required this.labelText,
      this.validator,
      this.obscureText,
      this.decoration,
      this.suffixIcon});

  final TextInputType keyboardType;
  final bool? obscureText;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final String? labelText;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: TextFormField(
        autofocus: false,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        controller: controller,
        textInputAction: textInputAction,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Colors.white70, // Màu labelText khi không focus
            ),
            contentPadding: EdgeInsets.zero,
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white, // Màu border bottom khi focus
                width: 1,
              ),
            )),
        style: const TextStyle(
          color: Colors.white, // Màu chữ
        ),
        validator: validator,
      ),
    );
  }
}
