import 'package:excel/excel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:make_up_class_schedule/available_screen.dart';
import 'package:make_up_class_schedule/model/item_tile.dart';
import 'package:make_up_class_schedule/model/schedule_item.dart';

class RoutineScreen extends StatefulWidget {
  @override
  _RoutineScreenState createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  DatabaseReference reference = FirebaseDatabase.instance.reference();
  DatabaseReference mainScheduleDb;
  DatabaseReference makeUpScheduleDb;
  DatabaseReference cancelledScheduleDb;
  List<ScheduleItem> dummyData = [];

  @override
  void initState() {
    super.initState();
    mainScheduleDb = reference.child("MainSchedule");
    makeUpScheduleDb = reference.child("MakeupSchedule");
    cancelledScheduleDb = reference.child("CancelledSchedule");

    DateTime date = DateTime.now();
    var today = DateFormat('EEEE').format(date);
    dayName = today;

    print("today = $today  selectedDate = $selectedDate");
    mainScheduleDb.child(today.toUpperCase()).child("AAC").once().then((DataSnapshot snapshot){
      var values = snapshot.value;
      dummyData.clear();
      print("Values = $values");

      if(values != null){
        /*for(var value in values){
          var item = ScheduleItem();
          item.courseId = value["courseId"] == null ? "" : value["courseId"];
          item.endTime = value["endTime"] == null ? "" : value["endTime"];
          item.roomNo = value["roomNo"] == null ? "" : value["roomNo"];
          item.startTime = value["startTime"] == null ? "" : value["startTime"];
          item.status = value["status"] == null ? "" : value["status"];

          dummyData.add(item);
        }*/
        Map<dynamic, dynamic> valueList = snapshot.value;
        valueList.forEach((key, value) {
          ScheduleItem item = ScheduleItem(
              roomNo: value['roomNo'].toString(), endTime: value['endTime'].toString(),
              startTime: value['startTime'].toString(), courseId: value['courseId'].toString(),
              batchCode: value['batchCode'].toString(), section: value['section'].toString(),
              teacherCode: value['teacherCode'].toString(), itemKey: key,
              status: value['status'] ?? " ", courseName: value['courseName'] ?? " ",
          );
          dummyData.add(item);
        });
        print(".............................FINISHED LOOOP!!!");
        setState(() {
        });
      }
    });

    today = "${date.day}-${date.month}-${date.year}";
    makeUpScheduleDb.child(today).child("AAC").once().then((DataSnapshot snapshot){
      var values = snapshot.value;
      print("VALUES2 = $values");

      if(values != null){
        for(var value in values){
          var item = ScheduleItem();
          item.courseId = value["courseId"] == null ? "" : value["courseId"].toString();
          item.endTime = value["endTime"] == null ? "" : value["endTime"].toString();
          item.roomNo = value["roomNo"] == null ? "" : value["roomNo"].toString();
          item.startTime = value["startTime"] == null ? "" : value["startTime"].toString();
          item.status = value["status"] == null ? "" : value["status"].toString();

          dummyData.add(item);
        }
        print(".............................FINISHED LOOOP!!!");
        setState(() {
        });
      }
    });
    cancelledScheduleDb.child(today).child("AAC").once().then((DataSnapshot snapshot){
      var values = snapshot.value;
      print("VALUES3 = $values");
      if(values != null){
        Map<dynamic, dynamic> valueList = snapshot.value;
        valueList.forEach((key, value) {
          var itemKey = value['itemKey'];
          for(var item in dummyData){
            if(item.itemKey == itemKey){
              dummyData.remove(item);
              break;
            }
          }
        });
        print(".............................FINISHED LOOOP!!!");
        setState(() {
        });
      }
    });
  }

