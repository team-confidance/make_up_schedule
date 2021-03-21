import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/auth_screen.dart';
import 'package:make_up_class_schedule/home_screen.dart';
import 'package:make_up_class_schedule/notification_screen.dart';
import 'package:make_up_class_schedule/routine_screen.dart';
import 'package:make_up_class_schedule/settings_screen.dart';
import 'package:make_up_class_schedule/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String s = "Home";
  var titles = ["Home", "Routine", "Settings"];
  final tabs = [
    HomeScreen(),
    RoutineScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var selColor = Color(0xFFFEACB6);
    var deselColor = Color(0xFFE4ECF1);

    return Scaffold(
      appBar: AppBar(
        title: Text(s),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                print("Clicked on Notification");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationScreen()));
              }),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              var sharedPref = await SharedPreferences.getInstance();
              sharedPref.setBool(Constants.isLoggedIn, false);
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => AuthScreen(),
                ),
                    (route) => false,//if you want to disable back feature set to false
              );
            },
          ),
        ],
      ),
      body: PageStorage(
        child: tabs[_currentIndex],
        bucket: PageStorageBucket(),
      ),
      /*body: tabs[_currentIndex],*/
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.ballot,
          color: _currentIndex == 1 ? selColor : deselColor,
        ),
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          setState(() {
            _currentIndex = 1;
            s = titles[_currentIndex];
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Color(0x54000000), blurRadius: 10)]),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 6,
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                          s = titles[_currentIndex];
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.badge,
                            color: _currentIndex == 0 ? selColor : deselColor,
                          ),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: _currentIndex == 0 ? selColor : deselColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Right Tab bar icons

                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          _currentIndex = 2;
                          s = titles[_currentIndex];
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            color: _currentIndex == 2 ? selColor : deselColor,
                          ),
                          Text(
                            'Profile',
                            style: TextStyle(
                              color: _currentIndex == 2 ? selColor : deselColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
