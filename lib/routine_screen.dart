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
  var _isLoading = false;

  void controlProgressLoading(bool mValue) {
    setState(() {
      _isLoading = mValue;
    });
  }

  Future<void> sortData(List<ScheduleItem> dummyData) async {
    if (dummyData != null) {
      print("sorting....");
      await dummyData.sort(
          (a, b) => int.parse(a.startTime).compareTo(int.parse(b.startTime)));
      setState(() {});
    }
  }

  Future<void> setUpDummyData() async {
    mainScheduleDb = reference.child("MainSchedule");
    makeUpScheduleDb = reference.child("MakeupSchedule");
    cancelledScheduleDb = reference.child("CancelledSchedule");

    DateTime date = DateTime.now();
    var today = DateFormat('EEEE').format(date);
    dayName = today;

    print("today = $today  selectedDate = $selectedDate");
    await mainScheduleDb
        .child(today.toUpperCase())
        .child("AAC")
        .once()
        .then((DataSnapshot snapshot) {
      var values = snapshot.value;
      dummyData.clear();
      print("Values = $values");

      if (values != null) {
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
            roomNo: value['roomNo'].toString(),
            endTime: value['endTime'].toString(),
            startTime: value['startTime'].toString(),
            courseId: value['courseId'].toString(),
            batchCode: value['batchCode'].toString(),
            section: value['section'].toString(),
            teacherCode: value['teacherCode'].toString(),
            itemKey: key,
            status: value['status'] ?? " ",
            courseName: value['courseName'] ?? " ",
          );
          dummyData.add(item);
        });
        print(".............................FINISHED LOOOP!!!");
        setState(() {});
      }
    });

    today = "${date.day}-${date.month}-${date.year}";
    await makeUpScheduleDb
        .child(today)
        .child("AAC")
        .once()
        .then((DataSnapshot snapshot) {
      var values = snapshot.value;
      print("VALUES2 = $values");

      if (values != null) {
        Map<dynamic, dynamic> valueList = snapshot.value;
        valueList.forEach((key, value) {
          ScheduleItem item = ScheduleItem(
            roomNo: value['roomNo'],
            endTime: value['endTime'],
            startTime: value['startTime'],
            courseId: value['courseId'],
            batchCode: value['batchCode'],
            section: value['section'],
            teacherCode: value['teacherCode'],
            itemKey: key,
            status: value['status'] ?? " ",
            courseName: value['courseName'] ?? " ",
          );
          dummyData.add(item);
        });
        print(".............................FINISHED LOOOP!!!");
        setState(() {});
      }
    });
    await cancelledScheduleDb
        .child(today)
        .child("AAC")
        .once()
        .then((DataSnapshot snapshot) {
      var values = snapshot.value;
      print("VALUES3 = $values");
      if (values != null) {
        Map<dynamic, dynamic> valueList = snapshot.value;
        valueList.forEach((key, value) {
          var itemKey = value['itemKey'];
          var item;
          bool flag = false;
          for (item in dummyData) {
            if (item.itemKey == itemKey) {
              flag = true;
              break;
            }
          }
          if (flag) {
            dummyData.remove(item);
          }
        });
        print(".............................FINISHED LOOOP!!!");
        setState(() {});
      }
    });
    await sortData(dummyData);
  }

  @override
  void initState() {
    super.initState();
    setUpDummyData();
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

  void isDatasetChanged(bool isChanged) {
    if (isChanged) {
      print("GOING TO resetData() function");
      resetData(dayName, selectedDate);
    } else {
      print("DATASET did not changed");
    }
  }

  Future<void> resetData(String today, DateTime selectedDate) async {
    dummyData.clear();
    print("today = $today  selectedDate = $selectedDate");
    await mainScheduleDb
        .child(today.toUpperCase())
        .child("AAC")
        .once()
        .then((DataSnapshot snapshot) {
      var values = snapshot.value;
      dummyData.clear();
      print("VALUES = $values");

      if (values != null) {
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
            roomNo: value['roomNo'],
            endTime: value['endTime'],
            startTime: value['startTime'],
            courseId: value['courseId'],
            batchCode: value['batchCode'],
            section: value['section'],
            teacherCode: value['teacherCode'],
            itemKey: key,
            status: value['status'] ?? " ",
            courseName: value['courseName'] ?? " ",
          );
          dummyData.add(item);
        });
        print(".............................FINISHED LOOOP!!!");
        setState(() {});
      }
    });

    today = "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
    await makeUpScheduleDb
        .child(today)
        .child("AAC")
        .once()
        .then((DataSnapshot snapshot) {
      var values = snapshot.value;
      print("VALUES2 = $values");

      if (values != null) {
        Map<dynamic, dynamic> valueList = snapshot.value;
        valueList.forEach((key, value) {
          ScheduleItem item = ScheduleItem(
            roomNo: value['roomNo'],
            endTime: value['endTime'],
            startTime: value['startTime'],
            courseId: value['courseId'],
            batchCode: value['batchCode'],
            section: value['section'],
            teacherCode: value['teacherCode'],
            itemKey: key,
            status: value['status'] ?? " ",
            courseName: value['courseName'] ?? " ",
          );
          dummyData.add(item);
        });
        print(".............................FINISHED LOOOP!!!");
        setState(() {});
      }
    });

    await cancelledScheduleDb
        .child(today)
        .child("AAC")
        .once()
        .then((DataSnapshot snapshot) {
      var values = snapshot.value;
      print("VALUES3 = $values");
      if (values != null) {
        Map<dynamic, dynamic> valueList = snapshot.value;
        valueList.forEach((key, value) {
          var itemKey = value['itemKey'];
          var item;
          bool flag = false;
          for (item in dummyData) {
            if (item.itemKey == itemKey) {
              flag = true;
              break;
            }
          }
          if (flag) {
            dummyData.remove(item);
          }
        });
        print(".............................FINISHED LOOOP!!!");
        setState(() {});
      }
    });
    sortData(dummyData);
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.now();
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: _height,
      decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "$dayName ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 8.0),
                      child: Text(
                        "Change",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
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
              Container(
                margin: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Routine",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF376D28),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AvailableScreen(
                            day: dayName,
                            date: selectedDate,
                          )));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    // color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF376D28)),
                  ),
                  // child: Icon(Icons.add),
                  child: Text(
                    "Available Rooms",
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: dummyData.length == 0
                ? Text("NO ITEM")
                : ListView.builder(
                    itemCount: dummyData.length,
                    itemBuilder: (context, i) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ItemTile(
                        dummyData: dummyData[i],
                        date:
                            "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                        datasetChanged: isDatasetChanged,
                        progressLoading: controlProgressLoading,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    ));
  }
}
