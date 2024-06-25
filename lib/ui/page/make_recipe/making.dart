import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/widgets/text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cook_assistant/resource/config.dart';
import 'package:cook_assistant/ui/page/recipe_detail/recipe_detail.dart';
import 'selectable_fridge_page.dart';

class MakingPage extends StatefulWidget {
  final String recordedText;

  MakingPage({required this.recordedText});

  @override
  _MakingPageState createState() => _MakingPageState();
}

class _MakingPageState extends State<MakingPage> {
  late String apiKey;

  final String userRecipe = "잠시만 기다려 주세요";
  final String userDiet = "잠시만 기다려 주세요";
  final String userIngredient = "잠시만 기다려 주세요";

  final TextEditingController _dietController = TextEditingController();
  final TextEditingController _recipeController = TextEditingController();
  final TextEditingController _ingredientDateController = TextEditingController();

  String _response = 'string init';
  String _responseJsonString = 'json init';
  String _recipeCreateResponse = '레시피 생성 응답 대기 중';

  List<String> fridgeIngredients = [];
  List<String> loadedIngredients = [];
  List<String> selectedIngredients = [];
  String imageType = "mushroom";

  Map<String, dynamic> generatedRecipeDetails = {};

  bool isLoading = false; // 로딩 상태 변수 추가

  @override
  void initState() {
    super.initState();
    _dietController.text = userDiet;
    _recipeController.text = userRecipe;
    _ingredientDateController.text = userIngredient;
    extractKeywords(widget.recordedText);
  }

  @override
  void dispose() {
    _dietController.dispose();
    _recipeController.dispose();
    _ingredientDateController.dispose();
    super.dispose();
  }

