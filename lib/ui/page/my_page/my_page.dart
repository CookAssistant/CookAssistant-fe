import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/ui/page/my_fridge/my_fridge.dart';
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
                Text('Lucas Scott', style: AppTextStyles.headingH3.copyWith(color: AppColors.neutralDarkDarkest)),
                Text('@lucasscott3', style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight)),
              ],
            ),
          ),
          _buildTile(context, '나의 냉장고', MyFridgePage()),
          _buildTile(context, '나의 레시피', MyRecipesPage()),
          _buildTile(context, '좋아요한 레시피', LikedRecipesPage()),
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


class MyRecipesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar
        (
          title: Text(
            "나의 레시피",
            style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
          )
      )
  );
}

class LikedRecipesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar
        (
          title: Text(
            "좋아요한 레시피",
            style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
          )
      )
  );
}

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar
        (
          title: Text(
            "로그아웃",
            style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
          )
      )
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: AppColors.neutralLightLightest,
        ),
        child: AlertDialog(
          title: Text(
            "로그아웃",
            style: AppTextStyles.headingH3.copyWith(color: AppColors.neutralDarkDarkest),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "로그아웃 하시겠습니까? 앱을 이용하기 위해선 다시 로그인 해야합니다.",
            style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0), // Apply 8-pixel padding around the button row
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: SecondaryButton(
                      text: '취소',
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ),
                  SizedBox(width: 8), // Provides spacing between the buttons
                  Expanded(
                    child: PrimaryButton(
                      text: '로그아웃',
                      onPressed: () {
                        Navigator.of(context).pop(); // Potentially add logout functionality here
                        // Implement your logout logic
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
          actionsPadding: EdgeInsets.symmetric(horizontal: 10), // Adjust if further padding is needed for the actions area
          actionsAlignment: MainAxisAlignment.center, // Center aligns the actions if needed
        ),
      );
    },
  );
}
