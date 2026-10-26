import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../services/api_service.dart';

final apiServiceProvider =
    Provider<ApiService>((ref) => ApiService());

final todoProvider =
    FutureProvider<List<Todo>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchTodos();
});