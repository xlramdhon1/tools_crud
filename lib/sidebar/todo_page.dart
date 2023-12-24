import 'package:flutter/material.dart';

class Todo {
  String title;

  Todo({
    required this.title,
  });
}

class ToDoPage extends StatefulWidget {
  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  List<Todo> todoList = [];
  TextEditingController todoController = TextEditingController();
  TextEditingController editTodoController = TextEditingController();
  int editingIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: todoController,
              decoration: InputDecoration(
                hintText: 'Tambahkan To-Do',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _addTodo();
              },
              child: Text('Simpan'),
            ),
            SizedBox(height: 16),
            _buildTodoList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoList() {
    return Expanded(
      child: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return _buildTodoItem(index);
        },
      ),
    );
  }

  Widget _buildTodoItem(int index) {
    return ListTile(
      title: GestureDetector(
        onTap: () {
          _startEditing(index);
        },
        child: editingIndex == index
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: editTodoController,
                      onEditingComplete: () {
                        _finishEditing();
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _finishEditing();
                    },
                    child: Text('Simpan'),
                  ),
                ],
              )
            : Text(todoList[index].title),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          _removeTodo(index);
        },
        child: Text('Hapus'),
      ),
    );
  }

  void _addTodo() {
    if (todoController.text.isNotEmpty) {
      setState(() {
        todoList.add(Todo(title: todoController.text));
        todoController.clear();
      });
    }
  }

  void _removeTodo(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  void _startEditing(int index) {
    setState(() {
      editingIndex = index;
      editTodoController.text = todoList[index].title;
    });
  }

  void _finishEditing() {
    setState(() {
      todoList[editingIndex].title = editTodoController.text;
      editingIndex = -1;
      editTodoController.clear();
    });
  }
}
