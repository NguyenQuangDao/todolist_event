// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EventModel {
  String? id;
  DateTime startTime;
  DateTime? endTime;
  bool isAllDay;
  String subject;
  String? notes;
  String? recurrentRule;
  EventModel({
    this.id,
    required this.startTime,
    this.endTime,
    required this.isAllDay,
    required this.subject,
    this.notes,
    this.recurrentRule,
  });

  EventModel copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    String? subject,
    String? notes,
    String? recurrentRule,
  }) {
    return EventModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      subject: subject ?? this.subject,
      notes: notes ?? this.notes,
      recurrentRule: recurrentRule ?? this.recurrentRule,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'isAllDay': isAllDay,
      'subject': subject,
      'notes': notes,
      'recurrentRule': recurrentRule,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] != null ? map['id'] as String : null,
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: map['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int)
          : null,
      isAllDay: map['isAllDay'] as bool,
      subject: map['subject'] as String,
      notes: map['notes'] != null ? map['notes'] as String : null,
      recurrentRule:
          map['recurrentRule'] != null ? map['recurrentRule'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventModel(id: $id, startTime: $startTime, endTime: $endTime, isAllDay: $isAllDay, subject: $subject, notes: $notes, recurrentRule: $recurrentRule)';
  }

  @override
  bool operator ==(covariant EventModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.isAllDay == isAllDay &&
        other.subject == subject &&
        other.notes == notes &&
        other.recurrentRule == recurrentRule;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        isAllDay.hashCode ^
        subject.hashCode ^
        notes.hashCode ^
        recurrentRule.hashCode;
  }
}

extension ExtEventModel on EventModel {
  String get formatedStartTimeString =>
      "${startTime.hour}:${startTime.minute}, ${startTime.day}/${startTime.month}/${startTime.year}";
  String get formatedEndTimeString =>
      "${endTime?.hour}:${endTime?.minute}, ${endTime?.day}/${endTime?.month}/${endTime?.year}";
}
