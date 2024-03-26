import 'package:flutter/material.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/widgets/button/secondary_button.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

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
          style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '식재료 추가 AI 도우미',
              style: AppTextStyles.headingH3.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            const SizedBox(height: 8.0),

            Text(
              '이미지 업로드나 영수증 인식을 통해 손쉽게 재료를 등록해 보세요!',
              style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
            ),
            const SizedBox(height: 32.0),
            PrimaryButton(
              text: '음성으로 등록하기',
              onPressed: () {
                // Implement the logic when the button is pressed
                // For example, save the data to a database or send it to an API
              },
            ),
            SecondaryButton(
              text: '이미지로 등록하기',
              onPressed: () {
                // Implement the logic when the button is pressed
                // For example, save the data to a database or send it to an API
              },
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0), // Add padding to the bottom of the '식재료 이름' text
              child: Text(
                '식재료 이름',
                style: AppTextStyles.headingH5.copyWith(color: AppColors.neutralDarkDark),
              ),
            ),
            _buildCustomTextField(
              context,
              controller: _nameController,
              label: '식재료 이름',
              hint: 'ex) 돼지고기',
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0), // Add padding to the bottom of the '식재료 이름' text
              child: Text(
                '식재료 양',
                style: AppTextStyles.headingH5.copyWith(color: AppColors.neutralDarkDark),
              ),
            ),
            _buildCustomTextField(
              context,
              controller: _quantityController,
              label: '식재료 양',
              hint: '단위를 포함해서 입력하세요',
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0), // Add padding to the bottom of the '식재료 이름' text
              child: Text(
                '소비기한',
                style: AppTextStyles.headingH5.copyWith(color: AppColors.neutralDarkDark),
              ),
            ),
            _buildCustomTextField(
              context,
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

  Widget _buildCustomTextField(BuildContext context, {required TextEditingController controller, required String label, required String hint}) {
    return TextField(
      controller: controller,
      style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest), // Set the style for input text
      decoration: InputDecoration(
        labelText: label,

        hintText: hint,
        hintStyle: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkLightest), // Set the style for hint text
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