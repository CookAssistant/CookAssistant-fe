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
import 'package:shared_preferences/shared_preferences.dart';

class CommunityPage extends StatefulWidget {
  final String pageTitle;
  final String initialFilterCriteria;

  const CommunityPage({
    Key? key,
    this.pageTitle = '커뮤니티',
    this.initialFilterCriteria = '모두',
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
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _sortingCriteria = '최신순';
    _filterCriteria = widget.initialFilterCriteria;
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken != null && accessToken.isNotEmpty && accessToken != 'guest') {
      try {
        var url = Uri.parse('${Config.baseUrl}/api/v1/users/myPage');
        var response = await http.get(url, headers: {
          'Authorization': 'Bearer $accessToken',
        });


        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${utf8.decode(response.bodyBytes)}');

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
          setState(() {
            userId = jsonResponse['data']['userId'];
          });
          fetchRecipes(accessToken);
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error fetching user details: $e');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchRecipes(String accessToken) async {
    String endpoint = '${Config.baseUrl}/api/v1/recipes/all';
    if (_filterCriteria == '나의 레시피') {
      endpoint = '${Config.baseUrl}/api/v1/recipes/all/$userId';
    } else if (_filterCriteria == '좋아요한 레시피') {
      endpoint = '${Config.baseUrl}/api/v1/recipes/likes/$userId';
    }

    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );


      String responseBody = utf8.decode(response.bodyBytes);
      print(responseBody);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseBody);
        List<dynamic> recipes = jsonResponse['data'];

        if (_sortingCriteria == '최신순') {
          recipes.sort((a, b) {
            DateTime dateA = DateTime(a['createdAt'][0], a['createdAt'][1], a['createdAt'][2], a['createdAt'][3], a['createdAt'][4], a['createdAt'][5], a['createdAt'][6]);
            DateTime dateB = DateTime(b['createdAt'][0], b['createdAt'][1], b['createdAt'][2], b['createdAt'][3], b['createdAt'][4], b['createdAt'][5], b['createdAt'][6]);
            return dateB.compareTo(dateA);
          });
        } else if (_sortingCriteria == '좋아요순') {
          recipes.sort((a, b) => b['likes'].compareTo(a['likes']));
        }

        setState(() {
          _recipes = recipes;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching recipes: $e');
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
                        _isLoading = true;
                        SharedPreferences.getInstance().then((prefs) {
                          String? accessToken = prefs.getString('accessToken');
                          if (accessToken != null && accessToken.isNotEmpty) {
                            fetchRecipes(accessToken);
                          }
                        });
                      });
                    },
                  ),
                  SortingDropdown(
                    value: _sortingCriteria,
                    options: _sortingOptions,
                    onChanged: (newValue) {
                      setState(() {
                        _sortingCriteria = newValue!;
                        _isLoading = true;
                        SharedPreferences.getInstance().then((prefs) {
                          String? accessToken = prefs.getString('accessToken');
                          if (accessToken != null && accessToken.isNotEmpty) {
                            fetchRecipes(accessToken);
                          }
                        });
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
                String title = recipe['name'] ?? '제목 없음';
                String subtitle = recipe['content'] ?? '설명 없음';
                String imageUrl = recipe['imageURL'] ?? 'assets/images/mushroom.jpg';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(
                          registered: true,
                          recipeId: recipe['recipeId'],
                        ),
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
