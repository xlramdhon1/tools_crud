import 'package:flutter/material.dart';
import './contact/contact_form_page.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Map<String, String>> contacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kontak'),
      ),
      body: contacts.isEmpty
          ? Center(
              child: Text(
                'Daftar Kontak Kosong',
                style: TextStyle(fontSize: 24),
              ),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(contacts[index]['nama'] ?? ''),
                  subtitle: Text(contacts[index]['nomor'] ?? ''),
                  onTap: () {
                    _showContactMenu(context, index);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactFormPage(contactData: {})),
          );

          if (result != null && result is Map<String, String>) {
            setState(() {
              contacts.add(result);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showContactMenu(BuildContext context, int index) {
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
                  MaterialPageRoute(builder: (context) => ContactFormPage(contactData: contacts[index])),
                );

                if (result != null && result is Map<String, String>) {
                  setState(() {
                    contacts[index] = result;
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Hapus'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(context, index);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus kontak ini?'),
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
                  contacts.removeAt(index);
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
