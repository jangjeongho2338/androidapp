import 'package:flutter/material.dart';

class AddSchedulePage extends StatefulWidget {
  final DateTime selectedDate;

  AddSchedulePage({required this.selectedDate});

  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController(text: "00:00");
  TextEditingController _endTimeController = TextEditingController(text: "00:00");
  TextEditingController _locationController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String dateText =
        "${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: Text("일정 추가"),
        backgroundColor: Colors.pink[100],
      ),
      backgroundColor: Colors.pink[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("제목:", style: TextStyle(fontSize: 16)),
            TextField(controller: _titleController),

            SizedBox(height: 20),
            Text("날짜 및 시간:", style: TextStyle(fontSize: 16)),
            Row(
              children: [
                Text(dateText),
                SizedBox(width: 12),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startTimeController,
                    decoration: InputDecoration(labelText: "시작 시간"),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _endTimeController,
                    decoration: InputDecoration(labelText: "종료 시간"),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            Text("장소:", style: TextStyle(fontSize: 16)),
            TextField(controller: _locationController),

            SizedBox(height: 20),
            Text("내용:", style: TextStyle(fontSize: 16)),
            TextField(
              controller: _contentController,
              maxLines: 1,
              decoration: InputDecoration(hintText: "상세 내용을 입력하세요"),
            ),

            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text("취소"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text("저장"),
                  onPressed: () {
                    if (_titleController.text.trim().isNotEmpty) {
                      Navigator.pop(context, {
                        'title': _titleController.text.trim(),
                        'start': _startTimeController.text.trim(),
                        'end': _endTimeController.text.trim(),
                        'location': _locationController.text.trim(),
                        'content': _contentController.text.trim(),
                      });
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
