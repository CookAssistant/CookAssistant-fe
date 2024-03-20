import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

class RecipeCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('레시피 제작하기'),
      ),
      body: SingleChildScrollView(

        child: Column(

          children: <Widget>[
            Container(
              height: 394,
              color: AppColors.highlightLightest,
              child: Center(
                child: Text('이미지'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '나에게 맞는 레시피를 만들어 보세요',
                style: AppTextStyles.headingH1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '원하는 식단, 재료로 기존 웹 페이지의 레시피를 사용자에 맞게 변환합니다.',
                style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // 음성으로 시작하기 로직
                },
                child: Text(
                  '음성으로 시작하기',
                  style: AppTextStyles.actionM.copyWith(color: AppColors.neutralLightLightest),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.highlightDarkest,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () {
                  // 텍스트로 시작하기 로직
                },
                child: Text(
                  '텍스트로 시작하기',
                  style: AppTextStyles.actionM.copyWith(color: AppColors.highlightDarkest),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.highlightDarkest),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
