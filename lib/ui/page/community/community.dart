import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/ui/page/recipe_detail/recipe_detail.dart';
import 'package:cook_assistant/widgets/card.dart';
import 'package:cook_assistant/ui/page/community/filter_dropdown.dart';
import 'package:cook_assistant/ui/page/community/sort_dropdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cook_assistant/resource/config.dart';

class CommunityPage extends StatefulWidget {
  final String pageTitle;
  final String initialFilterCriteria;

  const CommunityPage({
    Key? key,
    this.pageTitle = '커뮤니티',
    this.initialFilterCriteria = '모두', // 기본값 설정
  }) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late String _sortingCriteria;
  List<String> _sortingOptions = ['최신순', '좋아요순'];

  late String _filterCriteria;
  List<String> _filterOptions = ['모두', '나의 레시피', '좋아요한 레시피', '락토베지테리언', 'Gluten-Free'];

  List<dynamic> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _sortingCriteria = '최신순';
    _filterCriteria = widget.initialFilterCriteria;
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/v1/recipes/all'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Config.apiKey}',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _recipes = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // Handle the error appropriately in your application
      print('Failed to load recipes: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pageTitle,
          style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilterDropdown(
                    value: _filterCriteria,
                    options: _filterOptions,
                    onChanged: (newValue) {
                      setState(() {
                        _filterCriteria = newValue!;
                        // 필터 변경 시 로직 구현
                      });
                    },
                  ),
                  SortingDropdown(
                    value: _sortingCriteria,
                    options: _sortingOptions,
                    onChanged: (newValue) {
                      setState(() {
                        _sortingCriteria = newValue!;
                        // 정렬 변경 시 로직 구현
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(), // GridView 내부 스크롤 방지
              shrinkWrap: true, // GridView의 크기를 내용에 맞게 조절
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 2),
              ),
              itemCount: _recipes.length,
              itemBuilder: (BuildContext context, int index) {
                var recipe = _recipes[index];
                String title = recipe['title'] ?? '제목 없음';
                String subtitle = recipe['description'] ?? '설명 없음';
                String imageUrl = recipe['imageUrl'] ?? 'assets/images/mushroom.jpg';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(registered: true),
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
          ],
        ),
      ),
    );
  }
}
