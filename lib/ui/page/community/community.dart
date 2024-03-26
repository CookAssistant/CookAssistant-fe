import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/ui/page/recipe_detail/recipe_detail.dart';
import 'package:cook_assistant/widgets/card.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '커뮤니티',
          style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 2),
          ),
          itemCount: 17,
          itemBuilder: (BuildContext context, int index) {
            String title = '락토베지테리언${index + 1}';
            String subtitle = '돼지고기 김치찌개${index + 1}';
            String imageUrl = 'assets/images/mushroom.jpg';

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailPage(),
                  ),
                );
              },
              child: CustomCard(
                title: title,
                subtitle: subtitle,
                imageUrl: imageUrl,
              ),
            );
          },
        ),
      ),
    );
  }
}