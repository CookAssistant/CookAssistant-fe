import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/ui/page/make_recipe/make_recipe_voice.dart';
import 'package:cook_assistant/ui/page/make_recipe/make_recipe_text.dart';
import 'package:cook_assistant/ui/page/make_recipe/voice_test.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/widgets/button/secondary_button.dart';

class RecipeCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '레시피 제작하기',
          style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              color: AppColors.highlightLightest,
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/banners/make_recipe.webp',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Align text to the center
                children: [
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      '나에게 맞는 레시피를 만들어 보세요',
                      textAlign: TextAlign.center, // Center text alignment
                      style: AppTextStyles.headingH1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      '원하는 식단, 재료로 기존 웹 페이지의 레시피를 사용자에 맞게 변환합니다.',
                      textAlign: TextAlign.center, // Center text alignment
                      style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
                    ),
                  ),
                  PrimaryButton(
                    text: '음성으로 시작하기',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MakeRecipeVoicePage()),
                      );
                    },
                  ),
                  SecondaryButton(
                    text: '텍스트로 시작하기',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MakeRecipeTextPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
