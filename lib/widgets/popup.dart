// registration_popup.dart
import 'package:flutter/material.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/ui/theme/color.dart';

void showRegistrationPopup(BuildContext context, String mode) {
  String title = mode == 'voice' ? '음성으로 등록하기' : '이미지로 등록하기';
  String description = mode == 'voice'
      ? '식재료 정보(식재료 이름, 식재료 양, 소비기한)를 직접 말해보세요!'
      : '식재료의 모습이나 식재료 정보(식재료 이름, 식재료 양, 소비기한)가 담긴 텍스트를 사진으로 찍어보세요!';

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 16.0),
            Text(
              title,
              style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkMedium),
            ),
            SizedBox(height: 32.0),
            PrimaryButton(
              text: mode == 'voice' ? '녹음 시작' : '사진 찍기',
              onPressed: () {
                // Logic for voice recording or taking a picture
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
