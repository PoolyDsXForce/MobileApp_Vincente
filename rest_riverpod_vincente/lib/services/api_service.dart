import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class ApiService {
  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos'),
    );

    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);

      return jsonData
          .map((todo) => Todo.fromJson(todo))
          .toList();
    }

    throw Exception('Failed to load todos');
  }
}