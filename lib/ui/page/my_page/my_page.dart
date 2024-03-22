import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/ui/page/community/community.dart';
import 'package:cook_assistant/ui/page/my_fridge/my_fridge.dart';
import 'package:cook_assistant/ui/page/auth/logout.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/widgets/button/secondary_button.dart';



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
      body: ListView( // 상단 및 하단 패딩 추가
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: SvgPicture.asset(
                    'assets/icons/avatar.svg',
                    width: 80,
                    height: 80,
                  ),
                ),
                SizedBox(height: 10),
                Text('Lucas Scott', style: AppTextStyles.headingH3.copyWith(color: AppColors.neutralDarkDarkest)),
                Text('@lucasscott3', style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight)),
              ],
            ),
          ),
          _buildTile(context, '나의 냉장고', MyFridgePage()),
          _buildTile(context, '나의 레시피', CommunityPage()),
          _buildTile(context, '좋아요한 레시피', CommunityPage()),
          ListTile(
            title: Text('로그아웃', style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest)),
            trailing: SvgPicture.asset(
              'assets/icons/arrow_right.svg',
              width: 12,
              height: 12,
              color: AppColors.neutralDarkLightest,
            ),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, Widget destinationPage) {
    return ListTile(
      title: Text(title, style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest)),
      trailing: SvgPicture.asset(
        'assets/icons/arrow_right.svg',
        width: 12,
        height: 12,
        color: AppColors.neutralDarkLightest, // Assuming you have this color defined
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => destinationPage));
      },
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  Logout.showLogoutDialog(context);
}