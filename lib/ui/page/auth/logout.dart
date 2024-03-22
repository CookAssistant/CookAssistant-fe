import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart'; // AppColors 사용을 위한 import
import 'package:cook_assistant/ui/theme/text_styles.dart'; // AppTextStyles 사용을 위한 import

class Logout {
  static Future<void> showLogoutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: AppColors.neutralLightLightest, // 적절한 배경색으로 변경
          ),
          child: AlertDialog(
            title: Text(
              "로그아웃",
              style: AppTextStyles.headingH3.copyWith(color: AppColors.neutralDarkDarkest), // 제목 스타일
            ),
            content: Text(
              "로그아웃 하시겠습니까? 앱을 이용하기 위해선 다시 로그인 해야합니다.",
              style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight), // 내용 스타일
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  '취소',
                  style: AppTextStyles.actionM.copyWith(color: AppColors.highlightDarkest), // 취소 버튼 스타일
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text(
                  '로그아웃',
                  style: AppTextStyles.actionM.copyWith(color: AppColors.highlightDarkest), // 로그아웃 버튼 스타일
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // 여기에 로그아웃을 처리하는 로직
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
