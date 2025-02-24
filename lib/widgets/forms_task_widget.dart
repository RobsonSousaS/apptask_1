import 'package:flutter/material.dart';
import '../model/task.dart';

class FormsTaskWidget extends StatefulWidget {
  final Function(Task) onTaskCreated;
  final Function() onLoadTask;

  const FormsTaskWidget({super.key, required this.onTaskCreated, required this.onLoadTask});

  @override
  State<FormsTaskWidget> createState() => _FormsTaskWidgetState();
}

class _FormsTaskWidgetState extends State<FormsTaskWidget> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  int _selectedStars = 1;
  String? _starsError;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nova Tarefa',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Título é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Nivel de Dificuldade: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedStars = index + 1;
                              _starsError = null;
                            });
                          },
                          icon: Icon(
                            Icons.star,
                            color: index < _selectedStars
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                if (_starsError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _starsError!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'URL da Imagem (opcional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedStars == 0) {
                      setState(() {
                        _starsError = 'Selecione ao menos uma estrela!';
                      });
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      final newTask = Task(
                        title: _titleController.text,
                        progress: 0.0,
                        maxStars: _selectedStars,
                        imageUrl: _imageUrlController.text.isNotEmpty
                            ? _imageUrlController.text
                            : null,
                      );
                      widget.onTaskCreated(newTask);
                      widget.onLoadTask();
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Criar Tarefa',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
                
              },
            ),
          ),
        ],
      ),
    );
  }
}
