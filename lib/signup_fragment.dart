import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupFragment extends StatefulWidget {
  @override
  _SignupFragmentState createState() => _SignupFragmentState();
}

class _SignupFragmentState extends State<SignupFragment> {

  Future<void> _alertDialogBuilder(String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              ElevatedButton(
                child: Text('Close'),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }
  Future<void> _showSuccessDialog () async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text("Successful!"),
            content: Container(
              child: Text("Please varify your email and sign sign in."),
            ),
            actions: [
              ElevatedButton(
                child: Text('Close'),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  Future<String> _createAccount() async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword
      );
      return null;
    } on FirebaseAuthException catch(e){
      if(e.code == "weak-password"){
        return "Password is weak!";
      }
      else if(e.code == "email-already-in-use"){
        return "Email is already in use";
      }
      else{
        return e.code.toString();

      }
    }
    catch(e){
      print(e.toString());
      return "Error occured while signing up!";
    }
  }

  Future<String> _saveUserInfo() async{
    try{
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseDatabase.instance.reference().child("UserInfo").child(user.uid).set(
          {
            "FirstName" : _registerFirstName,
            "LastName" : _registerLastName,
            "email" : _registerEmail,
            "phone" : _registerPhoneNumber,
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

  void _submitForm() async{
    setState(() {
      _registerFormLoading = true;
    });

    String _createAccountFeedback = await _createAccount();
    if(_createAccountFeedback != null){
      _alertDialogBuilder("Creating user error: $_createAccountFeedback");

      setState(() {
        _registerFormLoading = false;
      });
    }
    else{
      String _saveUserInfoFeedback = await _saveUserInfo();
      if(_saveUserInfoFeedback != null){
        _alertDialogBuilder("User Info Saving Error: $_saveUserInfoFeedback");

        setState(() {
          _registerFormLoading = false;
        });
      }
      else{
        try{
          var user = FirebaseAuth.instance.currentUser;
          user.sendEmailVerification();
        }
        catch(e){
          _goToMain();
        }
      }
    }
  }

  void _goToMain(){
    // Navigator.pushNamedAndRemoveUntil(context, "/main", (r) => false);
    // setState(() {});
    // Navigator.pop(context);  // pop current pages
    setState(() {
      _registerFormLoading = false;
    });
    _showSuccessDialog();
    Navigator.pushNamed(context, "/main_screen");
  }


  bool _registerFormLoading = false;
  String _registerEmail = "";
  String _registerPassword = "";
  String _registerFirstName = "";
  String _registerLastName = "";
  String _registerPhoneNumber = "";

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
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  border: InputBorder.none,
                  hintText: "First name",
                ),
                maxLength: 20,
                style: TextStyle(fontSize: 24),
                onChanged: (value){
                  _registerFirstName = value;
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
                  hintText: "Last name",
                ),
                maxLength: 20,
                style: TextStyle(fontSize: 24),
                onChanged: (value){
                  _registerLastName = value;
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
                  hintText: "Email Address",
                ),
                maxLength: 50,
                style: TextStyle(fontSize: 24),
                onChanged: (value){
                  _registerEmail = value;
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
                  hintText: "Phone Number",
                ),
                maxLength: 14,
                style: TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                onChanged: (value){
                  _registerPhoneNumber = value;
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
                onChanged: (value){
                  _registerPassword = value;
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
                  hintText: "Confirm password",
                ),
                maxLength: 32,
                style: TextStyle(fontSize: 24),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                onSubmitted: (value){
                  _submitForm();
                },
                textInputAction: TextInputAction.next,
              ),

              ElevatedButton(
                onPressed: () {
                  _registerFormLoading ? null : _submitForm();
                  setState(() {
                    _registerFormLoading = true;
                  });
                },
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
                      child: Text("Create Account", style: TextStyle(fontSize: 16),
                      )),
                ),
              ),
              SizedBox(height: 30,)
            ],
          ),
        ),

        Visibility(
          visible: _registerFormLoading,
          child: Container(
            child: Center(
              child: SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator()
              ),
            ),
          ),
        ),
      ],
    );
  }
}
