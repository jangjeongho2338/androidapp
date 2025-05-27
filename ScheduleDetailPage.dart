import 'package:flutter/material.dart';

class ScheduleDetailPage extends StatelessWidget {
  final Map<String, String> schedule;

  ScheduleDetailPage({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("일정 상세"),
        backgroundColor: Colors.pink[100],
      ),
      backgroundColor: Colors.pink[50],
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("제목 : ${schedule['title']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text("시간 : ${schedule['start']} ~ ${schedule['end']}"),
            SizedBox(height: 8),
            Text("장소 : ${schedule['location']}"),
            SizedBox(height: 8),
            Text("내용 : ${schedule['content']}"),
          ],
        ),
      ),
    );
  }
}
