import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'AddSchedulePage.dart';
import 'ScheduleDetailPage.dart';
import 'YearView.dart';
import 'WeekView.dart';
import 'DayView.dart';
import 'ImportantView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '일정 알리미',
      home: CalendarPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalendarPage extends StatefulWidget {

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDate = DateTime.now();
  Map<String, List<Map<String, String>>> _schedules = {};

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


  List<String> weekDays = ['일 Sun', '월 Mon', '화 Tue', '수 Wed', '목 Thu', '금 Fri', '토 Sat'];

  List<Widget> _buildCalendar(DateTime date) {
    List<Widget> dayWidgets = [];
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    int startWeekday = firstDayOfMonth.weekday % 7;
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day;

    for (var day in weekDays) {
      dayWidgets.add(Container(
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Text(
          day,
          style: TextStyle(
            fontSize: 12,
            color: day.startsWith('일') ? Colors.red : day.startsWith('토') ? Colors.blue : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }

    for (int i = 0; i < startWeekday; i++) {
      dayWidgets.add(Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey))));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(date.year, date.month, day);
      final dateKey = DateFormat('yyyy-MM-dd').format(currentDate);

      final weekday = currentDate.weekday % 7;
      final isToday = DateTime.now().year == currentDate.year &&
          DateTime.now().month == currentDate.month &&
          DateTime.now().day == currentDate.day;

      final mmdd = DateFormat('MM-dd').format(currentDate);
      final holiday = _holidays[mmdd];
      final color = (holiday != null || weekday == 0)
          ? Colors.red
          : (weekday == 6 ? Colors.blue : Colors.black);

      dayWidgets.add(
        GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddSchedulePage(selectedDate: currentDate),
              ),
            );

            if (result != null && result is Map<String, String>) {
              setState(() {
                _schedules.putIfAbsent(dateKey, () => []).add(result);
              });
            }
          },
          onLongPress: () {
            final schedules = _schedules[dateKey];

            if (schedules != null && schedules.isNotEmpty) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("${DateFormat('yyyy-MM-dd').format(currentDate)} 일정"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: schedules.map((e) => ListTile(
                      title: Text("- ${e['title']}"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ScheduleDetailPage(schedule: e),
                          ),
                        );
                      },
                    )).toList(),
                  ),
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: isToday ? Colors.yellow[200] : Colors.white,
            ),
            padding: EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$day', style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                if (holiday != null)
                  Text(holiday, style: TextStyle(fontSize: 10, color: Colors.red)),
                ...?_schedules[dateKey]?.map((event) => Text(
                  "- ${event['title']}",
                  style: TextStyle(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),

          ),
        ),
      );
    }

    return dayWidgets;
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = DateFormat('yyyy년 M월').format(_focusedDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        title: Text("일정 알리미", style: TextStyle(color: Colors.black, fontSize: 28)),
        centerTitle: true,
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.search, color: Colors.black, size: 28),
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
              onTap: () {}, // 추후 추가 가능
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('주별 달력'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WeekViewPage(
                    schedules: _schedules,
                    onAddSchedule: (dateKey, schedule) {
                      _schedules.putIfAbsent(dateKey, () => []).add(schedule);
                    },
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('일별 달력'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DayViewPage(
                    schedules: _schedules,
                    onAddSchedule: (dateKey, schedule) {
                      setState(() {
                        _schedules.putIfAbsent(dateKey, () => []).add(schedule);
                      });
                    },
                  ),
                ),
              ),
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: Icon(Icons.arrow_left), onPressed: _goToPreviousMonth),
                Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                IconButton(icon: Icon(Icons.arrow_right), onPressed: _goToNextMonth),
              ],
            ),
            SizedBox(height: 6),
            Expanded(
              child: GridView.count(
                crossAxisCount: 7,
                childAspectRatio: 0.95,
                children: _buildCalendar(_focusedDate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
