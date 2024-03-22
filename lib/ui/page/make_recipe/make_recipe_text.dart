import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';


class MakeRecipeTextPage extends StatefulWidget {
  @override
  _MakeRecipeTextPageState createState() => _MakeRecipeTextPageState();
}

class _MakeRecipeTextPageState extends State<MakeRecipeTextPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '레시피 만들기',
          style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            '텍스트 기반 레시피 만들기 페이지',
            style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
          ),
        ),
      ),
    );
  }
}
