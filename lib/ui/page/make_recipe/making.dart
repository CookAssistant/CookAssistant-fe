import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/widgets/text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cook_assistant/resource/config.dart';
import 'package:cook_assistant/ui/page/recipe_detail/recipe_detail.dart';

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

  @override
  void initState() {
    super.initState();
    _dietController.text = userDiet;
    _recipeController.text = userRecipe;
    _ingredientDateController.text = userIngredient;
  }

  @override
  void dispose() {
    _dietController.dispose();
    _recipeController.dispose();
    _ingredientDateController.dispose();
    super.dispose();
  }

  Future<void> extractKeywords(String text) async {
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
          {'role': 'user', 'content': '다음 텍스트에서 userDiet, recipeName, ingredients를 추출해서 json 형식으로 알려줘. 만약 사용할 재료가 언급되어 있지 않는 경우 다른 재료를 찾지 말고 "모든 재료" 라고 출력해줘. 다른 말은 하지 마. ${text}'},
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
          _ingredientDateController.text = (contentJson['ingredients'] is List)
              ? (contentJson['ingredients'] as List).join(', ')
              : contentJson['ingredients'] ?? "정보 없음";
        });

        await streamCreateRecipe(contentJson);
      }
    } else {
      setState(() {
        _response = '오류가 발생했습니다. 상태 코드: ${response.statusCode}';
      });
    }
  }

  Future<void> streamCreateRecipe(Map<String, dynamic> recipeData) async {
    final url = Uri.parse('${Config.baseUrl2}/create-recipe/stream/invoke');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Config.apiKey}',
    };
    final body = jsonEncode({
      'input': "템페를 이용해서 돼지고기 된장찌개 레시피를 만들어줘. 락토오보베지테리언 식단이야.",//_recipeController.text,
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
      });
    } else {
      setState(() {
        _recipeCreateResponse = '레시피 생성에 실패했습니다: 상태 코드 ${response.statusCode} - 응답 본문: $responseBody';
      });
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'AI로 레시피를 검색하여 변환하는 중입니다...',
              style: AppTextStyles.headingH1.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            SizedBox(height: 16.0),
            Text(
              widget.recordedText,
              style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            SizedBox(height: 32.0),
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
            SizedBox(height: 32.0),
            Text(
              '레시피 생성 응답:',
              style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            Text(
              _recipeCreateResponse,
              style: AppTextStyles.bodyL.copyWith(color: AppColors.neutralDarkDarkest),
            ),
            SizedBox(height: 32.0),
            PrimaryButton(
              text: '레시피 정보 불러오기',
              onPressed: () {
                extractKeywords(widget.recordedText);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: '완료하기',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailPage(registered: false, recipeId: 9),
              ),
            );
          },
        ),
      ),
    );
  }
}
