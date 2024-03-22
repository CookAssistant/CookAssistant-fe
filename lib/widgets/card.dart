import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const CustomCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: AppColors.highlightLightest,
      elevation: 0,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.neutralDarkDarkest.withOpacity(0.1),
                    AppColors.neutralDarkDarkest.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 10,
            right: 10,
            child: Text(
              subtitle,
              style: AppTextStyles.headingH4.copyWith(
                color: AppColors.neutralDarkDarkest,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Positioned(
            bottom: 36,
            left: 10,
            right: 10,
            child: Text(
              title,
              style: AppTextStyles.bodyS.copyWith(
                color: AppColors.neutralDarkDarkest,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
