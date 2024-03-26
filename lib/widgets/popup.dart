// registration_popup.dart
import 'package:flutter/material.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/widgets/button/secondary_button.dart'; // Make sure to import SecondaryButton too
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/ui/theme/color.dart';

enum PopupState { Ready, Recording, Finished }

void showRegistrationPopup(BuildContext context, String mode) {
  String title = mode == 'voice' ? '음성으로 등록하기' : '이미지로 등록하기';
  String description = mode == 'voice'
      ? '식재료 정보(식재료 이름, 식재료 양, 소비기한)를 직접 말해보세요!'
      : '식재료의 모습이나 식재료 정보(식재료 이름, 식재료 양, 소비기한)가 담긴 텍스트를 사진으로 찍어보세요!';

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      PopupState popupState = PopupState.Ready; // Initial state

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // Function to determine which button to show based on the state
          Widget buildActionButton() {
            if (mode == 'voice') {
              switch (popupState) {
                case PopupState.Recording:
                  return SecondaryButton(
                    text: '중지하기',
                    onPressed: () => setState(() {
                      popupState = PopupState.Finished;
                    }),
                  );
                case PopupState.Finished:
                  return PrimaryButton(
                    text: '완료하기',
                    onPressed: () => Navigator.of(context).pop(),
                  );
                case PopupState.Ready:
                default:
                  return PrimaryButton(
                    text: '녹음 시작',
                    onPressed: () => setState(() {
                      popupState = PopupState.Recording;
                    }),
                  );
              }
            } else {
              return PrimaryButton(
                text: '사진 찍기',
                onPressed: () => Navigator.of(context).pop(),
              );
            }
          }

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
                buildActionButton(),
              ],
            ),
          );
        },
      );
    },
  );
}
