import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apptask_1/model/task.dart';

class TaskService {
  final String baseUrl = "http://localhost:8080/tasks";

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'title': task.title,
        'progress': task.progress,
        'maxStars': task.maxStars,
        'imageUrl': task.imageUrl,
      }),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<Task> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${task.id}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'title': task.title,
        'progress': task.progress,
        'maxStars': task.maxStars,
        'imageUrl': task.imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  Future<Task> levelUpTask(int taskId) async {
    final url = Uri.parse('$baseUrl/tasks/$taskId/level-up');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return Task.fromJson(
            json.decode(response.body));
      } else {
        throw Exception('Failed to level up task');
      }
    } catch (e) {
      print("Error leveling up task: $e");
      rethrow;
    }
  }
}
