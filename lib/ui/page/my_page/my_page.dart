import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/ui/page/community/community.dart';
import 'package:cook_assistant/ui/page/my_fridge/my_fridge.dart';
import 'package:cook_assistant/widgets/dialog.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/widgets/button/secondary_button.dart';
import 'package:cook_assistant/ui/page/auth/login.dart'; // Ensure this import points to your actual login page

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
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: SvgPicture.asset(
                    'assets/icons/avatar.svg',
                    width: 80,
                    height: 80,
                  ),
                ),
                SizedBox(height: 10),
                Text('로그인이 필요합니다', style: AppTextStyles.headingH3.copyWith(color: AppColors.neutralDarkDarkest)),
                Text('@loginNeeded', style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight)),
              ],
            ),
          ),
          _buildTile(context, '나의 냉장고', MyFridgePage()),
          _buildTile(context, '나의 레시피', CommunityPage(pageTitle: '나의 레시피', initialFilterCriteria: '나의 레시피')),
          _buildTile(context, '좋아요한 레시피', CommunityPage(pageTitle: '좋아요한 레시피', initialFilterCriteria: '좋아요한 레시피')),
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
          ListTile(  // New login button
            title: Text('로그인', style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest)),
            trailing: SvgPicture.asset(
              'assets/icons/arrow_right.svg',
              width: 12,
              height: 12,
              color: AppColors.neutralDarkLightest,
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage())),
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
        color: AppColors.neutralDarkLightest,
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => destinationPage));
      },
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  CustomAlertDialog.showCustomDialog(
    context: context,
    title: '로그아웃',
    content: '로그아웃 하시겠습니까? 앱을 이용하기 위해선 다시 로그인 해야합니다.',
    cancelButtonText: '취소',
    confirmButtonText: '로그아웃',
    onConfirm: () {
      // Add logout logic here, e.g., clear user session or navigate to login page
    },
  );
}
