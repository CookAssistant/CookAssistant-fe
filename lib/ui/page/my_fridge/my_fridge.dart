import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/widgets/card.dart';

class MyFridgePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> fridgeItems = [
      {
        "title": "소고기",
        "subtitle": "소비기한 : 2024.03.25\n400 g",
        "imageUrl": "assets/images/beef.jpg", // 이미지 경로는 실제와 다를 수 있습니다.
      },
      {
        "title": "양상추",
        "subtitle": "소비기한 : 2024.05.14\n1 kg",
        "imageUrl": "assets/images/lettuce.jpg", // 이미지 경로는 실제와 다를 수 있습니다.
      },
      {
        "title": "버섯",
        "subtitle": "소비기한 : 2024.05.14\n1 kg",
        "imageUrl": "assets/images/mushroom.jpg", // 이미지 경로는 실제와 다를 수 있습니다.
      },
      {
        "title": "호두",
        "subtitle": "소비기한 : 2024.05.14\n1 kg",
        "imageUrl": "assets/images/nut.jpg", // 이미지 경로는 실제와 다를 수 있습니다.
      },
      {
        "title": "적양파",
        "subtitle": "소비기한 : 2024.05.14\n1 kg",
        "imageUrl": "assets/images/red_onion.jpg", // 이미지 경로는 실제와 다를 수 있습니다.
      },
      // ... 나머지 아이템들도 이와 비슷하게 추가...
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('나의 냉장고', style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest)),
      ),
      body: ListView.builder(
        itemCount: fridgeItems.length,
        itemBuilder: (context, index) {
          // fridgeItems 리스트에서 각 아이템의 데이터를 가져옵니다.
          var item = fridgeItems[index];

          return CustomCard(
            title: item['title']!,
            subtitle: item['subtitle']!,
            imageUrl: item['imageUrl']!,
          );
        },
      ),
    );
  }
}