import 'package:flutter/material.dart';
import 'screens/book_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(VocabRevisionApp());
}

class VocabRevisionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Revision Book',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFF4ECD8), // Kitab jaisa background
        fontFamily: 'Georgia',
      ),
      home: BookViewScreen(),
    );
  }
}
