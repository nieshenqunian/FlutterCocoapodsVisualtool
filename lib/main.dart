import 'package:flutter/material.dart';
import 'package:ly_cocoapods_visualtool/MainWidget/cv_mainWidgetBuilder.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CVMainWidgetBuilder(),
    );
  }
}
