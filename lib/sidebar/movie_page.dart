// movie_page.dart
import 'package:flutter/material.dart';
import './movie/movie_form_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  List<Map<String, String>> movies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie List'),
      ),
      body: movies.isEmpty
          ? Center(
              child: Text(
                'Daftar Film Kosong',
                style: TextStyle(fontSize: 24),
              ),
            )
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(movies[index]['judul'] ?? ''),
                  subtitle: Text(movies[index]['link'] ?? '', style: TextStyle(color: Colors.blue)),
                  onTap: () {
                    _showMovieMenu(context, index);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieFormPage(movieData: {})),
          );

          if (result != null && result is Map<String, String>) {
            setState(() {
              movies.add(result);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showMovieMenu(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieFormPage(movieData: movies[index])),
                );

                if (result != null && result is Map<String, String>) {
                  setState(() {
                    movies[index] = result;
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(context, index);
              },
            ),
            ListTile(
              leading: Icon(Icons.open_in_browser),
              title: Text("Buka link"),
              onTap: () {
                Navigator.pop(context);
                _openMovieLink(movies[index]['link'] ?? '');
              },
            )
          ],
        );
      },
    );
  }

  void _openMovieLink(String link) async {
  if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Tidak bisa membuka $link';
  }
}

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apa anda yakin ingin menghapus Film ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  movies.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
