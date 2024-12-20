import 'package:apptask_1/model/task.dart';
import 'package:flutter/material.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  final Function(Task) onTaskEdited;
  final Function(Task) onTaskDeleted;

  const TaskDetailPage({
    super.key,
    required this.task,
    required this.onTaskEdited,
    required this.onTaskDeleted,
  });

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _imageUrlController;
  late int _selectedStars;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _imageUrlController = TextEditingController(text: widget.task.imageUrl);
    _selectedStars = widget.task.maxStars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Tarefa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              widget.onTaskDeleted(widget.task);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'URL da Imagem'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Nível de Dificuldade: '),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedStars = index + 1;
                        });
                      },
                      icon: Icon(
                        Icons.star,
                        color:
                            index < _selectedStars ? Colors.blue : Colors.grey,
                      ),
                    );
                  }),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                widget.task.title = _titleController.text;
                widget.task.imageUrl = _imageUrlController.text;
                widget.task.maxStars = _selectedStars;
                widget.task.lvl = 0;
                widget.task.progress = 0;
                widget.onTaskEdited(widget.task);
                Navigator.of(context).pop();
              },
              child: const Text('Salvar Alterações'),
            )
          ],
        ),
      ),
    );
  }
}
