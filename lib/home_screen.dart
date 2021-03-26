import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:make_up_class_schedule/available_screen.dart';
import 'package:make_up_class_schedule/model/item_tile.dart';
import 'package:make_up_class_schedule/model/schedule_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading = false;

  /*var date = DateTime.now();
  print(date.toString()); // prints something like 2019-12-10 10:02:22.287949
  print(DateFormat('EEEE').format(date)); // prints Tuesday*/

  void controlProgressLoading(bool mValue) {
    setState(() {
      _isLoading = mValue;
    });
  }

  DatabaseReference reference = FirebaseDatabase.instance.reference();
  DatabaseReference mainScheduleDb;
  DatabaseReference makeUpScheduleDb;
  DatabaseReference cancelledScheduleDb;
  List<ScheduleItem> dummyData = [];

  var dayName, dateName;

  Future<void> setUpDummyData() async {
    mainScheduleDb = reference.child("MainSchedule");
    makeUpScheduleDb = reference.child("MakeupSchedule");
    cancelledScheduleDb = reference.child("CancelledSchedule");

    DateTime date = DateTime.now();
    var today = DateFormat('EEEE').format(date);
    dayName = today;

    await mainScheduleDb
        .child(today.toUpperCase())
        .child("AAC")
        .once()
        .then((DataSnapshot snapshot) {
      var values = snapshot.value;
      // var keys = snapshot.value.keys;
      dummyData.clear();
      print("VALUES...... = .....$values");
      // print("value.length = ${values.length}");
      print("value type = ${values.runtimeType}");
      /*print("KEYS...... = .....$keys");
      print("VALUES...... = .....$values");*/

      // print("value = ${value.courseId}");

      // Map itemMap = jsonDecode(value);
      // print("itemMap = $itemMap");
      // var item = ScheduleItem.fromJson(itemMap);
      // var item = ScheduleItem.fromJson(value);
      // print("ITEM BEFORE = $item");

      /*var item = ScheduleItem();
        item.courseId = value["courseId"] == null ? "" : value["courseId"];
        item.endTime = value["endTime"] == null ? "" : value["endTime"];
        item.roomNo = value["roomNo"] == null ? "" : value["roomNo"];
        item.startTime = value["startTime"] == null ? "" : value["startTime"];
        item.status = value["status"] == null ? "" : value["status"];*/

      /*item.courseId = value.courseId == null ? "" : value.courseId;
        item.endTime = value.endTime == null ? "" : value.endTime;
        item.roomNo = value.roomNo == null ? "" : value.roomNo;
        item.startTime = value.startTime == null ? "" : value.startTime;
        item.status = value.status == null ? "" : value.status;
        print("ITEM = $item");*/
      /*  dummyData.add(item);
      }
      print(".............................FINISHED LOOOP!!!");*/
      /*try{
      data.forEach((key, value){
        // if(value != null && key != null){

        print("ss5...............................................");
        print("ss5...............................................");
        ScheduleItem item = ScheduleItem(
          courseId: value['courseId'],
          startTime: value['startTime'],
          endTime: value['endTime'],
          status: value['status'],
          roomNo: value['roomNo'],
        );

        dummyData.add(item);
        }
      // }
      );
      }
      catch(e){
        print("EXCEPTION ===  $e");
      }*/
      /*for(var value in values){
      print("value = $value");
      print("value[courseId] = ${value["courseId"]}");
      print("value type = ${value.runtimeType}");
      print("value[courseId] type = ${value["courseId"].runtimeType}");*/

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
            endTime: value['endTime'].toString(),
            startTime: value['startTime'],
            courseId: value['courseId'].toString(),
            batchCode: value['batchCode'],
            section: value['section'].toString(),
            teacherCode: value['teacherCode'],
            itemKey: key,
            status: value['status'] ?? " ",
            courseName: value['courseName'] ?? " ",
          );
          dummyData.add(item);
        });
        print(".............................FINISHED LOOOP!!!");
        // setState(() {});
      }
    });

    today = "${date.day}-${date.month}-${date.year}";
    dateName = today;
    print("TODAY: $today");
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
        // setState(() {});
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
        // setState(() {});
      }
    });
    await sortData(dummyData);
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    setUpDummyData();
  }

  Future<void> sortData(List<ScheduleItem> dummyData) async {
    if (dummyData != null) {
      print("sorting....");
      dummyData.sort(
          (a, b) => int.parse(a.startTime).compareTo(int.parse(b.startTime)));
      // setState(() {});
    }
  }

  void isDatasetChanged(bool isChanged) {
    if (isChanged) {
      print("GOING TO resetData() function");
      resetData(dayName, DateTime.now());
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
        // setState(() {});
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
        // setState(() {});
      }
    });
    if (dummyData != null) {
      dummyData.sort(
          (a, b) => int.parse(a.startTime).compareTo(int.parse(b.startTime)));
    }

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
        // setState(() {});
      }
    });
    await sortData(dummyData);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    var date = DateTime.now();
    var _width = MediaQuery.of(context).size.width - 15.0;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: _height,
      decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40.0,
          ),
          Container(
            height: 100,
            width: _width,
            decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFFDA276))),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Status: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "No important notification!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Color(0xFF3D3F3D),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 35.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // SizedBox(width: 10.0,),
              Container(
                margin: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Today's class",
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
                            date: DateTime.now(),
                            day: dayName,
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
            //height: 500,
            child: dummyData.length == 0
                ? Text("NO ITEM")
                : ListView.builder(
                    itemCount: dummyData.length,
                    itemBuilder: (context, i) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ItemTile(
                        dummyData: dummyData[i],
                        date: "${date.day}-${date.month}-${date.year}",
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
