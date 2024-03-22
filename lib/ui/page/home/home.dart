import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';
import 'package:cook_assistant/ui/page/my_fridge/my_fridge.dart';
import 'package:cook_assistant/ui/page/community/community.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:cook_assistant/widgets/card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(viewportFraction: 1);
  double _currentPage = 0;
  final _bannerImages = ['assets/banners/banner1.webp', 'assets/banners/banner2.webp', 'assets/banners/banner3.webp'];

  @override
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
                position: _currentPage,
                decorator: DotsDecorator(
                  activeColor: AppColors.highlightDarkest,
                ),
              ),
            ),

            SizedBox(height: 32),

            _buildSectionTitle(context, '나의 냉장고', MyFridgePage()),
            _buildHorizontalList(),
            SizedBox(height: 32),

            _buildSectionTitle(context, '유저가 만든 레시피', CommunityPage()),
            _buildHorizontalList(),
            SizedBox(height: 32),

          ],
        ),
      ),

    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, Widget destinationPage) {
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
              onTap: () {
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


  Widget _buildHorizontalList() {
    return Container(
      height: 189,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5+2,
        itemBuilder: (context, index) {

          if (index == 0 || index == 6) {
            return SizedBox(width: 16);
          }

          return Container(
            width: 189,
            child: Card(
              color: AppColors.highlightLightest,
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.photo, size: 32, color: AppColors.highlightLight),
                  Text(
                    '소비기한: 00일',
                    style: AppTextStyles.bodyS.copyWith(color: AppColors.neutralDarkDarkest),
                  ),
                  Text(
                    '식재료 이름',
                    style: AppTextStyles.headingH4.copyWith(color: AppColors.neutralDarkDarkest),
                  ),
                ],
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
