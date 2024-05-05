import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/widgets/text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cook_assistant/resource/config.dart';


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
          _ingredientDateController.text = contentJson['ingredients'] ?? "정보 없음";
        });
      }
    } else {
      setState(() {
        _response = '오류가 발생했습니다. 상태 코드: ${response.statusCode}';
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
            PrimaryButton(
              text: '레시피 제안 받기',
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}

void navigateToMakingPage(BuildContext context, String recordedText) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MakingPage(recordedText: recordedText),
    ),
  );
}