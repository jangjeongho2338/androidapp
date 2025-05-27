import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YearViewPage extends StatefulWidget {

  @override
  _YearViewPageState createState() => _YearViewPageState();
}

class _YearViewPageState extends State<YearViewPage> {
  int _selectedYear = DateTime.now().year;

  void _goToPreviousYear() {
    setState(() {
      _selectedYear--;
    });
  }

  void _goToNextYear() {
    setState(() {
      _selectedYear++;
    });
  }

  Widget _buildMiniCalendar(int month) {
    final firstDay = DateTime(_selectedYear, month, 1);
    final startWeekday = firstDay.weekday % 7;
    final daysInMonth = DateTime(_selectedYear, month + 1, 0).day;
    final List<Widget> cells = [];

    // 요일 헤더
    final days = ['일', '월', '화', '수', '목', '금', '토'];
    cells.addAll(days.map((d) => Center(
      child: Text(d,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: d == '일'
                  ? Colors.red
                  : d == '토'
                  ? Colors.blue
                  : Colors.black)),
    )));

    // 빈칸
    for (int i = 0; i < startWeekday; i++) {
      cells.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_selectedYear, month, day);
      final color = date.weekday == 7
          ? Colors.red
          : date.weekday == 6
          ? Colors.blue
          : Colors.black;

      cells.add(Container(
        alignment: Alignment.topLeft,
        child: Text(
          '$day',
          style: TextStyle(fontSize: 10, color: color),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${month}월', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: GridView.count(
            crossAxisCount: 7,
            padding: EdgeInsets.all(4),
            physics: NeverScrollableScrollPhysics(),
            children: cells,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text("연도별 달력", style: TextStyle(color: Colors.black, fontSize: 24)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: Icon(Icons.arrow_left), onPressed: _goToPreviousYear),
                Text('${_selectedYear}년',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                IconButton(icon: Icon(Icons.arrow_right), onPressed: _goToNextYear),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 0.9,
              padding: EdgeInsets.all(8),
              children: List.generate(12, (index) => _buildMiniCalendar(index + 1)),
            ),
          ),
        ],
      ),
    );
  }
}