  DateTime selectedDate = DateTime.now();
  var days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  var dayName = "";

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        // dayName = days[selectedDate.weekday];
        dayName = DateFormat('EEEE').format(selectedDate);
        resetData(dayName, selectedDate);
      });
  }
  void isDatasetChanged(bool isChanged){
    if(isChanged){
      print("GOING TO resetData() function");
      resetData(dayName, selectedDate);
    }
    else{
      print("DATASET did not changed");
    }
  }

  Future<void> resetData(String today, DateTime selectedDate) async{
    dummyData.clear();
    print("today = $today  selectedDate = $selectedDate");
    await mainScheduleDb.child(today.toUpperCase()).child("AAC").once().then((DataSnapshot snapshot){
      var values = snapshot.value;
      dummyData.clear();
      print("VALUES = $values");

      if(values != null){
        /*for(var value in values){
          var item = ScheduleItem();
          item.courseId = value["courseId"] == null ? "" : value["courseId"];
          item.endTime = value["endTime"] == null ? "" : value["endTime"];
          item.roomNo = value["roomNo"] == null ? "" : value["roomNo"];
          item.startTime = value["startTime"] == null ? "" : value["startTime"];
          item.status = value["status"] == null ? "" : value["status"];

          dummyData.add(item);
        }*/
        Map<dynamic, dynamic> valueList = snapshot.value;
        valueList.forEach((key, value) {
          ScheduleItem item = ScheduleItem(
            roomNo: value['roomNo'], endTime: value['endTime'],
            startTime: value['startTime'], courseId: value['courseId'],
            batchCode: value['batchCode'], section: value['section'],
            teacherCode: value['teacherCode'], itemKey: key,
            status: value['status'] ?? " ", courseName: value['courseName'] ?? " ",
          );
          dummyData.add(item);
        });
        print(".............................FINISHED LOOOP!!!");
        setState(() {
        });
      }
    });

    today = "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
    await makeUpScheduleDb.child(today).child("AAC").once().then((DataSnapshot snapshot){
      var values = snapshot.value;
      print("VALUES2 = $values");

      if(values != null){
        for(var value in values){
          var item = ScheduleItem();
          item.courseId = value["courseId"] == null ? "" : value["courseId"];
          item.endTime = value["endTime"] == null ? "" : value["endTime"];
          item.roomNo = value["roomNo"] == null ? "" : value["roomNo"];
          item.startTime = value["startTime"] == null ? "" : value["startTime"];
          item.status = value["status"] == null ? "" : value["status"];

          dummyData.add(item);
        }
        print(".............................FINISHED LOOOP!!!");
        setState(() {
        });
      }
    });
    cancelledScheduleDb.child(today).child("AAC").once().then((DataSnapshot snapshot){
      var values = snapshot.value;
      print("VALUES3 = $values");
      if(values != null){
        Map<dynamic, dynamic> valueList = snapshot.value;
        valueList.forEach((key, value) {
          var itemKey = value['itemKey'];
          var item;
          bool flag = false;
          for(item in dummyData){
            if(item.itemKey == itemKey){
              flag = true;
              break;
            }
          }
          if(flag){
            dummyData.remove(item);
          }
        });
        print(".............................FINISHED LOOOP!!!");
        setState(() {
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.now();
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: _height,
      decoration: BoxDecoration(color: Color(0xFFE4ECF1)),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                width: _width,
                child: Center(
                  child: Text(
                    "${dayName} ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  /*image: DecorationImage(fit: BoxFit.cover,
                    image: AssetImage("assets/images/text_bg.png",),
                  ),*/
                ),
              ),
            ),
            //child: SfCalendar(view: CalendarView.month,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Routine", style: TextStyle(fontSize: 26)),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AvailableScreen(day: dayName, date: selectedDate,)));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
          Expanded(
            child: dummyData.length ==0 ? Text("NO ITEM") : ListView.builder(
              itemCount: dummyData.length,
              itemBuilder: (context, i) => Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ItemTile(dummyData: dummyData[i], date: "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}", datasetChanged: isDatasetChanged,),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
