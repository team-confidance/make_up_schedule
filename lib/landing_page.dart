import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/auth_screen.dart';
import 'package:make_up_class_schedule/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final Future<SharedPreferences> _preference = SharedPreferences.getInstance();

  bool _isLoggedIn = false;
  SharedPreferences preferences;

  void _getPreference() async{
    preferences = await _preference;
    _isLoggedIn = preferences.getInt('isLoggedIn') ?? false;
  }
  @override
  void initState(){
    Firebase.initializeApp();
    _getPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? MainScreen() : AuthScreen();
  }
}