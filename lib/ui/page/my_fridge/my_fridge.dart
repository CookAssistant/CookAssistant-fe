import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/widgets/button/primary_button.dart';
import 'package:cook_assistant/ui/page/add_ingredients/add_ingredients.dart'; // Make sure this import is correct


class FridgeCard extends StatelessWidget {
  final String title;
  final String expiryDate;
  final String quantity;
  final String imageUrl;

  const FridgeCard({
    Key? key,
    required this.title,
    required this.expiryDate,
    required this.quantity,
    required this.imageUrl,
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
                iconSize: 20, // Set the close icon size to 20
                onPressed: () {
                  // Implement what should happen when this button is pressed
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyFridgePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> fridgeItems = [
      // Add your items here as per your existing data structure
      {
        "title": "닭고기",
        "expiryDate": "2024.03.25",
        "quantity": "400g",
        "imageUrl": "assets/images/beef.jpg",
      },
      {
        "title": "양고기",
        "expiryDate": "2024.03.25",
        "quantity": "400g",
        "imageUrl": "assets/images/beef.jpg",
      },
      {
        "title": "Beef",
        "expiryDate": "2024.03.25",
        "quantity": "400g",
        "imageUrl": "assets/images/beef.jpg",
      },
      {
        "title": "Beef",
        "expiryDate": "2024.03.25",
        "quantity": "400g",
        "imageUrl": "assets/images/beef.jpg",
      },
      {
        "title": "mushroom",
        "expiryDate": "2024.03.25",
        "quantity": "400g",
        "imageUrl": "assets/images/mushroom.jpg",
      },
      {
        "title": "Beef",
        "expiryDate": "2024.03.25",
        "quantity": "400g",
        "imageUrl": "assets/images/beef.jpg",
      },
      {
        "title": "Beef",
        "expiryDate": "2024.03.25",
        "quantity": "400g",
        "imageUrl": "assets/images/lettuce.jpg",
      },{
        "title": "쵀지고기",
        "expiryDate": "2024.03.25",
        "quantity": "400g",
        "imageUrl": "assets/images/beef.jpg",
      },{
        "title": "소고기",
        "expiryDate": "2024.03.25",
        "quantity": "400g",
        "imageUrl": "assets/images/nut.jpg",
      },{
        "title": "고기",
        "expiryDate": "2024.03.25",
        "quantity": "400g",
        "imageUrl": "assets/images/lettuce.jpg",
      },

      // Add other items similarly...
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('나의 냉장고', style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest)),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: fridgeItems.length,
            itemBuilder: (context, index) {
              var item = fridgeItems[index];
              return FridgeCard(
                title: item['title']!,
                expiryDate: item['expiryDate']!,
                quantity: item['quantity']!,
                imageUrl: item['imageUrl']!,
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