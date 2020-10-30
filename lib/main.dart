import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/ui/DetailsPage.dart';
import 'package:flutter_hacker_news/ui/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:HomePage()
    );
  }
}