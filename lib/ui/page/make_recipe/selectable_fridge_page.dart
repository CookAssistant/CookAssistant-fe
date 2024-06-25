import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/resource/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cook_assistant/widgets/dialog.dart';
import 'selectable_fridge_card.dart';

class SelectableFridgePage extends StatefulWidget {
  final ValueChanged<List<String>> onIngredientsSelected;

  const SelectableFridgePage({Key? key, required this.onIngredientsSelected})
      : super(key: key);

  @override
  _SelectableFridgePageState createState() => _SelectableFridgePageState();
}

class _SelectableFridgePageState extends State<SelectableFridgePage> {
  List<Map<String, dynamic>> fridgeItems = [];
  List<bool> selectedItems = [];
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
        selectedItems = List<bool>.filled(fridgeItems.length, false);
        isLoading = false;
      });
    } else {
      print('Failed to load ingredients: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 냉장고',
            style: AppTextStyles.headingH4
                .copyWith(color: AppColors.neutralDarkDarkest)),
      ),
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: fridgeItems.length,
            itemBuilder: (context, index) {
              var item = fridgeItems[index];
              return SelectableFridgeCard(
                title: item['title']!,
                expiryDate: item['expiryDate']!,
                quantity: item['quantity']!,
                imageUrl: item['imageUrl']!,
                isSelected: selectedItems[index],
                onSelected: (isSelected) {
                  setState(() {
                    selectedItems[index] = isSelected ?? false;
                  });
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                text: '확인',
                onPressed: () {
                  List<String> selectedIngredients = [];
                  for (int i = 0; i < fridgeItems.length; i++) {
                    if (selectedItems[i]) {
                      selectedIngredients.add(fridgeItems[i]['title']);
                    }
                  }
                  widget.onIngredientsSelected(selectedIngredients);
                  Navigator.of(context).pop();
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
