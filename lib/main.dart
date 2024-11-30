import 'package:flutter/material.dart';
import 'views/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Tracker',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const Dashboard(),
    );
  }
}
