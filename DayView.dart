import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'AddSchedulePage.dart';
import 'ScheduleDetailPage.dart';
import 'YearView.dart';
import 'WeekView.dart';
import 'ImportantView.dart';

class DayViewPage extends StatefulWidget {
  final Map<String, List<Map<String, String>>> schedules;

  final Map<String, String> _holidays = {
    '01-01': '신정',
    '03-01': '삼일절',
    '05-05': '어린이날',
    '06-06': '현충일',
    '08-15': '광복절',
    '10-03': '개천절',
    '10-09': '한글날',
    '12-25': '성탄절',
  };

  final Function(String, Map<String, String>) onAddSchedule;

  DayViewPage({required this.schedules, required this.onAddSchedule});

  @override
  _DayViewPageState createState() => _DayViewPageState();
}

class _DayViewPageState extends State<DayViewPage> {
  DateTime _selectedDate = DateTime.now();

  void _goToPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 1));
    });
  }

  void _goToNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = DateFormat('M월 d일').format(_selectedDate);
    final dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final daySchedules = widget.schedules[dateKey] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text('일정 알리미', style: TextStyle(color: Colors.black, fontSize: 24)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink[100]),
              child: Text('달력 옵션', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('연도별 달력'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => YearViewPage())),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('월별 달력'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/'); // ← main.dart 기본 홈으로 이동
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('주별 달력'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WeekViewPage(schedules: widget.schedules, onAddSchedule: widget.onAddSchedule))),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('일별 달력'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('주요 일정 보기'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ImportantViewPage())),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: Icon(Icons.arrow_left), onPressed: _goToPreviousDay),
                Text('$title 주요 일정', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(icon: Icon(Icons.arrow_right), onPressed: _goToNextDay),
              ],
            ),
            Divider(thickness: 1),
            Expanded(
              child: daySchedules.isEmpty
                  ? Center(child: Text("오늘 등록된 일정이 없습니다.", style: TextStyle(fontSize: 16)))
                  : ListView.builder(
                itemCount: daySchedules.length,
                itemBuilder: (context, index) {
                  final item = daySchedules[index];
                  return ListTile(
                    title: Text("- ${item['title']}", style: TextStyle(fontSize: 16)),
                    subtitle: item['time'] != null ? Text(item['time']!) : null,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScheduleDetailPage(schedule: item),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[200],
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddSchedulePage(selectedDate: _selectedDate),
            ),
          );

          if (result != null && result is Map<String, String>) {
            widget.onAddSchedule(dateKey, result);
            setState(() {});
          }
        },
      ),
    );
  }
}
