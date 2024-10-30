import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/todo_model.dart';
import 'package:frontend/view/event_view.dart';
import 'package:http/http.dart' as http;

String getBackendUrl() {
  if (kIsWeb) {
    return 'http://localhost:8092';
  } else if (Platform.isAndroid) {
    return 'http://10.0.2.2:8092';
  } else {
    return 'http://localhost:8092';
  }
}

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final _todos = <TodoModel>[];
  final _controller = TextEditingController();
  final apiUrl = '${getBackendUrl()}/api/v1/todos';
  final _headers = {'Content-Type': 'application/json'};
  Future<void> _fetchTodos() async {
    try {
      final res = await http.get(Uri.parse(apiUrl));
      if (res.statusCode == 200) {
        final List<dynamic> todoList = json.decode(res.body);
        setState(() {
          _todos.clear();
          _todos.addAll(todoList.map((e) => TodoModel.fromMap(e)).toList());
        });
      } else {
        if (kDebugMode) {
          print('Error fetching todos: ${res.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }
  }

  Future<void> _addToDo() async {
    if (_controller.text.isEmpty) return;
    final newItem = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _controller.text,
      complete: false,
    );
    final res = await http.post(
      Uri.parse(apiUrl),
      headers: _headers,
      body: json.encode(newItem.toMap()),
    );
    if (res.statusCode == 200) {
      _controller.clear();
      await _fetchTodos();
    }
  }

  Future<void> _updateToDo(TodoModel item) async {
    item.complete = !item.complete;
    final res = await http.put(
      Uri.parse(apiUrl),
      headers: _headers,
      body: json.encode(item.toMap()),
    );

    if (res.statusCode == 200) {
      await _fetchTodos();
    }
  }

  Future<void> _deleteToDo(int id) async {
    final res = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );

    if (res.statusCode == 200) {
      await _fetchTodos();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Text(
              'Nguyễn Quang Đạo - 2121050451',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Center(
              child: Text(
                'Thêm ghi chú',
              ),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'nhập todo'),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => _addToDo(),
              child: const Text('Gửi'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos.elementAt(index);
                  return ListTile(
                    title: Text(todo.title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteToDo(todo.id),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventView()),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
