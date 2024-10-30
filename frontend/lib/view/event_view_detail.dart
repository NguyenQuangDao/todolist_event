import 'package:flutter/material.dart';
import 'package:frontend/data/event_sevice.dart';
import 'package:frontend/models/event_model.dart';

class EventViewDetail extends StatefulWidget {
  final EventModel events;

  const EventViewDetail({super.key, required this.events});

  @override
  State<EventViewDetail> createState() => _EventViewDetailState();
}

class _EventViewDetailState extends State<EventViewDetail> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController eventController = TextEditingController();
    final subController = TextEditingController();
    final notesController = TextEditingController();
    final eventService = EventService();
    @override
    void initState() {
      subController.text = widget.events.subject;
      notesController.text = widget.events.notes!;
      super.initState();
    }

    Future<void> _pickDateTime({required bool isStart}) async {
      // Chọn ngày
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: isStart ? widget.events.startTime : widget.events.endTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null) {
        // Chọn giờ
        if (!mounted) return;
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(isStart
              ? widget.events.startTime
              : widget.events.endTime as DateTime),
        );

        if (pickedTime != null) {
          setState(() {
            final newDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedDate.hour,
              pickedDate.minute,
            );
            if (isStart) {
              widget.events.startTime = newDateTime;
              if (widget.events.startTime
                  .isAfter(widget.events.endTime as DateTime)) {
                widget.events.endTime =
                    widget.events.startTime.add(const Duration(hours: 1));
              }
            }
          });
        }
      }
    }

    Future<void> saveEvent() async {
      widget.events.subject = subController.text;
      widget.events.notes = notesController.text;
      print(widget.events);
      await eventService.saveEvents(widget.events);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }

    Future<void> _deleteEvent() async {
      await eventService.deleteEvents(widget.events);
      Navigator.of(context).pop(true);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin sự kiện'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: eventController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Sự kiện cả ngày'),
                trailing: Switch(
                  value: widget.events.isAllDay,
                  onChanged: (value) {
                    setState(() {
                      widget.events.isAllDay = value;
                    });
                  },
                ),
              ),
              if (!widget.events.isAllDay) ...[
                const SizedBox(height: 20),
                ListTile(
                  title:
                      Text('Bắt đầu: ${widget.events.formatedStartTimeString}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () {
                    _pickDateTime(isStart: true);
                  },
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: Text(
                      'Kết thúc: ${widget.events.formatedStartTimeString}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () {
                    _pickDateTime(isStart: false);
                  },
                ),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                      labelText: 'Ghi chú sự kiện', hintMaxLines: 4),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (widget.events.id != null) ...[
                      FilledButton.tonalIcon(
                          onPressed: _deleteEvent,
                          label: const Text('Xóa sự kiện'))
                    ] else ...[
                      FilledButton.tonalIcon(
                          onPressed: saveEvent,
                          label: const Text('Lưu sự kiện'))
                    ]
                  ],
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
