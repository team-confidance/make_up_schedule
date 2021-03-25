import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/auth_screen.dart';
import 'package:make_up_class_schedule/main_screen.dart';
import 'package:make_up_class_schedule/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  SharedPreferences preferences;

  bool _isLoggedIn = false;
  bool _isLoading = true;

  void _getPreference() async {
    preferences = await SharedPreferences.getInstance();
    _isLoggedIn = preferences.getBool(Constants.isLoggedIn) ?? false;
    _isLoading = false;
  }

  @override
  void initState() {
    _getPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : (_isLoggedIn ? MainScreen() : AuthScreen());
  }
}
