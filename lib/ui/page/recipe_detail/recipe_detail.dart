import 'package:flutter/material.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cook_assistant/resource/config.dart';
import 'package:cook_assistant/widgets/dialog.dart';

class RecipeDetailPage extends StatefulWidget {
  final bool registered;
  final int userId;
  final int recipeId;

  RecipeDetailPage({Key? key, required this.registered, required this.userId, required this.recipeId}) : super(key: key);

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late Map<String, dynamic> recipeDetails;
  bool isLoading = true;
  bool isError = false;
  bool isLiked = false;

  final String defaultImageUrl = 'assets/images/lettuce.jpg';
  final String defaultAuthorId = 'cookingmaster123';
  final String defaultRecipeName = '돼지고기 된장찌개';
  final String defaultDietType = '락토베지테리언';
  final String defaultDate = '2024.03.10';
  final List<String> defaultMainIngredients = ['김치', '돼지고기', '두부'];
  final List<String> defaultAllIngredients = ['김치', '돼지고기', '두부', '양파', '마늘', '대파', '고춧가루', '된장', '미소된장', '참기름'];
  final List<String> defaultSteps = [
    '1. 냄비에 참기름을 두르고 다진 대파와 마늘을 볶아 향을 낸 후 양파를 넣어 볶습니다.',
    '2. 양파가 투명해질 때까지 볶은 후 고춧가루를 넣고 빨간 기름이 돌도록 볶아줍니다.',
    '3. 된장과 미소된장을 넣고 잘 섞어줍니다.',
    '4. 신김치를 넣고 볶아줍니다.',
    '5. 물을 넣고 국물이 끓어오르면 중간 불로 줄여 끓여줍니다.',
    '6. 국물이 끓어오르면 소금으로 간을 맞추고 남은 김치찌개 국물을 추가해 깊은 맛을 더해줍니다.',
    '7. 김치찌개가 끓어오르면 불을 끄고 다진 대파를 고루 뿌려줍니다.',
    '8. 그릇에 담아 고추기름을 한 두 방울 뿌려주면 완성입니다.',
  ];

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails();
  }

  Future<void> fetchRecipeDetails() async {
    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/api/v1/recipes/${widget.recipeId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Config.apiKey}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          recipeDetails = json.decode(response.body);
          isLoading = false;
          // Check if the recipe is liked by the user (this should be determined based on your app's logic)
          isLiked = recipeDetails['isLikedByUser'] ?? false;
        });
      } else {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  Future<void> likeRecipe() async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/v1/likes/new'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Config.apiKey}',
      },
      body: jsonEncode({
        'userId': widget.userId,
        'recipeId': widget.recipeId,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isLiked = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('레시피를 좋아요 했습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('좋아요에 실패했습니다. 상태 코드: ${response.statusCode}')),
      );
    }
  }

  Future<void> unlikeRecipe() async {
    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/api/v1/likes/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Config.apiKey}',
      },
      body: jsonEncode({
        'userId': widget.userId,
        'recipeId': widget.recipeId,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isLiked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('레시피 좋아요를 취소했습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('좋아요 취소에 실패했습니다. 상태 코드: ${response.statusCode}')),
      );
    }
  }

  Future<void> deleteRecipe(BuildContext context) async {
    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/api/v1/recipes/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Config.apiKey}',
      },
      body: jsonEncode({
        'userId': widget.userId,
        'recipeId': widget.recipeId,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('레시피가 성공적으로 삭제되었습니다.')),
      );
    } else {
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
                CustomAlertDialog.showCustomDialog(
                  context: context,
                  title: '레시피 삭제',
                  content: '정말로 레시피를 삭제하시겠습니까?',
                  cancelButtonText: '취소',
                  confirmButtonText: '삭제',
                  onConfirm: () {
                    Navigator.of(context).pop();
                    deleteRecipe(context);
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Container(
                    color: Colors.white, // Set background color to white
                    child: Text(
                      '삭제하기',
                      style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest),
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              isError || recipeDetails['imageUrl'] == null ? defaultImageUrl : recipeDetails['imageUrl'],
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isError || recipeDetails['recipeName'] == null ? defaultRecipeName : recipeDetails['recipeName'],
                  style: AppTextStyles.headingH2.copyWith(color: AppColors.neutralDarkDarkest),
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : AppColors.neutralDarkDarkest,
                  ),
                  onPressed: () {
                    if (isLiked) {
                      unlikeRecipe();
                    } else {
                      likeRecipe();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              isError || recipeDetails['dietType'] == null ? defaultDietType : recipeDetails['dietType'],
              style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isError || recipeDetails['authorId'] == null ? defaultAuthorId : recipeDetails['authorId'],
                  style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
                ),
                Text(
                  isError || recipeDetails['date'] == null ? defaultDate : recipeDetails['date'],
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
              isError || recipeDetails['mainIngredients'] == null
                  ? defaultMainIngredients.join(', ')
                  : (recipeDetails['mainIngredients'] as List<dynamic>).join(', '),
              style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            const SizedBox(height: 16.0),
            Text(
              '전체 재료',
              style: AppTextStyles.headingH5.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            Text(
              isError || recipeDetails['allIngredients'] == null
                  ? defaultAllIngredients.join(', ')
                  : (recipeDetails['allIngredients'] as List<dynamic>).join(', '),
              style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            const SizedBox(height: 32.0),
            Expanded(
              child: ListView(
                children: (isError || recipeDetails['steps'] == null ? defaultSteps : (recipeDetails['steps'] as List<dynamic>)).map<Widget>((step) {
                  return ListTile(
                    title: Text(
                      step,
                      style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (!widget.registered)
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
