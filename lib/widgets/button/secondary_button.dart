import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double borderRadius;
  final double height = 48.0;

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.borderRadius = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.neutralLightLightest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(color: AppColors.highlightDark, width: 1.5), // 테두리 두께를 2.0으로 설정
        ).copyWith(
          foregroundColor: MaterialStateProperty.all(AppColors.highlightDark), // 텍스트 색상
        ),
        child: Text(
          text,
          style: AppTextStyles.actionM.copyWith(color: AppColors.highlightDark),
        ),
      ),
    );
  }
}
