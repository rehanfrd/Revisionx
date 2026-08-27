import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'input_page.dart';

class BookViewScreen extends StatefulWidget {
  @override
  _BookViewScreenState createState() => _BookViewScreenState();
}

class _BookViewScreenState extends State<BookViewScreen> {
  List<Map<String, String>> dailyWords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  // Offline data fetch karne ka function
  Future<void> loadWords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? wordsString = prefs.getString('saved_words');
    if (wordsString != null) {
      final List<dynamic> decoded = json.decode(wordsString);
      setState(() {
        dailyWords = decoded.map((e) => Map<String, String>.from(e)).toList();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Revision Book', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.brown[800],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : dailyWords.isEmpty
              ? Center(
                  child: Text(
                    "Abhi koi word save nahi kiya hai.\nNeeche + button dabayein.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.brown[600]),
                  ),
                )
              : PageView.builder(
                  itemCount: dailyWords.length,
                  itemBuilder: (context, index) {
                    // Sabse naye words sabse pehle dikhane ke liye reverse kiya
                    final item = dailyWords[dailyWords.length - 1 - index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
                        border: Border.all(color: Colors.brown.withOpacity(0.2)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item["word"] ?? "", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.brown[900])),
                          Divider(color: Colors.brown[300], thickness: 2, height: 40),
                          Text("Meaning:", style: TextStyle(fontSize: 16, color: Colors.brown[600])),
                          SizedBox(height: 5),
                          Text(item["meaning"] ?? "", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                          SizedBox(height: 30),
                          Text("Example:", style: TextStyle(fontSize: 16, color: Colors.brown[600])),
                          SizedBox(height: 5),
                          Text('"${item["example"] ?? ""}"', style: TextStyle(fontSize: 20, height: 1.5, fontStyle: FontStyle.italic, color: Colors.black87)),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown[700],
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => InputPage()));
          loadWords(); // Wapas aane par list ko refresh karega
        },
      ),
    );
  }
}
