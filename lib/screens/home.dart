import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              color: Colors.grey[300],
              child: Center(
                child: Text('광고 배너'),
              ),
            ),
            _buildSectionTitle(context, '나의 냉장고', () {}),
            _buildHorizontalList(),
            _buildSectionTitle(context, '유저가 만든 레시피', () {}),
            _buildHorizontalList(),
          ],
        ),
      ),

    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.headline6),
          GestureDetector(
            onTap: onTap,
            child: Text('더보기', style: TextStyle(color: Color(0xFF1A936F))),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.kitchen, size: 50),
                  Text('소비기한: 00일'),
                  Text('식재료 이름'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
