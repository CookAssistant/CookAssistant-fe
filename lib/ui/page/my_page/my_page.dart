import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/ui/page/community/community.dart';
import 'package:cook_assistant/ui/page/my_fridge/my_fridge.dart';
import 'package:cook_assistant/widgets/dialog.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/widgets/button/secondary_button.dart';
import 'package:cook_assistant/ui/page/auth/login.dart'; // Ensure this import points to your actual login page
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cook_assistant/resource/config.dart';


class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool isLoggedIn = false;
  String nickname = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken != null && accessToken.isNotEmpty && accessToken != 'guest') {
      setState(() {
        isLoggedIn = true;
      });
      await _fetchUserDetails(accessToken);
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  Future<void> _fetchUserDetails(String accessToken) async {
    try {
      var url = Uri.parse('${Config.baseUrl}/api/v1/users/myPage');
      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $accessToken',
      });

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${utf8.decode(response.bodyBytes)}');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          nickname = jsonResponse['data']['email'];
        });
        print('User email: $nickname');
      } else {
        print('Failed to load user email');
      }
    } catch (e) {
      print('Error fetching user email: $e');
    }
  }


  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', 'guest');
    setState(() {
      isLoggedIn = false;
      nickname = '';
    });
  }

  void _showLogoutDialog(BuildContext context) {
    CustomAlertDialog.showCustomDialog(
      context: context,
      title: '로그아웃',
      content: '로그아웃 하시겠습니까? 앱을 이용하기 위해선 다시 로그인 해야합니다.',
      cancelButtonText: '취소',
      confirmButtonText: '로그아웃',
      onConfirm: () {
        _logout();
        if (Navigator.of(context).canPop()) {
        }
      },
    );
  }

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
                Text(
                  isLoggedIn ? '환영합니다!' : '로그인이 필요합니다',
                  style: AppTextStyles.headingH3.copyWith(color: AppColors.neutralDarkDarkest),
                ),
                if (isLoggedIn)
                  Text(
                    nickname,
                    style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                  ),
                if (!isLoggedIn)
                  Text('@loginNeeded', style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight)),
              ],
            ),
          ),
          if (isLoggedIn) ...[
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
          ] else ...[
            ListTile(
              title: Text('로그인', style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest)),
              trailing: SvgPicture.asset(
                'assets/icons/arrow_right.svg',
                width: 12,
                height: 12,
                color: AppColors.neutralDarkLightest,
              ),
              onTap: () async {
                final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                if (result == true) {
                  _checkLoginStatus();
                }
              },
            ),
          ],
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
