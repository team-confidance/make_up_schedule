import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_up_class_schedule/create_new_user_screen.dart';
import 'package:make_up_class_schedule/edit_password.dart';
import 'package:make_up_class_schedule/edit_phone_number.dart';
import 'package:make_up_class_schedule/edit_profile_info.dart';
import 'package:make_up_class_schedule/model/dummy_class_rooms.dart';
import 'package:make_up_class_schedule/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var userName = " ", designation = " ", email = " ", phone = " ", photoUrl = "", firebaseKey = "", currentPassword = "";
  var isAdmin = false;
  var _isLoading = true;

  void getPreferences() async {
    var preference = await SharedPreferences.getInstance();
    email = preference.getString(Constants.emailAddress);
    userName = preference.getString(Constants.name);
    designation = preference.getString(Constants.designation);
    phone = preference.getString(Constants.phone);
    photoUrl =  preference.getString(Constants.photoUrl);
    isAdmin = preference.getBool(Constants.isAdmin);
    firebaseKey = preference.getString(Constants.firebaseKey);
    currentPassword = preference.getString(Constants.currentPassword);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getPreferences();
    super.initState();
  }

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
  String _fileName = "";
  bool _isFilePicked = false;
  DatabaseReference dbReference;
  Future<String> getDbReference() async{
    try{
      dbReference = await FirebaseDatabase.instance.reference();
      return null;
    }catch(e){
      print("GetDbRef EXCEPTION : e= $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator()) : Container(
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
                userName,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(child: Text(designation)),
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
                        email,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      /*TextButton(
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
                      )*/
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
                        phone,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      /*TextButton(
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
                      )*/
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditProfileInfo(sendCallBack: getPreferences,currentName: userName, currentDesignation: designation, firebaseKey: firebaseKey,)));
                  },
                  /*shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),*/
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF216BFA),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text("Change profile info"),
                ),
                SizedBox(width: 10.0,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditPassword(firebaseKey: firebaseKey, currentPassword: currentPassword, sendCallBack: getPreferences,)));
                  },
                  /*shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),*/
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF216BFA),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text("Change password"),
                ),
              ],
            ),
            SizedBox(height: 20.0,),
            Visibility(
              child: Text(_fileName),
              visible: _isFilePicked,
            ),
            Visibility(
              visible: isAdmin,
              child: Row(
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
                          _uploadTableToFirebase(excel);


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
                      primary: Color(0xFF216BFA),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
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
                      primary: Color(0xFF216BFA),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text("Create New User"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<bool> _uploadTableToFirebase(Excel excel) async {
    bool isSuccessFul = true;
    for (var table in excel.tables.keys) {
      print("TABLE = $table"); //sheet Name
      print("Max COL = " + excel.tables[table].maxCols.toString());
      print("MAX ROW = " + excel.tables[table].maxRows.toString());
      List<String> header = new List.filled(excel.tables[table].maxRows, "");
      Map<int, TimePair> times = {};
      var latestDay = "";
      bool alreadyTakenDetails = false;
      Map<Pair, bool> roomUsedDetails = {};
      var maxColHasClass = 0;
      // Map<String, List<String>> roomUsedDetails = {};
      for (var row in excel.tables[table].rows) {
        print("...............ROW = $row");
        print("ROW.type = ${row.runtimeType}   ROW.size = ${row.length}");
        var rowLength = row.length;
        var beforeLatestDay;

        if(row[0] != null){
          beforeLatestDay = latestDay;
          latestDay = row[0];
          print("latestDay === ${row[0]}");
          if(alreadyTakenDetails == false){
            alreadyTakenDetails = true;
            for(int i=1; i<rowLength; i++){
              if(row[i]!=null){
                String myString = row[i].toString();
                print("i=$i, myString = $myString, row[i] = ${row[i]}");
                String withoutEquals = myString.replaceAll(RegExp(' '), '');
                print("i=$i, withoutEquals = $withoutEquals");


                var splitResult = withoutEquals.split('-');
                if(splitResult.length > 1){
                  //given a time range
                  var againSplit = splitResult[0].split(":");
                  var hourToMinute = int.parse(againSplit[0])*60;
                  var onlyMinutes = int.parse(againSplit[1]);
                  var startTime = hourToMinute + onlyMinutes;

                  againSplit = splitResult[1].split(":");
                  var lastTwoChar = againSplit[1].substring(againSplit[1].length-2,againSplit[1].length);
                  againSplit[1] = againSplit[1].substring(0, againSplit[1].length-2);
                  hourToMinute = int.parse(againSplit[0])*60;
                  onlyMinutes = int.parse(againSplit[1]);
                  var endTime = hourToMinute + onlyMinutes;

                  if(lastTwoChar == "PM" || lastTwoChar == "pm"){
                    if(startTime<endTime){
                      startTime += 720;
                    }
                    endTime+=720;
                  }
                  times[i] = TimePair(startTime, endTime);
                  header[i] = "timeRange";
                }
                else{
                  header[i] = withoutEquals;
                }
              }
            }
          }
          else{
            print("INTO THE ELSE........maxColHasClass = $maxColHasClass");
            for(int i=3; i<=maxColHasClass; i++){
              if(header[i] != "timeRange"){
                continue;
              }
              for(var roomNo in roomList){
                print("i=$i roomNo = $roomNo  times[i].fromTime = ${times[i].fromTime}");
                Pair pairElement = Pair(roomNo, times[i].fromTime);
                print("pairElement = $pairElement");
                if(roomUsedDetails[pairElement] == null){
                  roomUsedDetails[pairElement] = false;
                }
                if(roomUsedDetails[pairElement] == false){
                  try{
                    await dbReference.child("AvailableRoomsByDay").child(beforeLatestDay).push().set({
                      "roomNo" : roomNo,
                      "startTime" : times[i].fromTime,
                      "endTime" : times[i].toTime,
                    });
                    print("ROUTINE UPLOADED!");
                  }
                  catch(e){
                    print("ROUTINE UPLOAD FAILED!  E = $e");
                    _showToast("Routine Upload Failed");
                    isSuccessFul = false;
                  }
                }
              }
            }
            print("LOOP FINISHED!!!!!!!");
            print("starting new loop!!!");
            for(var i=3; i<rowLength; i++) {
              if(header[i] != "timeRange"){
                continue;
              }
              for (var roomNo in roomList) {
                roomUsedDetails[Pair(roomNo, times[i].fromTime)] = false;
              }
            }
          }
        }
        else{
          for(var i=3; i<rowLength; i++){
            if(row[i]!=null){
              String myString = row[i].toString();
              print("myString = $myString");
              var splitResult = myString.split(',');
              print("SPLIT RESULT = $splitResult");
              if(splitResult.length == 3){
                maxColHasClass = max(maxColHasClass, i);
                var courseCode = splitResult[0];
                print("courseCode = $courseCode");
                var teacherCode = splitResult[1];
                print("teacherCode = $teacherCode");
                var roomNo = splitResult[2];
                print("roomNo = $roomNo");
                var sectionCode = row[1];
                var batchCode = row[2];

                await getDbReference();
                //upload to mainDb
                try{
                  await dbReference.child("MainSchedule").child(latestDay).child(teacherCode).push().set({
                    "courseId" : courseCode,
                    "teacherCode" : teacherCode,
                    "roomNo" : roomNo,
                    "section" : sectionCode,
                    "batchCode" : batchCode,
                    "startTime" : times[i].fromTime.toString(),
                    "endTime" : times[i].toTime.toString(),
                  });
                  roomUsedDetails[Pair(roomNo, times[i].fromTime)] = true;
                  _showToast("Routine uploaded successfully!");
                  print("ROUTINE UPLOADED!");
                }
                catch(e){
                  print("ROUTINE UPLOAD FAILED!");
                  _showToast("Routine Upload Failed");
                  isSuccessFul = false;
                }
              }
            }
          }
        }
      }
      for(int i=3; i<=maxColHasClass; i++){
        if(header[i] != "timeRange"){
          continue;
        }
        for(var roomNo in roomList){
          print("i=$i roomNo = $roomNo  times[i].fromTime = ${times[i].fromTime}");
          Pair pairElement = Pair(roomNo, times[i].fromTime);
          print("pairElement = $pairElement");
          if(roomUsedDetails[pairElement] == null){
            roomUsedDetails[pairElement] = false;
          }
          if(roomUsedDetails[pairElement] == false){
            try{
              await dbReference.child("AvailableRoomsByDay").child(latestDay).push().set({
                "roomNo" : roomNo,
                "startTime" : times[i].fromTime,
                "endTime" : times[i].toTime,
              });
              _showToast("Routine uploaded successfully!");
              print("ROUTINE UPLOADED!");
            }
            catch(e){
              print("ROUTINE UPLOAD FAILED!  E = $e");
              _showToast("Routine Upload Failed");
              isSuccessFul = false;
            }
          }
        }
      }
      print("LOOP FINISHED!!!!!!!");
    }
    return isSuccessFul;
  }
}

class TimePair {
  TimePair(this.fromTime, this.toTime);
  final dynamic fromTime;
  final dynamic toTime;

  @override
  String toString() => 'TimePair[$fromTime, $toTime]';
}
class Pair {
  Pair(this.first, this.second);
  final dynamic first;
  final dynamic second;

  @override
  String toString() => 'Pair[$first, $second]';
}
