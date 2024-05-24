import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/widgets/button/secondary_button.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/widgets/text_field.dart';
import 'package:cook_assistant/widgets/popup.dart';
import 'package:cook_assistant/widgets/dialog.dart';
import 'package:cook_assistant/resource/config.dart'; // Ensure this import is correct

class AddIngredientsPage extends StatefulWidget {
  @override
  _AddIngredientsPageState createState() => _AddIngredientsPageState();
}

class _AddIngredientsPageState extends State<AddIngredientsPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();

  Future<void> pickAndAnalyzeImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      print("선택된 이미지가 없습니다.");
      return;
    }
    print("선택된 이미지: ${image.path}");
    String? extractedText = await annotateImage(image.path);
    if (extractedText == null) {
      print("추출된 텍스트가 없습니다.");
      return;
    }
    print("추출된 텍스트: $extractedText");
    Map<String, String> parsedData = await queryOpenAI(extractedText);
    setState(() {
      _nameController.text = parsedData['name'] ?? '알 수 없음';
      _quantityController.text = parsedData['amount'] ?? '알 수 없음';
      _expirationDateController.text = parsedData['expiration'] ?? '알 수 없음';
    });
  }

  Future<String?> annotateImage(String imagePath) async {
    try {
      String base64Image = await encodeImageToBase64(imagePath);
      Uri uri = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=${dotenv.get('GOOGLE_CLOUD_VISION_API_KEY')}');
      var response = await http.post(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          'requests': [
            {
              'image': {'content': base64Image},
              'features': [{'type': 'TEXT_DETECTION'}]
            }
          ]
        }),
      );
      print('Vision API 요청 데이터: ${jsonEncode({
        'requests': [
          {
            'image': {'content': base64Image},
            'features': [{'type': 'TEXT_DETECTION'}]
          }
        ]
      })}');
      print('Vision API 응답 상태 코드: ${response.statusCode}');
      print('Vision API 응답 본문: ${response.body}');
      if (response.statusCode != 200) throw "Vision API 호출 실패: ${response.statusCode}";
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['responses'][0]['textAnnotations'].isEmpty) throw "어노테이션을 찾을 수 없습니다.";
      return jsonResponse['responses'][0]['textAnnotations'][0]['description'];
    } catch (e) {
      print("annotateImage 오류: $e");
      return null;
    }
  }

  Future<Map<String, String>> queryOpenAI(String text) async {
    try {
      Uri uri = Uri.parse(dotenv.get('OPENAI_API_URL'));
      String apiKey = dotenv.get('OPENAI_API_KEY');
      var response = await http.post(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $apiKey',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': '제품명과 수량 그리고 소비기한을 순서대로 나열하라. ex) 과자,2,2024-02-03  만약 소비기한이 없다면 x로 표시하라. ex) 과자,2,x  만약 두가지 이상의 종류가 나온다면 처음에 나온 한가지 종류만 출력하라. ex) 과자,2,x 와 우유,3,x 가 나온다면 과자,2,x 만 출력하라'},
            {'role': 'user', 'content': text},
          ],
        }),
      );
      print('OpenAI API 요청 데이터: ${jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': '제품명과 수량 그리고 소비기한을 순서대로 나열하라. ex) 과자,2,2024-02-03  만약 소비기한이 없다면 x로 표시하라. ex) 과자,2,x  만약 두가지 이상의 종류가 나온다면 처음에 나온 한가지 종류만 출력하라. ex) 과자,2,x 와 우유,3,x 가 나온다면 과자,2,x 만 출력하라'},
          {'role': 'user', 'content': text},
        ],
      })}');
      print('OpenAI API 응답 상태 코드: ${response.statusCode}');
      print('OpenAI API 응답 본문: ${response.body}');
      if (response.statusCode != 200) throw "OpenAI API 호출 실패: ${response.statusCode}";
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      var content = jsonResponse['choices'][0]['message']['content'];
      print("OpenAI 응답: $content");
      return parseAIResponse(content);
    } catch (e) {
      print("queryOpenAI 오류: $e");
      return {'name': '오류', 'amount': '오류', 'expiration': '오류'};
    }
  }

  Map<String, String> parseAIResponse(String response) {
    try {
      RegExp exp = RegExp(r"([^,]+),([^,]+),([^,]+)");
      var matches = exp.firstMatch(response);
      if (matches != null) {
        return {
          'name': matches.group(1) ?? '알 수 없음',
          'amount': matches.group(2) ?? '지정되지 않음',
          'expiration': matches.group(3) ?? '제공되지 않음',
        };
      } else {
        print("응답에서 항목을 찾을 수 없습니다.");
        return {'name': '알 수 없음', 'amount': '알 수 없음', 'expiration': '알 수 없음'};
      }
    } catch (e) {
      print("parseAIResponse 오류: $e");
      return {'name': '오류', 'amount': '오류', 'expiration': '오류'};
    }
  }

  Future<String> encodeImageToBase64(String imagePath) async {
    try {
      File imageFile = File(imagePath);
      List<int> imageBytes = await imageFile.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      print("이미지 인코딩 오류: $e");
      return '';
    }
  }

  Future<void> createIngredient() async {
    final String apiUrl = '${Config.baseUrl}/api/v1/ingredients/new';
    final Map<String, dynamic> requestBody = {
      "userId": 16,
      "name": _nameController.text,
      "quantity": _quantityController.text,
      "expirationDate": _expirationDateController.text,
      "imageURL": "assets/images/lettuce.jpg",
      "type": "string"
    };

    print('요청 데이터: $requestBody');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          //'Authorization': 'Bearer ${Config.apiKey}',
        },
        body: jsonEncode(requestBody),
      );

      var decodedResponse = utf8.decode(response.bodyBytes);
      var jsonResponse = jsonDecode(decodedResponse);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $decodedResponse');

      if (response.statusCode == 201) {
        CustomAlertDialog.showCustomDialog(
          context: context,
          title: '등록 완료',
          content: '식재료가 성공적으로 등록되었습니다.',
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
          content: '식재료 등록에 실패했습니다. 상태 코드: ${response.statusCode}',
          cancelButtonText: '',
          confirmButtonText: '확인',
          onConfirm: () {},
        );
      }
    } catch (e) {
      print('Error occurred while creating ingredient: $e');
      CustomAlertDialog.showCustomDialog(
        context: context,
        title: '등록 실패',
        content: '식재료 등록 중 오류가 발생했습니다: $e',
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
          '식재료 추가하기',
          style: AppTextStyles.headingH4.copyWith(
              color: AppColors.neutralDarkDarkest),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Text(
              '식재료 추가 AI 도우미',
              textAlign: TextAlign.center,
              style: AppTextStyles.headingH3.copyWith(
                  color: AppColors.neutralDarkDarkest),
            ),
            const SizedBox(height: 8.0),
            Text(
              '음성 인식나 이미지 인식을 통해 손쉽게 재료를 등록해 보세요!',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyS.copyWith(
                  color: AppColors.neutralDarkLight),
            ),
            const SizedBox(height: 48.0),
            PrimaryButton(
              text: '음성으로 등록하기',
              onPressed: () => showRegistrationPopup(context, 'voice'),
            ),
            SecondaryButton(
              text: '이미지로 등록하기',
              onPressed: pickAndAnalyzeImage,
            ),
            const SizedBox(height: 60.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '식재료 이름',
                    style: AppTextStyles.headingH5.copyWith(
                        color: AppColors.neutralDarkDark),
                  ),
                ],
              ),
            ),
            CustomTextField(
              controller: _nameController,
              label: '식재료 이름',
              hint: 'ex) 돼지고기',
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '식재료 양',
                    style: AppTextStyles.headingH5.copyWith(
                        color: AppColors.neutralDarkDark),
                  ),
                ],
              ),
            ),
            CustomTextField(
              controller: _quantityController,
              label: '식재료 양',
              hint: '단위를 포함해서 입력하세요  ex) 400g',
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '소비기한',
                    style: AppTextStyles.headingH5.copyWith(
                        color: AppColors.neutralDarkDark),
                  ),
                ],
              ),
            ),
            CustomTextField(
              controller: _expirationDateController,
              label: '소비기한',
              hint: '0000년 00월 00일',
            ),
            const Spacer(),
            PrimaryButton(
              text: '완료하기',
              onPressed: () async {
                await createIngredient();
              },
            ),
          ],
        ),
      ),
    );
  }
}
