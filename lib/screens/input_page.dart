import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _wordController = TextEditingController();
  final _meaningController = TextEditingController();
  final _exampleController = TextEditingController();

  // Data ko offline save karne ka function
  Future<void> _saveWord() async {
    if (_wordController.text.isEmpty || _meaningController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Word aur Meaning likhna zaroori hai!')));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? wordsString = prefs.getString('saved_words');
    List<Map<String, String>> currentWords = [];

    if (wordsString != null) {
      final List<dynamic> decoded = json.decode(wordsString);
      currentWords = decoded.map((e) => Map<String, String>.from(e)).toList();
    }

    currentWords.add({
      "word": _wordController.text,
      "meaning": _meaningController.text,
      "example": _exampleController.text,
    });

    await prefs.setString('saved_words', json.encode(currentWords));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Vocabulary'), backgroundColor: Colors.brown[700]),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _wordController, decoration: InputDecoration(labelText: 'Word / Verb', filled: true, fillColor: Colors.white)),
            SizedBox(height: 15),
            TextField(controller: _meaningController, decoration: InputDecoration(labelText: 'Hindi Meaning', filled: true, fillColor: Colors.white)),
            SizedBox(height: 15),
            TextField(controller: _exampleController, maxLines: 3, decoration: InputDecoration(labelText: 'Example Sentence', filled: true, fillColor: Colors.white)),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[800], minimumSize: Size(double.infinity, 55)),
              onPressed: _saveWord,
              child: Text('Save Offline', style: TextStyle(fontSize: 18, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
