import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/ui/page/recipe_detail/recipe_detail.dart';
import 'package:cook_assistant/widgets/card.dart';
import 'package:cook_assistant/ui/page/community/filter_dropdown.dart';
import 'package:cook_assistant/ui/page/community/sort_dropdown.dart';


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

  @override
  void initState() {
    super.initState();
    _sortingCriteria = '최신순';
    _filterCriteria = widget.initialFilterCriteria;
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
      body: SingleChildScrollView(
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
          ],
        ),
      ),
    );
  }
}