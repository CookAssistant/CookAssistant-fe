import 'package:flutter/material.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/widgets/button/secondary_button.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/widgets/text_field.dart';
import 'package:cook_assistant/widgets/popup.dart';

class AddIngredientsPage extends StatelessWidget {
  AddIngredientsPage({Key? key}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '식재료 추가하기',
          style: AppTextStyles.headingH4.copyWith(
              color: AppColors.neutralDarkDarkest),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text(
              '식재료 추가 AI 도우미',
              textAlign: TextAlign.center,
              style: AppTextStyles.headingH3.copyWith(
                  color: AppColors.neutralDarkDarkest),
            ),
            const SizedBox(height: 8.0),
            Text(
              '음성 인식나 이미지 인식을 통해 손쉽게 재료를 등록해 보세요!',
              textAlign: TextAlign.center, // Center-aligned text
              style: AppTextStyles.bodyS.copyWith(
                  color: AppColors.neutralDarkLight),
            ),
            const SizedBox(height: 48.0),
            PrimaryButton(
              text: '음성으로 등록하기',
              onPressed: () => showRegistrationPopup(context, 'voice'),
            ),
            SecondaryButton(
              text: '이미지로 등록하기',
              onPressed: () => showRegistrationPopup(context, 'image'),
            ),
            const SizedBox(height: 60.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Add this line
                children: [
                  Text(
                    '식재료 이름',
                    style: AppTextStyles.headingH5.copyWith(
                        color: AppColors.neutralDarkDark),
                  ),
                ],
              ),
            ),
            CustomTextField(
              controller: _nameController,
              label: '식재료 이름',
              hint: 'ex) 돼지고기',
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Add this line
                children: [
                  Text(
                    '식재료 양',
                    style: AppTextStyles.headingH5.copyWith(
                        color: AppColors.neutralDarkDark),
                  ),
                ],
              ),
            ),

            CustomTextField(
              controller: _quantityController,
              label: '식재료 양',
              hint: '단위를 포함해서 입력하세요  ex) 400g',
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Add this line
                children: [
                  Text(
                    '소비기한',
                    style: AppTextStyles.headingH5.copyWith(
                        color: AppColors.neutralDarkDark),
                  ),
                ],
              ),
            ),
            CustomTextField(
              controller: _expirationDateController,
              label: '소비기한',
              hint: '0000년 00월 00일',
            ),
            const Spacer(),
            PrimaryButton(
              text: '완료하기',
              onPressed: () {
                // TODO: Implement completion logic
              },
            ),
          ],
        ),
      ),
    );
  }
}