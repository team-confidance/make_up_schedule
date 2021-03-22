import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_up_class_schedule/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileInfo extends StatefulWidget {
  final String currentName, currentDesignation, firebaseKey;
  final Function sendCallBack;

  EditProfileInfo(
      {this.sendCallBack,
      this.firebaseKey,
      this.currentDesignation,
      this.currentName,
      Key key})
      : super(key: key);

  @override
  _EditProfileInfoState createState() => _EditProfileInfoState();
}

class _EditProfileInfoState extends State<EditProfileInfo> {
  var changedFullName = "", changedDesignation = "";
  var isChangedName = false, isChangedDesignation = false;

  @override
  Widget build(BuildContext context) {
    var currentName = widget.currentName,
        currentDesignation = widget.currentDesignation;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                height: 70,
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 50,
                  left: 30,
                  right: 30,
                  bottom: 80,
                ),
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
                    "Edit Your Profile",
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
                      hintText: currentName,
                    ),
                    maxLength: 32,
                    style: TextStyle(fontSize: 24),
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          changedFullName = value;
                          isChangedName = true;
                        } else {
                          isChangedName = false;
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
                      hintText: currentDesignation,
                    ),
                    maxLength: 32,
                    style: TextStyle(fontSize: 24),
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          changedDesignation = value;
                          isChangedDesignation = true;
                        } else {
                          isChangedDesignation = false;
                        }
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
                  if (isChangedDesignation || isChangedName) {
                    setState(() {
                      if (!isChangedName) {
                        changedFullName = currentName;
                      }
                      if (!isChangedDesignation) {
                        changedDesignation = currentDesignation;
                      }
                      _alertDialogBuilder();
                    });
                  } else {
                    showToast("Please change at least one field!");
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF216BFA),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text("Edit profile"),
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
              child: Text("Do you want to change profile info?"),
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
        Constants.name: changedFullName,
        Constants.designation: changedDesignation,
      });
      isFirebaseInfoChanged(true);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString(Constants.designation, changedDesignation);
      await preferences.setString(Constants.name, changedFullName);
      await widget.sendCallBack();
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
