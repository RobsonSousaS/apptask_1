import 'package:flutter/material.dart';
import '../model/task.dart';
import '../screens/task_detail_page.dart';

class CardWidget extends StatefulWidget {
  final Task task;
  final VoidCallback onLevelUp;
  final Function(Task) onEdit;
  final Function() onDeleted;

  const CardWidget(
      {super.key,
      required this.task,
      required this.onLevelUp,
      required this.onEdit,
      required this.onDeleted});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  void _updateTask(Task updatedTask) {
    setState(() {
      _task = updatedTask;
    });
    widget.onEdit(updatedTask);
  }

  void _deleteTask(Task deleteTask) {
    setState(() {
      _task = deleteTask;
    });
    widget.onDeleted();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailPage(
                  task: _task,
                  onTaskEdited: (updatedTask) {
                    _updateTask(updatedTask);
                  },
                  onTaskDeleted: (deletedTask) {
                    _deleteTask(deletedTask);
                  },
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          image: _task.imageUrl != null &&
                                  _task.imageUrl!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(_task.imageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _task.imageUrl == null || _task.imageUrl!.isEmpty
                            ? const Icon(Icons.pie_chart,
                                size: 50, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _task.title,
                              style: TextStyle(
                                fontSize: _task.title.length > 20 ? 20 : 25,
                                fontWeight: FontWeight.w600,
                              ),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  color: index < _task.maxStars
                                      ? Colors.blue
                                      : Colors.grey,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onLevelUp,
                        child: Container(
                          height: 55,
                          width: 50,
                          decoration: BoxDecoration(
                            color: _task.lvl >= _task.maxLevel
                                ? Colors.grey
                                : Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_drop_up,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Lvl Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    border: Border.symmetric(),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 5,
                          child: LinearProgressIndicator(
                            value: _task.progress,
                            backgroundColor: Colors.blue[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 50),
                      Text(
                        'Nível: ${_task.lvl}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
