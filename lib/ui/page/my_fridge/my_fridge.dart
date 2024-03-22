import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

class MyFridgePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar
        (
          title: Text(
            "나의 냉장고",
            style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
          )
      ),
  );
}
