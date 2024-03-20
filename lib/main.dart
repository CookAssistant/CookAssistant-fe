import 'package:flutter/material.dart';
import 'package:cook_assistant/ui/page/community/community.dart';
import 'package:cook_assistant/ui/page/home/home.dart';
import 'package:cook_assistant/ui/page/make_recipe/make_recipe.dart';
import 'package:cook_assistant/ui/page/my_page/my_page.dart';
import 'package:cook_assistant/ui/theme/color.dart';
import 'package:cook_assistant/ui/theme/text_styles.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookAssistant',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: AppColors.highlightDarkest,
        splashColor: Colors.transparent,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CommunityPage(),
    RecipeCreationPage(),
    MyPage(),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '레시피 제작',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '마이페이지',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.highlightDarkest,
        unselectedItemColor: AppColors.neutralLightDark,
        selectedLabelStyle: TextStyle(color: AppColors.neutralDarkDarkest),
        unselectedLabelStyle: TextStyle(color: AppColors.neutralDarkLight),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}