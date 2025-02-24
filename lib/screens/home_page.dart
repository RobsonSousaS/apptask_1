import 'package:flutter/material.dart';
import '../model/task.dart';
import '../service/task_service.dart';
import '../widgets/card_widget.dart';
import '../widgets/forms_task_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> tasks = [];
  final TaskService taskService = TaskService();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    try {
      List<Task> fetchedTasks = await taskService.fetchTasks();
      setState(() {
        tasks.addAll(fetchedTasks);
      });
    } catch (e) {
      print("Error loading tasks: $e");
    }
  }

  void addTask(Task task) async {
    try {
      Task newTask = await taskService.createTask(task);
      setState(() {
        tasks.add(newTask);
      });
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  void editTask(Task updatedTask) async {
    try {
      Task updated = await taskService.updateTask(updatedTask);
      setState(() {
        final index = tasks.indexWhere((task) => task.id == updated.id);
        if (index != -1) {
          tasks[index] = updated;
        }
      });
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  void deleteTask(int index) async {
    try {
      final task = tasks[index];
      if (task.id == null) {
        print("Error: task does not have an ID.");
        return;
      }
      await taskService.deleteTask(task.id!);

      setState(() {
        tasks.removeAt(index);
      });
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  void onLevelUp(Task task) async {
    try {
      Task updatedTask = await taskService.levelUpTask(task.id!);
      setState(() {
        final index = tasks.indexWhere((t) => t.id == updatedTask.id);
        if (index != -1) {
          tasks[index] = updatedTask;
        }
      });
    } catch (e) {
      print("Error leveling up task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return CardWidget(
              task: task,
              onLevelUp: () => onLevelUp(task),
              onEdit: editTask,
              onDeleted: () => deleteTask(index),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(16),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 350,
                  padding: const EdgeInsets.all(16),
                  child: FormsTaskWidget(
                    onTaskCreated: (newTask) {
                      addTask(newTask);
                      
                    },
                  ),
                ),
              ),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
