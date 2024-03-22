import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '마이페이지',
          style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
      ),
      body: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey.shade800,
                  radius: 40.0,
                  child: Text(
                    'LS',
                    style: TextStyle(fontSize: 40.0, color: AppColors.neutralDarkDarkest), // Assuming default color for the avatar text
                  ),
                ),
                SizedBox(height: 10), // Spacing between avatar and name
                Text('Lucas Scott', style: AppTextStyles.headingH3.copyWith(color: AppColors.neutralDarkDarkest)),
                Text('@lucasscott3', style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight)),
              ],
            ),
          ),
          _buildTile(context, '나의 냉장고'),
          _buildTile(context, '나의 레시피'),
          _buildTile(context, '좋아요한 레시피'),
          _buildTile(context, '로그아웃'),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title) {
    return ListTile(
      title: Text(title, style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest)),
      onTap: () {
        // TODO: Implement navigation or functionality for each tile
      },
    );
  }
}