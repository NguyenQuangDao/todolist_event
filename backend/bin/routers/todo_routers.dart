import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../models/todo_model.dart';

class TodoRouter {
  static final _todos = <TodoModel>[];
  Router get router {
    final router = Router();
    router.get('/todos', _getTodoHandler);
    router.post('/todos', _addTodoHandler);
    router.delete('/todos/<id>', _deleteTodoHandler);
    router.put('/todos/<id>', _updateTodoHandler);
    return router;
  }

  static final _headers = {'Content-Type': 'application/json'};

  static Future<Response> _getTodoHandler(Request req) async {
    try {
      final body = json.encode(_todos.map((todo) => todo.toMap()).toList());
      return Response.ok(body, headers: _headers);
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }

  static Future<Response> _addTodoHandler(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = json.decode(payload);
      final todo = TodoModel.fromMap(data);
      _todos.add(todo);
      return Response.ok(todo.toJson(), headers: _headers);
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }

  static Future<Response> _deleteTodoHandler(Request req, String id) async {
    try {
      final index = _todos.indexWhere((todo) => todo.id == int.parse(id));
      if (index == -1) {
        return Response.notFound('khong tim thay todo co id la: $id');
      }

      final removedTodo = _todos.removeAt(index);
      return Response.ok(removedTodo.toJson(), headers: _headers);
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }

  static Future<Response> _updateTodoHandler(Request req, String id) async {
    try {
      final index = _todos.indexWhere((todo) => todo.id == int.parse(id));
      if (index == -1) {
        return Response.notFound('khong tim thay todo co id la: $id');
      }
      final payload = await req.readAsString();
      final data = json.decode(payload);
      final updateTodo = TodoModel.fromMap(data);
      _todos[index] = updateTodo;
      return Response.ok(updateTodo.toJson(), headers: _headers);
    } catch (e) {
      return Response.internalServerError(
        body: json.encode({'error': e.toString()}),
        headers: _headers,
      );
    }
  }
}
