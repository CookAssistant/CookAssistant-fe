import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:flutter_svg/svg.dart';

Widget buildDropdownButton({
  required String value,
  required List<String> options,
  required void Function(String?) onChanged,
  required String iconPath,
}) {
  return Container(
    width: 120,
    padding: EdgeInsets.symmetric(horizontal: 8),
    child: DropdownButton<String>(
      value: value,
      icon: SvgPicture.asset(
        iconPath,
        width: 12,
        color: AppColors.neutralDarkDarkest,
      ),
      onChanged: onChanged,
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: AppTextStyles.actionM.copyWith(color: AppColors.neutralDarkDarkest),
          ),
        );
      }).toList(),
      isExpanded: true,
      underline: Container(
        height: 2,
        color: AppColors.neutralLightDarkest,
      ),
    ),
  );
}
