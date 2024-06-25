import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/ui/page/add_ingredients/add_ingredients.dart';
import 'package:cook_assistant/resource/config.dart';
import 'package:cook_assistant/widgets/dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FridgeCard extends StatelessWidget {
  final String title;
  final String expiryDate;
  final String quantity;
  final String imageUrl;
  final VoidCallback onDelete;

  const FridgeCard({
    Key? key,
    required this.title,
    required this.expiryDate,
    required this.quantity,
    required this.imageUrl,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isNetworkImage = Uri.tryParse(imageUrl)?.hasAbsolutePath ?? false;
    return Container(
      width: 327,
      height: 110,
      color: AppColors.neutralLightLightest,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              isNetworkImage
                  ? Image.network(
                imageUrl,
                width: 56.0,
                height: 56.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              )
                  : Image.asset(
                imageUrl,
                width: 56.0,
                height: 56.0,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.headingH5.copyWith(color: AppColors.neutralDarkDarkest),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '소비기한: $expiryDate',
                      style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '보유량: $quantity',
                      style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkLight),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.neutralDarkDarkest),
                iconSize: 20,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyFridgePage extends StatefulWidget {
  @override
  _MyFridgePageState createState() => _MyFridgePageState();
}

class _MyFridgePageState extends State<MyFridgePage> {
  List<Map<String, dynamic>> fridgeItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIngredients();
  }

  Future<void> fetchIngredients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token is null');
      return;
    }

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/v1/ingredients/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    // 응답 로그 출력
    print('Fetch Ingredients Response Status Code: ${response.statusCode}');
    print('Fetch Ingredients Response Body: ${utf8.decode(response.bodyBytes)}');

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> ingredients = jsonResponse['data'];
      setState(() {
        fridgeItems = ingredients.map((ingredient) {
          return {
            "id": ingredient['id'],
            "title": ingredient['name'] ?? 'Unknown',
            "expiryDate": ingredient['expirationDate'] ?? 'Unknown',
            "quantity": ingredient['quantity'] ?? 'Unknown',
            "imageUrl": ingredient['imageURL'] ?? 'Unknown',
          };
        }).toList();
        isLoading = false;
      });
    } else {
      print('Failed to load ingredients: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteIngredient(int ingredientId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/api/v1/ingredients/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'ingredientId': ingredientId,
      }),
    );

    print('Delete Ingredient Response Status Code: ${response.statusCode}');
    print('Delete Ingredient Response Body: ${response.body}');

    if (response.statusCode == 200) {
      setState(() {
        fridgeItems.removeWhere((item) => item['id'] == ingredientId);
        CustomAlertDialog.showCustomDialog(
          context: context,
          title: '식재료 삭제',
          content: '식재료가 성공적으로 삭제되었습니다.',
          cancelButtonText: '',
          confirmButtonText: '확인',
          onConfirm: () {},
        );
      });
    } else {
      CustomAlertDialog.showCustomDialog(
        context: context,
        title: '식재료 삭제 실패',
        content: '식재료 삭제를 실패하였습니다.',
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
        title: Text('나의 냉장고', style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest)),
      ),
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: fridgeItems.length,
            itemBuilder: (context, index) {
              var item = fridgeItems[index];
              return FridgeCard(
                title: item['title']!,
                expiryDate: item['expiryDate']!,
                quantity: item['quantity']!,
                imageUrl: item['imageUrl']!,
                onDelete: () => deleteIngredient(item['id']),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                text: '식재료 추가하기',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddIngredientsPage(),
                  ));
                },
                borderRadius: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
