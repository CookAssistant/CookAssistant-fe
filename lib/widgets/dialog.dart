import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

class CustomAlertDialog {
  static Future<void> showCustomDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String cancelButtonText,
    required String confirmButtonText,
    required VoidCallback onConfirm,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: AppColors.neutralLightLightest,
          ),
          child: AlertDialog(
            title: Text(
              title,
              style: AppTextStyles.headingH3.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            content: Text(
              content,
              style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  cancelButtonText,
                  style: AppTextStyles.actionM.copyWith(color: AppColors.highlightDarkest),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text(
                  confirmButtonText,
                  style: AppTextStyles.actionM.copyWith(color: AppColors.highlightDarkest),
                ),
                onPressed: () {
                  onConfirm();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
