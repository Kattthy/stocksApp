import 'package:flutter/material.dart';
import 'package:stock/pages/home_page.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        title: "Stocks",
        home: new Home_Page()
    );
  }
}
