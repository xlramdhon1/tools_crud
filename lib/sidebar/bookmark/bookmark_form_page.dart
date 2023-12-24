import 'package:flutter/material.dart';

class EditBookmarkPage extends StatefulWidget {
  final String title;
  final String link;
  final Function(String, String) onEdit;

  EditBookmarkPage({
    required this.title,
    required this.link,
    required this.onEdit,
  });

  @override
  _EditBookmarkPageState createState() => _EditBookmarkPageState();
}

class _EditBookmarkPageState extends State<EditBookmarkPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    linkController.text = widget.link;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bookmark'),
        actions: [
          IconButton(
            onPressed: () {
              _saveChanges();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Judul',
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: linkController,
              decoration: InputDecoration(
                labelText: 'Link Bookmark',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    String newTitle = titleController.text;
    String newLink = linkController.text;
    if (newTitle.isNotEmpty && newLink.isNotEmpty && newLink.startsWith('https://')) {
      widget.onEdit(newTitle, newLink);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Validasi Error'),
            content: Text('Link harus berawalan "https://" dan tidak boleh kosong'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
