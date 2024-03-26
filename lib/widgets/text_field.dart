import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest),
      cursorColor: AppColors.highlightDark,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkLightest),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.neutralDarkLightest),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.highlightDark),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
