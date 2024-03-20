import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CookAssistant'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Container(
              height: 214,
              color: AppColors.highlightLightest,
              child: Center(
                child: Text('광고 배너'),
              ),
            ),
            _buildSectionTitle(context, '나의 냉장고', () {}),
            _buildHorizontalList(),
            _buildSectionTitle(context, '유저가 만든 레시피', () {}),
            _buildHorizontalList(),
          ],
        ),
      ),

    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
              title,
              style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
          ),
          GestureDetector(
              onTap: onTap,
              child: Text(
                '더보기',
                style: AppTextStyles.actionM.copyWith(color: AppColors.highlightDarkest),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList() {
    return Container(
      height: 189,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 189,
            child: Card(
              color: AppColors.highlightLightest,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.photo,
                      size: 32,
                      color: AppColors.highlightLight,
                  ),
                  Text(
                    '소비기한: 00일',
                    style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                  ),
                  Text(
                    '식재료 이름',
                    style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
