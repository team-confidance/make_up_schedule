import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/model/login_info.dart';

class LoginFragment extends StatefulWidget {
  @override
  _LoginFragmentState createState() => _LoginFragmentState();
}

class _LoginFragmentState extends State<LoginFragment> {
  // var _goToMain = false;

  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              ElevatedButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  Future<String> _loginAccount() async{
    // eroTIrHN
    try{
      DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("UserInfo").orderByChild("email").equalTo(_loginEmail).once();
      Map<dynamic,dynamic> userData = snapshot.value;
      print("CHEKING ALREADY EXISTING USER: userExist = $userData");
      if(userData != null){
        List<LoginInfo> infoList = [];
        userData.forEach((key, value) {
          infoList.add(value);
        });
        if(infoList[0].email == _loginEmail && infoList[0].password == _loginPassword){
          print("OKAY!! email and password matched: RETURNING NULL!!");
          return null;
        }
        else{
          print("RETURNING!!: email or password dowsn't match!!!");
          return "Email or password is not exist!";
        }
      }
      else{
        print("userData == null, returning back!!");
        return "Email or password is not exist!";
      }
    }
    catch(e){
      print(e.toString());
      return "Error occured while signing up! $e";
    }
  }

  void _submitForm() async{
    setState(() {
      _loginFormLoading = true;
    });

    String _loginFeedback = await _loginAccount();
    if(_loginFeedback != null){
      _alertDialogBuilder(_loginFeedback);

      setState(() {
        _loginFormLoading = false;
      });
    }
    else{
      Navigator.pushNamedAndRemoveUntil(context, "/main_screen", (r) => false);
      /*Navigator.pop(context);  // pop current page
      Navigator.pushNamed(context, "/main");*/
    }
  }

  bool _loginFormLoading = false;
  String _loginEmail = "";
  String _loginPassword = "";
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Column(
          children: [
            TextField(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                border: InputBorder.none,
                hintText: "Email",
              ),
              maxLength: 50,
              style: TextStyle(fontSize: 24),
              onChanged: (value) {
                _loginEmail = value;
              },
              textInputAction: TextInputAction.next,
            ),
            TextField(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                border: InputBorder.none,
                hintText: "Password",
              ),
              maxLength: 32,
              style: TextStyle(fontSize: 24),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              onChanged: (value) {
                _loginPassword = value;
              },
              onSubmitted: (value) {
                _submitForm();
              },
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {_submitForm();},
          style: ElevatedButton.styleFrom(
            primary: Colors.lightBlue,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Container(
            width: 130,
            height: 48,
            child: Center(
                child: Text("Submit", style: TextStyle(fontSize: 16),
            )),
          ),
        ),
      ],
    ));
  }
}