import 'package:flutter/material.dart';

class ContactFormPage extends StatefulWidget {
  final Map<String, String> contactData;

  ContactFormPage({Key? key, required this.contactData}) : super(key: key);

  @override
  _ContactFormPageState createState() => _ContactFormPageState();
}

class _ContactFormPageState extends State<ContactFormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.contactData['nama'] ?? '';
    numberController.text = widget.contactData['nomor'] ?? '';
    emailController.text = widget.contactData['email'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Kontak'),
        actions: [
          GestureDetector(
            onTap: () {
              final newContact = {
                'nama': nameController.text,
                'nomor': numberController.text,
                'email': emailController.text,
              };
              Navigator.pop(context, newContact);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Simpan', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: numberController,
              decoration: InputDecoration(labelText: 'Nomor'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
