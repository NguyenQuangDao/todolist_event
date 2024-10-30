import 'package:flutter/material.dart';
import 'package:frontend/data/event_sevice.dart';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/view/event_view_detail.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventView extends StatefulWidget {
  const EventView({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  EventService eventService = EventService();
  List<EventModel> eventItems = [];
  final calendarController = CalendarController();
  dynamic calendarView = CalendarView.day;

  @override
  void initState() {
    // TODO: implement initState
    loadEventItem();
    super.initState();
  }

  Future<void> loadEventItem() async {
    final events = await eventService.getAllItemEvent();
    setState(() {
      eventItems = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Calendar'),
        actions: <Widget>[
          DropdownButton<CalendarView>(
            value: calendarView,
            onChanged: (newValue) {
              setState(() {
                calendarController.view = newValue!;
                calendarView = newValue;
              });
            },
            items: const <DropdownMenuItem<CalendarView>>[
              DropdownMenuItem(
                value: CalendarView.day,
                child: Text('Day'),
              ),
              DropdownMenuItem(
                value: CalendarView.week,
                child: Text('Week'),
              ),
              DropdownMenuItem(
                value: CalendarView.workWeek,
                child: Text('Work Week'),
              ),
              DropdownMenuItem(
                value: CalendarView.month,
                child: Text('Month'),
              ),
              DropdownMenuItem(
                value: CalendarView.schedule,
                child: Text('Schedule'),
              ),
              DropdownMenuItem(
                value: CalendarView.timelineDay,
                child: Text('timelineDay'),
              ),
              DropdownMenuItem(
                value: CalendarView.timelineMonth,
                child: Text('timelineMonth'),
              ),
              DropdownMenuItem(
                value: CalendarView.timelineWeek,
                child: Text('timelineWeek'),
              ),
              DropdownMenuItem(
                value: CalendarView.timelineWorkWeek,
                child: Text('timelineWorkWeek'),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              setState(() {
                calendarController.displayDate = DateTime.now();
              });
            },
            icon: const Icon(Icons.today_outlined),
          )
        ],
      ),
      body: SfCalendar(
        view: calendarView,
        controller: calendarController,
        showWeekNumber: true,
        // allowDragAndDrop: true,
        dataSource: MeetingDataSource(eventItems),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            final newEvent = EventModel(
              startTime: details.date!,
              endTime: details.date!.add(const Duration(hours: 1)),
              subject: "Thêm sự kiện mới",
              isAllDay: false,
            );
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return EventViewDetail(events: newEvent);
              },
            )).then((value) {
              if (value == true) {
                loadEventItem();
              }
            });
          }
        },
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<EventModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    EventModel item = appointments!.elementAt(index);
    return item.startTime;
  }

  @override
  DateTime getEndTime(int index) {
    EventModel item = appointments!.elementAt(index);
    return item.endTime!;
  }

  @override
  String getSubject(int index) {
    EventModel item = appointments!.elementAt(index);
    return item.subject;
  }

  @override
  String? getNotes(int index) {
    EventModel item = appointments!.elementAt(index);
    return item.notes;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
}

extension DateTimeExtension on DateTime {
  String toShortString() {
    return "$day/$month/$year";
  }
}
