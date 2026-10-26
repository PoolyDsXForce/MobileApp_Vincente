import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: todos.when(
        data: (todoList) {
          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              final todo = todoList[index];

              return CheckboxListTile(
                value: todo.completed,
                onChanged: null,
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              );
            },
          );
        },

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }
}