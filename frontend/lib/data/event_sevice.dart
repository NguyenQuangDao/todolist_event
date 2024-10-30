import 'package:frontend/models/event_model.dart';
import 'package:localstore/localstore.dart';

class EventService {
  final db = Localstore.getInstance(useSupportDir: true);
  // tên collection trong Localstore
  final path = 'events';
  // hàm lấy danh sách sự kiện từ localstore
  Future<List<EventModel>> getAllItemEvent() async {
    final eventsMap = await db.collection(path).get();
    if (eventsMap != null) {
      return eventsMap.entries.map((entry) {
        final eventData = entry.value as Map<String, dynamic>;
        if (!eventData.containsKey('id')) {
          eventData['id'] = entry.key.split('/').last;
        }
        return EventModel.fromMap(eventData);
      }).toList();
    }
    return [];
  }

  Future<void> saveEvents(EventModel item) async {
    //  nếu id không tồn tại hoặc tạo mới thì lấy 1 id ngẫu nhiên
    item.id ??= db.collection(path).doc().id;
    await db.collection(path).doc(item.id).set(item.toMap());
  }

  Future<void> deleteEvents(EventModel item) async {
    await db.collection(path).doc(item.id).delete();
  }
}
