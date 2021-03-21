import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/main_screen.dart';
import 'package:make_up_class_schedule/model/login_info.dart';
import 'package:make_up_class_schedule/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFragment extends StatefulWidget {
  @override
  _LoginFragmentState createState() => _LoginFragmentState();
}

class _LoginFragmentState extends State<LoginFragment> {
  // var _goToMain = false;
  final Future<SharedPreferences> _preference = SharedPreferences.getInstance();

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


  List<LoginInfo> infoList = [];
  Future<String> _loginAccount() async{
    // eroTIrHN
    try{
      DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child("UserInfo").orderByChild("email").equalTo(_loginEmail).once();
      Map<dynamic,dynamic> userData = snapshot.value;
      print("CHEKING ALREADY EXISTING USER: userExist = $userData");
      if(userData != null){
        infoList.clear();
        userData.forEach((key, value) {
          LoginInfo mValue = LoginInfo(email : value['email'], password: value['password'], name: value['name'], designation: value['designation'], phone: value['phone'], photoUrl: value['photoUrl']);
          mValue.firebaseKey = key;
          infoList.add(mValue);
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
      var preference = await _preference;
      await preference.setBool(Constants.isLoggedIn, true);
      await preference.setString(Constants.emailAddress, _loginEmail);
      await preference.setString(Constants.name, infoList[0].name?? "Dummy Name");
      await preference.setString(Constants.designation, infoList[0].designation?? "Dummy Designation");
      await preference.setString(Constants.phone, infoList[0].phone?? "01XXXXXXXXX");
      await preference.setString(Constants.photoUrl, infoList[0].photoUrl?? "");
      await preference.setString(Constants.firebaseKey, infoList[0].firebaseKey);
      //Navigator.pushNamedAndRemoveUntil(context, "/main_screen", (Route<dynamic> route) => false);
      // eroTIrHN
      /*Navigator.of(context).pushNamedAndRemoveUntil(
          '/main_screen', (Route<dynamic> route) => false);*/
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => MainScreen(),
        ),
            (route) => false,//if you want to disable back feature set to false
      );
      //Navigator.pop(context);  // pop current page

      /*Navigator.pushNamed(context, "/main");*/
    }
  }

  bool _loginFormLoading = false;
  String _loginEmail = "";
  String _loginPassword = "";
  FocusNode _passwordFocusNode;
  String _name = "";
  String _designation = "";
  String _phone = "";
  String _photoUrl = "";

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