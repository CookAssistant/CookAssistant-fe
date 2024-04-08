import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

class DefaultCard extends StatelessWidget {
  final String title;
  final String expiryDays;

  const DefaultCard({
    Key? key,
    required this.title,
    required this.expiryDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 189,
      child: Card(
        color: AppColors.highlightLightest,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.photo, size: 32, color: AppColors.highlightLight),
            Text(
              '소비기한: $expiryDays일',
              style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            Text(
              title,
              style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
            ),
          ],
        ),
      ),
    );
  }
}
