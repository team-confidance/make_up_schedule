import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/landing_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: Colors.white,
        //fontFamily: 'Nunito',
      ),
      home: Builder(
        builder: (context) => SafeArea(
          child: LandingPage(),
        ),
      ),
    );
  }
}
