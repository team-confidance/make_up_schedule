import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  var _newUserEmail = "";
  var _newUserPassword = "";

  void _showToast(String mText){
    Fluttertoast.showToast(
        msg: mText,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future<bool> _alreadyExistingUser() async{
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("UserInfo").orderByChild("email").equalTo(_newUserEmail).once();
    Map<dynamic,dynamic> userData = snapshot.value;
    print("CHEKING ALREADY EXISTING USER: userExist = $userData");
    return userData != null;
  }
  String getRandomString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) =>  random.nextInt(255));
    return base64UrlEncode(values);
  }

  Future<String> _saveToFirebase() async{
    try{
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseDatabase.instance.reference().child("UserInfo").push().set(
          {
            "email" : _newUserEmail,
            "password" : _newUserPassword,
          }
      );
      return null;
    }on FirebaseException catch(e){
      return e.message.toString();
    }
    catch(e){
      print(e.toString());
      return "Error occured!";
    }
  }

  Future<String> _sendEmail() async {
    String username = 'team.confidance001@gmail.com';
    String password = 'tEAMcONFIDANCE4321';

    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Your name')
      ..recipients.add(_newUserEmail)
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.\nPassword = $_newUserPassword';
      // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return null;
    } on MailerException catch (e) {
      print('Message not sent. e=$e');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return "email not sent!";
    }
    catch(e){
      print("Email not sent-Outer : e=$e");
      return "email not sent!";
    }
  }

  Future<bool> _createNewUser() async{
    var isUserAlreadyExist = await _alreadyExistingUser();
    if(isUserAlreadyExist){
      _showToast("Email is already in use!");
      print("RETURNING FALSE: Email is already in use");
      return false;
    }
    else{
      setState(() {
        _newUserPassword = getRandomString(6);
      });
      var userCreationInfo = await _saveToFirebase();
      if(userCreationInfo == null){
        var sendingMailInfo = await _sendEmail();
        if(sendingMailInfo == null){
          _showToast("Account created! An email sent to the user!");
          print("email sent!!");
          return true;
        }
        else{
          print("RETURNING FALSE: email sending");
          _showToast(sendingMailInfo);
          return false;
        }
      }
      else{
        print("RETURNING FALSE: creating user in firebase");
        _showToast(userCreationInfo);
        return false;
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          //title: Text(""),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.logout), onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, "/login_screen", (r) => false);
            })
          ],
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
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(50)),
                child: Container(
                  child: Center(
                      child: Text(
                        "Create New User",
                        style: TextStyle(color: Color(0xFF707070), fontSize: 24),
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
                      hintText: "example@email.com",
                    ),
                    maxLength: 50,
                    style: TextStyle(fontSize: 24),
                    onChanged: (value) {
                      _newUserEmail = value;
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  bool isSuccessful = await _createNewUser();
                  if(isSuccessful){
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text("Create User"),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
