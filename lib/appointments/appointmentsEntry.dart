import 'package:flutter/material.dart';

class AppointmentEntry extends StatefulWidget {
  final Function(String, DateTime) onSave;

  AppointmentEntry({required this.onSave});

  @override
  _AppointmentEntryState createState() => _AppointmentEntryState();
}

class _AppointmentEntryState extends State<AppointmentEntry> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Appointment Title'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'No date chosen'
                      : 'Picked Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: Text('Pick Date'),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                if (_titleController.text.isNotEmpty && _selectedDate != null) {
                  widget.onSave(
                    _titleController.text,
                    _selectedDate!,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a title and pick a date!'),
                    ),
                  );
                }
              },
              icon: Icon(Icons.save),
              label: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
