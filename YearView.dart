import 'package:flutter/material.dart';

class YearViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('연도별 달력')),
      body: Center(child: Text('연도별 보기 페이지')),
    );
  }
}