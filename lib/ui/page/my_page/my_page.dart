import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '마이페이지',
            style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
      ),
      ),
      body: Center(
        child: Text('MYPAGE'),
      ),
    );
  }
}