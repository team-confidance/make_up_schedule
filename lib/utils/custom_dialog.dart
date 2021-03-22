import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomDialog extends StatefulWidget {
  Function function;

  CustomDialog({Key key, this.function}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  var isSectionEntered = false, isCourseEntered = false;
  String courseTitle = "";
  String section = "";

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

  @override
  void initState() {
    isSectionEntered = false;
    isCourseEntered = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                border: InputBorder.none,
                hintText: "Course title/code",
              ),
              maxLength: 50,
              style: TextStyle(fontSize: 24),
              onChanged: (value) {
                courseTitle = value;
                setState(() {
                  value.isNotEmpty ? isCourseEntered = true : isCourseEntered = false;
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
                hintText: "Section/batch",
              ),
              maxLength: 50,
              style: TextStyle(fontSize: 24),
              onChanged: (value) {
                section = value;
                setState(() {
                  value.isNotEmpty ? isSectionEntered = true : isSectionEntered = false;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20.0, top: 10.0),
                  child: MaterialButton(
                    child: Text("Cancel"),
                    onPressed: (){
                        Navigator.of(context).pop();
                        widget.function(courseTitle, section);
                        print("IN CUSTOM DIALOG: function(false)");
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0, top: 10.0),
                  child: MaterialButton(
                    child: Text("Book Class"),
                    onPressed: (){
                      if(isCourseEntered && isSectionEntered){
                        Navigator.of(context).pop();
                        widget.function(courseTitle, section);
                        print("IN CUSTOM DIALOG: function(false)");
                      }
                      else{
                        _showToast("Please fill up all fields!");
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
