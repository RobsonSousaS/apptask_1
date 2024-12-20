import 'package:flutter/material.dart';
import '../model/task.dart';
import '../widgets/card_widget.dart';
import '../widgets/forms_task_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> tasks = [
    Task("Aprender Flutter", 0, 4),
    Task("Estudar Dart", 0, 1),
  ];

  void onLevelUp(Task task) {
    setState(() {
      if (task.lvl < task.maxLevel) {
        task.lvl++;
        task.progress = task.lvl / task.maxLevel;
      }
    });
  }

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void editTask(Task updatedTask) {
    setState(() {
      final index = tasks.indexWhere((task) => task.title == updatedTask.title);
      if (index != -1) {
        tasks[index] = updatedTask;
      }
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
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
