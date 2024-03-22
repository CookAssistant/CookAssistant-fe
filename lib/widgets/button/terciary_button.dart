import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

class TerciaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double borderRadius = 8.0;
  final double height = 48.0;

  const TerciaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.neutralLightLightest, // 투명한 배경
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(color: Colors.transparent), // 투명한 테두리
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
