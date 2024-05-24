import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/ui/page/my_fridge/my_fridge.dart';
import 'package:cook_assistant/ui/page/community/community.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:cook_assistant/widgets/card.dart';
import 'package:cook_assistant/widgets/default_card.dart';
import 'package:cook_assistant/ui/page/recipe_detail/recipe_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cook_assistant/resource/config.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToPage;
  HomeScreen({Key? key, this.onNavigateToPage}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(viewportFraction: 1);
  double _currentPage = 0;
  final _bannerImages = ['assets/banners/banner1.webp', 'assets/banners/banner2.webp', 'assets/banners/banner3.webp'];
  List<dynamic> _recipes = [];
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!;
        });
      }
    });
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      print("recipe load started");
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/api/v1/recipes/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Config.apiKey}',
        },
      );

      if (response.statusCode == 200) {
        print("recipes loaded");
        setState(() {
          _recipes = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CookAssistant',
          style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _bannerImages.length,
                itemBuilder: (context, index) => Image.asset(
                  _bannerImages[index],
                  fit: BoxFit.cover,
                ),
                physics: ClampingScrollPhysics(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DotsIndicator(
                dotsCount: _bannerImages.length,
                position: _currentPage.round(),
                decorator: DotsDecorator(
                  activeColor: AppColors.highlightDarkest,
                ),
              ),
            ),
            SizedBox(height: 32),
            _buildSectionTitle(context, '나의 냉장고', MyFridgePage()),
            _buildHorizontalListForFridge(),
            SizedBox(height: 32),
            _buildSectionTitle(context, '유저들이 만든 레시피', CommunityPage(pageTitle: '커뮤니티'),
                onTap: () {
                  widget.onNavigateToPage?.call(1);
                }),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _recipes.isEmpty
                ? _buildHorizontalListForRecipe()
                : _buildHorizontalListForRecipeFromAPI(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, Widget destinationPage, {Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
          ),
          GestureDetector(
            onTap: onTap ?? () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => destinationPage));
            },
            child: Text(
              '더보기',
              style: AppTextStyles.actionM.copyWith(color: AppColors.highlightDarkest),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListForRecipe() {
    return Container(
      height: 189,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5 + 2,
        itemBuilder: (context, index) {
          if (index == 0 || index == 6) {
            return SizedBox(width: 16);
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailPage(registered: true, userId: 16, recipeId: 1),
                ),
              );
            },
            child: SizedBox(
              width: 189,
              height: 189,
              child: CustomCard(
                title: '임시타이틀',
                subtitle: '부제목',
                imageUrl: 'assets/images/red_onion.jpg',
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 8),
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  Widget _buildHorizontalListForRecipeFromAPI() {
    final latestRecipes = _recipes.reversed.take(5).toList();
    return Container(
      height: 189,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: latestRecipes.length + 2,
        itemBuilder: (context, index) {
          if (index == 0 || index == latestRecipes.length + 1) {
            return SizedBox(width: 16);
          }
          var recipe = latestRecipes[index - 1];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailPage(registered: true,
                    userId: recipe['userId'],
                    recipeId: recipe['recipeId'],),
                ),
              );
            },
            child: SizedBox(
              width: 189,
              height: 189,
              child: CustomCard(
                title: recipe['name'] ?? '제목 없음',
                subtitle: recipe['content'] ?? '설명 없음',
                imageUrl: recipe['imageURL'] ?? 'assets/images/red_onion.jpg',
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 8),
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  Widget _buildHorizontalListForFridge() {
    return Container(
      height: 189,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5 + 2,
        itemBuilder: (context, index) {
          if (index == 0 || index == 6) {
            return SizedBox(width: 16);
          }
          return GestureDetector(
            child: SizedBox(
              width: 189,
              height: 189,
              child: CustomCard(
                title: '소비기한 : 2024.04.15',
                subtitle: '스팸 2캔',
                imageUrl: 'assets/images/mushroom.jpg',
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 8),
        physics: ClampingScrollPhysics(),
      ),
    );
  }
}
