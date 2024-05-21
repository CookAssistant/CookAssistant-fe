import 'package:flutter/material.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cook_assistant/resource/config.dart';

class RecipeDetailPage extends StatelessWidget {
  final bool registered;
  final int userId;
  final int recipeId;

  RecipeDetailPage({Key? key, required this.registered, required this.userId, required this.recipeId}) : super(key: key);

  final String imageUrl = 'assets/images/lettuce.jpg';
  final String authorId = 'cookingmaster123';

  Future<void> deleteRecipe(BuildContext context) async {
    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/api/v1/recipes/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Config.apiKey}',
      },
      body: jsonEncode({
        'userId': userId,
        'recipeId': recipeId,
      }),
    );

    if (response.statusCode == 200) {
      // Navigate back or show success message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('레시피가 성공적으로 삭제되었습니다.')),
      );
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('레시피 삭제에 실패했습니다. 상태 코드: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '레시피 상세정보',
          style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: AppColors.neutralDarkDarkest),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.neutralDarkDarkest),
            onSelected: (String value) {
              if (value == 'delete') {
                // Confirm deletion
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('레시피 삭제'),
                      content: Text('정말로 레시피를 삭제하시겠습니까?'),
                      actions: [
                        TextButton(
                          child: Text('취소'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('삭제'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            deleteRecipe(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('삭제하기'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '돼지고기 된장찌개',
                  style: AppTextStyles.headingH2.copyWith(color: AppColors.neutralDarkDarkest),
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border, color: AppColors.neutralDarkDarkest),
                  onPressed: () {
                    // TODO: Add favorite action
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              '락토베지테리언',
              style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  authorId,
                  style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
                ),
                Text(
                  '2024.03.10',
                  style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Text(
              '주요 재료',
              style: AppTextStyles.headingH5.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            Text(
              '김치, 돼지고기, 두부',
              style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            const SizedBox(height: 16.0),
            Text(
              '전체 재료',
              style: AppTextStyles.headingH5.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            Text(
              '김치, 돼지고기, 두부, 양파, 마늘, 대파, 고춧가루, 된장, 미소된장, 참기름',
              style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            const SizedBox(height: 32.0),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      '1. 냄비에 참기름을 두르고 다진 대파와 마늘을 볶아 향을 낸 후 양파를 넣어 볶습니다.',
                      style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '2. 양파가 투명해질 때까지 볶은 후 고춧가루를 넣고 빨간 기름이 돌도록 볶아줍니다.',
                      style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '3. 된장과 미소된장을 넣고 잘 섞어줍니다.',
                      style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '4. 신김치를 넣고 볶아줍니다.',
                      style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '5. 물을 넣고 국물이 끓어오르면 중간 불로 줄여 끓여줍니다.',
                      style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '6. 국물이 끓어오르면 소금으로 간을 맞추고 남은 김치찌개 국물을 추가해 깊은 맛을 더해줍니다.',
                      style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '7. 김치찌개가 끓어오르면 불을 끄고 다진 대파를 고루 뿌려줍니다.',
                      style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '8. 그릇에 담아 고추기름을 한 두 방울 뿌려주면 완성입니다.',
                      style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                    ),
                  ),
                ],
              ),
            ),
            if (!registered)
              PrimaryButton(
                text: '커뮤니티에 등록하기',
                onPressed: () {
                  // TODO: Implement registration action
                },
              ),
          ],
        ),
      ),
    );
  }
}