  Future<void> extractKeywords(String text) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Config.apiKey}',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'You are a program that extracts user diet preferences, recipe names, and ingredient keywords from entered text. Parse the given string. Please answer in korean'},
            {'role': 'user', 'content': '''
            다음 텍스트에서 userDiet, recipeName, ingredients, imageType을 추출해서 json 형식으로 알려줘.
            만약 사용할 재료가 언급되어 있지 않는 경우 다른 재료를 찾지 말고 "모든 재료" 라고 출력해줘.
            imageType은 [beef, lettuce, mushroom, nut, pasta, red_onion, roasted_chicken, salad, soup]중에서 골라줘. 철자가 다르거나 표기법이 다르면 안돼. 똑같은 종류가 없으면 가장 가까운 것으로 골라줘. 전혀 없으면 mushroom으로 해줘.
            다른 말은 하지 마.
            ${text}
            '''},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(utf8.decode(response.bodyBytes));
        if (result['choices'] != null && result['choices'].isNotEmpty) {
          final messageContent = result['choices'][0]['message']['content'];
          Map<String, dynamic> contentJson = jsonDecode(messageContent);
          setState(() {
            _response = messageContent;
            _responseJsonString = jsonEncode(contentJson);
            _dietController.text = contentJson['userDiet'] ?? "정보 없음";
            _recipeController.text = contentJson['recipeName'] ?? "정보 없음";
            loadedIngredients = (contentJson['ingredients'] is List)
                ? List<String>.from(contentJson['ingredients'])
                : [contentJson['ingredients'] ?? "정보 없음"];
            imageType = contentJson['imageType'] ?? "mushroom";
            updateSelectedIngredients();
          });
        }
      } else {
        setState(() {
          _response = '오류가 발생했습니다. 상태 코드: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = '오류가 발생했습니다: $e';
      });
    }
  }

  Future<void> streamCreateRecipe() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    final url = Uri.parse('${Config.baseUrl2}/create-recipe/stream/invoke');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Config.apiKey}',
    };
    final body = jsonEncode({
      'input': '''
당신은 미슐랭 스타를 받은 요리사이자 영양학 석사 학위를 가진 영양사입니다. 사용자가 원하는 요리명을 포함하여 가지고 있는 재료와 식단 유형에 맞는 맛있는 요리를 추천해 주세요.
식단 유형: [${_dietController.text}]
가지고 있는 재료: [${_ingredientDateController.text}]
원하는 요리명: [${_recipeController.text}]
레시피는 다음을 포함해야 합니다: 
1. 요리를 완성하는데 걸리는 시간을 제시한 후 필요한 재료 목록과 각 재료의 정확한 양. 
2. 단계별 요리 방법, 각 단계에 대한 자세한 설명. 
3. 요리를 더 맛있게 만드는 팁이나 변형 방법. 
4. 이 요리의 영양 정보(구체적인 1인분 칼로리)와 건강에 미치는 이점을 작성하세요. 
5.  제안된 레시피의 각 단계를 검토하고, 최종적으로 만족스러운지 확인한 후 필요에 따라 수정하세요. 
6. 레시피 작성 후, 결과물의 맛과 영양 정보를 다시 평가하고, 필요한 경우 보완점을 제시해 주세요.
      ''',
      'config': {},
      'kwargs': {}
    });

    print('Request URL: $url');
    print('Request Headers: $headers');
    print('Request Body: $body');

    final response = await http.post(url, headers: headers, body: body);

    final responseBody = utf8.decode(response.bodyBytes);
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: $responseBody');

    if (response.statusCode == 200) {
      setState(() {
        _recipeCreateResponse = '레시피가 성공적으로 생성되었습니다: $responseBody';
        generatedRecipeDetails = jsonDecode(responseBody)['output'];
      });
    } else {
      setState(() {
        _recipeCreateResponse = '레시피 생성에 실패했습니다: 상태 코드 ${response.statusCode} - 응답 본문: $responseBody';
      });
    }

    setState(() {
      isLoading = false; // 로딩 종료
    });
  }

  void updateSelectedIngredients() {
    selectedIngredients = [...fridgeIngredients, ...loadedIngredients];
    _ingredientDateController.text = selectedIngredients.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '레시피 만들기',
          style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시할 인디케이터
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '레시피 옵션 확인하기',
              style: AppTextStyles.headingH1.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            SizedBox(height: 32.0),
            Text(
              '음성으로 입력한 데이터 : ',
              style: AppTextStyles.headingH3.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            Text(
              widget.recordedText,
              style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            SizedBox(height: 32.0),
            Text(
              '나의 냉장고에서 레시피에 추가할 재료를 선택하세요!',
              style: AppTextStyles.headingH3.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            SizedBox(height: 8.0),
            PrimaryButton(
              text: '식재료 선택하기',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: SelectableFridgePage(
                      onIngredientsSelected: (ingredients) {
                        setState(() {
                          fridgeIngredients = ingredients;
                          updateSelectedIngredients();
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 32.0),
            CustomTextField(
              controller: _dietController,
              label: '사용자 식단',
              hint: ' ',
            ),
            SizedBox(height: 32.0),
            CustomTextField(
              controller: _recipeController,
              label: '레시피 이름',
              hint: ' ',
            ),
            SizedBox(height: 32.0),
            CustomTextField(
              controller: _ingredientDateController,
              label: '사용할 재료',
              hint: ' ',
            ),
            SizedBox(height: 300.0),
            Text(
              'String Response:',
              style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            Text(
              _response,
              style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            SizedBox(height: 32.0),
            Text(
              'JSON Response:',
              style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            Text(
              _responseJsonString,
              style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            SizedBox(height: 32.0),
            Text(
              '레시피 생성 응답:',
              style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            Text(
              _recipeCreateResponse,
              style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: '완료하기',
          onPressed: () async {
            await streamCreateRecipe();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailPage(
                  registered: false,
                  recipeId: 0,
                  recipeDetails: generatedRecipeDetails,
                  userDiet: _dietController.text,
                  recipeName: _recipeController.text,
                  imageType: 'assets/images/$imageType.jpg',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
