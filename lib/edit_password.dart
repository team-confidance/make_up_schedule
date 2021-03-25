import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_up_class_schedule/auth_screen.dart';
import 'package:make_up_class_schedule/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPassword extends StatefulWidget {
  final String currentPassword, firebaseKey;
  final Function sendCallBack;
  EditPassword({this.currentPassword, this.firebaseKey, this.sendCallBack, Key key}) : super(key: key);
  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  var changedPassword = "", changedConfirmPassword = "", currentPasswordField = "";
  var isChagedPassword = false, isCurrentPasswordRight = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Change Password"),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                height: 70,
                width: double.infinity,
                margin:
                    EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 80),
                decoration: BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    border: Border.all(color: Color(0xFF376D28)),
                    borderRadius: BorderRadius.all(
                        Radius.circular(30.0)
                      /*topLeft: Radius.circular(cornarR),
                                  bottomLeft: Radius.circular(cornarR)*/
                    )),
                child: Container(
                  child: Center(
                      child: Text(
                    "Change Your Password",
                    style: TextStyle(
                          color: Color(0xFF376D28), fontSize: 24),
                  )),
                ),
              ),
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      border: InputBorder.none,
                      hintText: "Current password",
                    ),
                    maxLength: 32,
                    style: TextStyle(fontSize: 24),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          currentPasswordField = value;
                          if(currentPasswordField == widget.currentPassword){
                            isCurrentPasswordRight = true;
                          }
                        }
                        else {
                          isCurrentPasswordRight = false;
                          currentPasswordField = " ";
                        }
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      border: InputBorder.none,
                      hintText: "New password",
                    ),
                    maxLength: 32,
                    style: TextStyle(fontSize: 24),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          changedPassword = value;
                          isChagedPassword = true;
                        }
                        else {
                          isChagedPassword = false;
                        }
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      border: InputBorder.none,
                      hintText: "Confirm password",
                    ),
                    maxLength: 32,
                    style: TextStyle(fontSize: 24),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (value) {
                      setState(() {
                        changedConfirmPassword = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if(isCurrentPasswordRight){
                    if(changedPassword == changedConfirmPassword){
                      if(changedPassword.length >= 6){
                        _alertDialogBuilder();
                      }
                      else{
                        showToast("New password is smaller than 6 digits!");
                      }
                    }
                    else{
                      showToast("New password and confirm password field is not same!");
                    }
                  }
                  else{
                    print("CurrentPassword = $currentPasswordField != widget.currentPass = ${widget.currentPassword}");
                    showToast("Current password is not correct!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF216BFA),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text("Change password"),
                //padding: EdgeInsets.symmetric(horizontal: 80, vertical: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _alertDialogBuilder() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure?"),
            content: Container(
              child: Text("Do you want to change password?"),
            ),
            actions: [
              ElevatedButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: Text('Confirm'),
                onPressed: () {
                  submitToFirebase();
                },
              ),
            ],
          );
        });
  }

  void isFirebaseInfoChanged(bool mValue) {
    if (mValue) {
      showToast("Successfully changed name");
      Navigator.pop(context);
    } else {
      showToast("Couldn't change the info");
    }
  }

  void submitToFirebase() async {
    try {
      DatabaseReference reference = FirebaseDatabase.instance.reference();
      await reference.child("UserInfo").child(widget.firebaseKey).update({
        Constants.password: changedPassword,
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString(Constants.currentPassword, changedPassword);
      await widget.sendCallBack();
      isFirebaseInfoChanged(true);
    } catch (e) {
      print("EXCEPTION : e = $e");
      isFirebaseInfoChanged(false);
    }
  }

  void showToast(String mValue) {
    Fluttertoast.showToast(
      msg: mValue,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
