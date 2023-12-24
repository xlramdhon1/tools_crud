import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './bookmark/bookmark_form_page.dart';

class Bookmark {
  final String title;
  final String link;

  Bookmark({
    required this.title,
    required this.link,
  });
}

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  List<Bookmark> bookmarks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmark'),
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
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addBookmark();
              },
              child: Text('Tambah Bookmark'),
            ),
            SizedBox(height: 16.0),
            _buildBookmarkList(),
          ],
        ),
      ),
    );
  }

  void _addBookmark() {
    String title = titleController.text;
    String link = linkController.text;
    if (title.isNotEmpty && link.isNotEmpty && link.startsWith('https://')) {
      setState(() {
        bookmarks.add(Bookmark(
          title: title,
          link: link,
        ));
        titleController.clear();
        linkController.clear();
      });
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

  Widget _buildBookmarkList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int index = 0; index < bookmarks.length; index++) ...[
          _buildBookmarkPreview(bookmarks[index], index),
          SizedBox(height: 16.0),
        ],
      ],
    );
  }

  Widget _buildBookmarkPreview(Bookmark bookmark, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${bookmark.title}',
              style: TextStyle(fontSize: 15.0),
            ),
            SizedBox(height: 8.0),
            Text(
              '${bookmark.link}',
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _editBookmark(index);
                  },
                  child: Text('Edit'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _removeBookmark(index);
                  },
                  child: Text('Hapus'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _launchURL(bookmark.link);
                  },
                  child: Text('Buka Link'),
                ),
                SizedBox(width: 8.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editBookmark(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookmarkPage(
          title: bookmarks[index].title,
          link: bookmarks[index].link,
          onEdit: (String newTitle, String newLink) {
            _updateBookmark(index, newTitle, newLink);
          },
        ),
      ),
    );
  }

  void _removeBookmark(int index) {
    setState(() {
      bookmarks.removeAt(index);
    });
  }

  void _updateBookmark(int index, String newTitle, String newLink) {
    setState(() {
      bookmarks[index] = Bookmark(
        title: newTitle,
        link: newLink,
      );
    });
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Gagal menjalankan URL'),
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