import 'dart:io';
import 'dart:ui';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/create_new_user_screen.dart';
import 'package:make_up_class_schedule/edit_password.dart';
import 'package:make_up_class_schedule/edit_phone_number.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _fileName = "";
  bool _isFilePicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFE4ECF1)),
        //width: MediaQuery.of(context).size.width,
        width: double.infinity,
        // decoration: BoxDecoration(color: Color(0xFFA0D0FF)),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 70, bottom: 20),
              child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/arif_ahmed.jpg')),
            ),
            Container(
              child: Text(
                "Arif Ahmed",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(child: Text("Associate Professor")),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "E-mail: ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "arifahmed@lus.ac.bd",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Phone: ",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "+8801xxxxxxx",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          print("Edit Button Clicked");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditPhoneNumber()));
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditPassword()));
              },
              /*shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),*/
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: Text("Change password"),
            ),
            Visibility(
              child: Text(_fileName),
              visible: _isFilePicked,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: ()  async {
                    print("UPLOAD ROUTINE button pressed");
                    try{
                      FilePickerResult result = await FilePicker.platform.pickFiles();

                      if(result != null) {
                        PlatformFile file = result.files.first;

                        setState(() {
                          _fileName = file.name.toString();
                          _isFilePicked = true;
                          /*_byte = file.bytes.toString();
                          _size = file.size.toString();
                          _extension = file.extension.toString();
                          _path = file.path.toString();*/
                        });

                        print(file.name);
                        print(file.bytes);
                        print(file.size);
                        print(file.extension);
                        print(file.path);



                        var mPath = file.path;
                        var bytes = File(mPath).readAsBytesSync();
                        var excel = Excel.decodeBytes(bytes);

                        for (var table in excel.tables.keys) {
                          print("TABLE = $table"); //sheet Name
                          print("Max COL = " + excel.tables[table].maxCols.toString());
                          print("MAX ROW = " + excel.tables[table].maxRows.toString());
                          for (var row in excel.tables[table].rows) {
                            print("...............ROW = $row");
                            print("ROW.type = ${row.runtimeType}   ROW.size = ${row.length}");
                          }
                        }

                      } else {
                        // User canceled the picker
                      }
                    }
                    catch(e){
                      print(">>>>>>>..........>>>>>>>>EXCEPTION : $e");
                    }
                  },
                  /*shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),*/
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Text("Upload Routine"),
                ),
                SizedBox(
                  width: 10.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    print("CREATE USER button pressed");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CreateUser()));
                  },
                  /*shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),*/
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Text("Create New User"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
