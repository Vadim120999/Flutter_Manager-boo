import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:intl/intl.dart';

class AppointmentList extends StatelessWidget {
  final VoidCallback onTapAdd;

  AppointmentList({required this.onTapAdd});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onTapAdd,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: CalendarCarousel(
              onDayPressed: (DateTime date, List<dynamic> events) {
                showBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Appointments for ${DateFormat.yMMMd().format(date)}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
              weekendTextStyle: TextStyle(color: Colors.red),
              selectedDayButtonColor: Colors.blue,
              todayButtonColor: Colors.green,
              daysHaveCircularBorder: true,
            ),
          ),
        ],
      ),
    );
  }
}
