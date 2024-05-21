import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/ui/page/add_ingredients/add_ingredients.dart'; // Make sure this import is correct
import 'package:cook_assistant/resource/config.dart'; // Ensure this import is correct

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
              Image.asset(
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
                      quantity,
                      style: AppTextStyles.bodyM.copyWith(color: AppColors.neutralDarkDarkest),
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
    final int userId = 1;
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/v1/ingredients/all/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Config.apiKey}',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> ingredients = json.decode(response.body);
      setState(() {
        fridgeItems = ingredients.map((ingredient) {
          return {
            "id": ingredient['id'],
            "title": ingredient['name'] ?? 'Unknown',
            "expiryDate": ingredient['expirationDate'] ?? 'Unknown',
            "quantity": ingredient['quantity'] ?? 'Unknown',
            "imageUrl": 'assets/images/nut.jpg',
          };
        }).toList();
        isLoading = false;
      });
    } else {
      // Handle error appropriately in your application
      print('Failed to load ingredients: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteIngredient(int ingredientId) async {
    final int userId = 1;
    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/api/v1/ingredients/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Config.apiKey}',
      },
      body: jsonEncode({
        'userId': userId,
        'ingredientId': ingredientId,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        fridgeItems.removeWhere((item) => item['id'] == ingredientId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('식재료가 성공적으로 삭제되었습니다.')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('식재료 삭제에 실패했습니다. 상태 코드: ${response.statusCode}')),
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
              padding: const EdgeInsets.all(16.0), // Adjust padding as needed
              child: PrimaryButton(
                text: '식재료 추가하기',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddIngredientsPage(), // Ensure that you have AddIngredientsPage class defined in the imported file
                  ));
                },
                borderRadius: 12.0, // Optional, adjust as per your design
              ),
            ),
          ),
        ],
      ),
    );
  }
}
