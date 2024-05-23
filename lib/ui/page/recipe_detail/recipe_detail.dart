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
    '1. 냄비에 들기름을 두르고 다진 대파와 마늘을 볶아 향을 낸 후 양파를 넣어 볶습니다.',
    '2. 양파가 투명해질 때까지 볶은 후 고춧가루를 넣고 빨간 기름이 돌도록 볶아줍니다.',
    '3. 된장을 넣고 잘 섞어줍니다.',
    '4. 신김치를 넣고 볶아줍니다.',
    '5. 물을 넣고 국물이 끓어오르면 중간 불로 줄여 끓여줍니다.',
    '6. 국물이 끓어오르면 소금으로 간을 맞추고 남은 김치찌개 국물을 추가해 깊은 맛을 더해줍니다.',
    '7. 김치찌개가 끓어오르면 불을 끄고 다진 대파를 고루 뿌려줍니다.',
    '8. 그릇에 담으면 완성입니다.',
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

      if (response.statusCode == 201) {
        setState(() {
          recipeDetails = json.decode(response.body);
          isLoading = false;
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

    if (response.statusCode == 201) {
      setState(() {
        isLiked = true;
      });
      CustomAlertDialog.showCustomDialog(
        context: context,
        title: '레시피 좋아요',
        content: '레시피에 좋아요를 눌렀습니다.',
        cancelButtonText: '',
        confirmButtonText: '확인',
        onConfirm: () {
        },
      );
    } else {
      CustomAlertDialog.showCustomDialog(
        context: context,
        title: '좋아요 실패',
        content: '레시피 좋아요에 실패하였습니다. 상태 코드: ${response.statusCode}',
        cancelButtonText: '',
        confirmButtonText: '확인',
        onConfirm: () {
        },
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

    if (response.statusCode == 201) {
      setState(() {
        isLiked = false;
      });
      CustomAlertDialog.showCustomDialog(
        context: context,
        title: '좋아요 취소',
        content: '레시피 좋아요를 취소하였습니다.',
        cancelButtonText: '',
        confirmButtonText: '확인',
        onConfirm: () {
        },
      );
    } else {
      CustomAlertDialog.showCustomDialog(
        context: context,
        title: '좋아요 취소 실패',
        content: '레시피 좋아요 취소에 실패하였습니다. 상태 코드: ${response.statusCode}',
        cancelButtonText: '',
        confirmButtonText: '확인',
        onConfirm: () {
        },
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

    if (response.statusCode == 201) {
      CustomAlertDialog.showCustomDialog(
        context: context,
        title: '삭제 성공',
        content: '레시피가 성공적으로 삭제되었습니다.',
        cancelButtonText: '',
        confirmButtonText: '확인',
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
    } else {
      CustomAlertDialog.showCustomDialog(
        context: context,
        title: '삭제 실패',
        content: '레시피 삭제에 실패했습니다. 상태 코드: ${response.statusCode}',
        cancelButtonText: '',
        confirmButtonText: '확인',
        onConfirm: () {},
      );
    }
  }

  Future<void> registerRecipe() async {
    String ingredients = (isError || recipeDetails['allIngredients'] == null
        ? defaultAllIngredients
        : recipeDetails['allIngredients']).join(', ');

    String steps = (isError || recipeDetails['steps'] == null
        ? defaultSteps
        : recipeDetails['steps']).join('\n');

    final String content = 'Ingredients:\n$ingredients\n\nSteps:\n$steps';

    final Map<String, dynamic> requestData = {
      'userId': widget.userId,
      'name': isError || recipeDetails['recipeName'] == null ? 'TmpRecipeName' : recipeDetails['recipeName'],
      'content': content,
      'imageURL': isError || recipeDetails['imageUrl'] == null ? defaultImageUrl : recipeDetails['imageUrl'],
      'createdAt': DateTime.now().toIso8601String(),
    };

    print('Request Data: $requestData');

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/v1/recipes/new'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Config.apiKey}',
        },
        body: jsonEncode(requestData),
      );

      var decodedResponse = utf8.decode(response.bodyBytes);
      var jsonResponse = jsonDecode(decodedResponse);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $decodedResponse');

      if (response.statusCode == 201) {
        CustomAlertDialog.showCustomDialog(
          context: context,
          title: '등록 성공',
          content: '레시피가 커뮤니티에 등록되었습니다.',
          cancelButtonText: '',
          confirmButtonText: '확인',
          onConfirm: () {
            Navigator.of(context).pop();
          },
        );
      } else {
        CustomAlertDialog.showCustomDialog(
          context: context,
          title: '등록 실패',
          content: '레시피 등록에 실패했습니다. 상태 코드: ${jsonResponse.statusCode}',
          cancelButtonText: '',
          confirmButtonText: '확인',
          onConfirm: () {},
        );
      }
    } catch (e) {
      // Log the exception
      print('Exception: $e');
      CustomAlertDialog.showCustomDialog(
        context: context,
        title: '등록 실패',
        content: '레시피 등록에 실패했습니다. 예외: $e',
        cancelButtonText: '',
        confirmButtonText: '확인',
        onConfirm: () {},
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
                onPressed: registerRecipe,
              ),
          ],
        ),
      ),
    );
  }
}
