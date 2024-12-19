import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

import 'appointmentsEntry.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<String>> _appointments = {};

  void _addAppointment(String title, DateTime date) {
    setState(() {
      if (_appointments[date] == null) {
        _appointments[date] = [];
      }
      _appointments[date]?.add(title);
    });
  }

  void _editAppointment(DateTime originalDate, int index, String originalTitle) {
    DateTime editedDate = originalDate;
    TextEditingController _titleController =
        TextEditingController(text: originalTitle);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Appointment Title'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: editedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      editedDate = pickedDate;
                    });
                  }
                },
                child: Text('Change Date'),
              ),
              Text('Selected Date: ${DateFormat.yMMMd().format(editedDate)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _appointments[originalDate]?.removeAt(index);
                  if (_appointments[originalDate]?.isEmpty ?? false) {
                    _appointments.remove(originalDate);
                  }
                  if (_appointments[editedDate] == null) {
                    _appointments[editedDate] = [];
                  }
                  _appointments[editedDate]?.add(_titleController.text);
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

void _showAppointmentsForDate(DateTime date) {
  List<String>? appointments = _appointments[date];
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointments for ${DateFormat.yMMMd().format(date)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (appointments != null && appointments.isNotEmpty)
              ...appointments.asMap().entries.map(
                (entry) {
                  int index = entry.key;
                  String appointment = entry.value;

                  // Рассчитываем, сколько дней осталось до встречи.
                  DateTime now = DateTime.now();
                  DateTime startOfToday = DateTime(now.year, now.month, now.day);
                  Duration difference = date.difference(startOfToday);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(appointment),
                        subtitle: difference.inDays == 0
                            ? Text(
                                'Встреча сегодня!',
                                style: TextStyle(color: Colors.red),
                              )
                            : (difference.inDays == 1
                                ? Text(
                                    'До встречи остался 1 день',
                                    style: TextStyle(color: Colors.orange),
                                  )
                                : (difference.inDays > 1
                                    ? Text(
                                        'До встречи осталось ${difference.inDays} дней',
                                        style: TextStyle(color: Colors.green),
                                      )
                                    : null)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.pop(context);
                                _editAppointment(date, index, appointment);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                String removedAppointment =
                                    _appointments[date]![index];
                                setState(() {
                                  _appointments[date]?.removeAt(index);
                                  if (_appointments[date]?.isEmpty ?? false) {
                                    _appointments.remove(date);
                                  }
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Appointment "$removedAppointment" deleted'),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () {
                                        setState(() {
                                          if (_appointments[date] == null) {
                                            _appointments[date] = [];
                                          }
                                          _appointments[date]?.insert(
                                              index, removedAppointment);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (difference.inDays == 1)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Подготовьтесь! Завтра встреча.',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'До встречи остался 1 день.',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ).toList()
            else
              Text('No appointments for this date.'),
          ],
        ),
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CalendarCarousel(
              onDayPressed: (date, events) {
                setState(() {
                  _selectedDate = date;
                });
                _showAppointmentsForDate(date);
              },
              selectedDayButtonColor: Colors.blue,
              todayButtonColor: Colors.green,
              selectedDateTime: _selectedDate,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentEntry(
                onSave: (title, date) {
                  _addAppointment(title, date);
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
