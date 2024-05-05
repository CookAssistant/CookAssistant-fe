import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest),
        cursorColor: AppColors.highlightDark,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.headingH5.copyWith(color: AppColors.neutralDarkDark), // Updated label style
          hintText: hint,
          hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkLightest),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.neutralDarkLightest),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.highlightDark),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
