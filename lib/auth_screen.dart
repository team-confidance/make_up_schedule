import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:make_up_class_schedule/login_fragment.dart';
import 'package:make_up_class_schedule/signup_fragment.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var cornarR = 50.0;
  var btnSignUpColor = Color(0xFFFFFFFF);
  var btnLoginColor = Color(0xFFFEACB6);

  final tabs=[LoginFragment(), SignupFragment()];
  static var pos=0;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.signOut();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(left: 20, right: 20, top: 50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print("Clicked Login");
                        setState(() {
                          btnSignUpColor = Color(0xFFFFFFFF);
                          btnLoginColor = Color(0xFFFEACB6);
                          pos=0;
                        });
                      },
                      child: Container(
                        height: 70,
                        width: 130,
                        decoration: BoxDecoration(
                            color: btnLoginColor,
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(cornarR),
                                bottomLeft: Radius.circular(cornarR))),
                        child: Container(
                          child: Center(
                              child: Text(
                            "Login",
                            style:
                                TextStyle(color: Color(0xFF707070), fontSize: 24),
                          )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Clicked Signup");
                        setState(() {
                          btnSignUpColor = Color(0xFFFEACB6);
                          btnLoginColor = Color(0xFFFFFFFF);
                          pos=1;
                        });
                      },
                      child: Container(
                        height: 70,
                        width: 130,
                        decoration: BoxDecoration(
                            color: btnSignUpColor,
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(cornarR),
                                bottomRight: Radius.circular(cornarR))),
                        child: Container(
                          child: Center(
                              child: Text(
                            "Sign Up",
                            style:
                                TextStyle(color: Color(0xFF707070), fontSize: 24),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                    child: tabs[pos]
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}