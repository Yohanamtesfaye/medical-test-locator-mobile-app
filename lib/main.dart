import 'package:flutter/material.dart';
import 'package:medical_test_locator/config/app_routes.dart'; // Import the routes file


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      
        title: 'Medical Test Locator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/', 
        routes: appRoutes, 
    );
  }
}
