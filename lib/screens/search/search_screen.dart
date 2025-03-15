import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Search', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF007AFF),
      ),
      body: Center(
        child: Text('Search Page', style: TextStyle(fontSize: 22)),
      ),
    );
  }
}
