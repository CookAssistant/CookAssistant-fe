import 'package:flutter/material.dart';

class RecipeCreationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Image.network('https://placeimg.com/640/480/food'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '나에게 맞는 레시피를 만들어 보세요',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '원하는 식단, 재료로 기존 웹 페이지의 레시피를 사용자에 맞게 변환합니다.',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // 음성으로 시작하기 로직
              },
              child: Text('음성으로 시작하기'),
              style: ElevatedButton.styleFrom(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () {
                // 텍스트로 시작하기 로직
              },
              child: Text('텍스트로 시작하기'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFF1A936F)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
