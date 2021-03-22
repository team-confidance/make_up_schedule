import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/model/available_item.dart';
import 'package:make_up_class_schedule/model/available_item_tile.dart';

class AvailableScreen extends StatefulWidget {
  final String day;
  final DateTime date;

  AvailableScreen({this.date, this.day});

  @override
  _AvailableScreenState createState() => _AvailableScreenState();
}

class _AvailableScreenState extends State<AvailableScreen> {
  DatabaseReference reference = FirebaseDatabase.instance.reference();
  DatabaseReference availableRoomsByDayDb;
  DatabaseReference availableRoomsByDateDb;
  DatabaseReference bookedRoomsDb;
  List<AvailableItem> dummyData = [];

  Future<void> sortData(List<AvailableItem> dummyData) async {
    if (dummyData != null) {
      print("sorting....");
      await dummyData.sort(
          (a, b) => int.parse(a.startTime).compareTo(int.parse(b.startTime)));
      setState(() {});
    }
  }

  Future<void> setUpDummyData() async {
    availableRoomsByDayDb = reference.child("AvailableRoomsByDay");
    availableRoomsByDateDb = reference.child("AvailableRoomsByDate");
    bookedRoomsDb = reference.child("BookedRooms");

    var today = widget.day;
    dayName = widget.day;
    selectedDate = widget.date;

    try {
      await availableRoomsByDayDb
          .child(today.toUpperCase())
          .once()
          .then((DataSnapshot snapshot) {
        var values = snapshot.value;
        print("AVAILABLE values = ${values}");
        dummyData.clear();

        if (values != null) {
          Map<dynamic, dynamic> valueList = snapshot.value;
          valueList.forEach((key, value) {
            AvailableItem item = AvailableItem(
              roomNo: value['roomNo'].toString(),
              startTime: value['startTime'].toString(),
              endTime: value['endTime'].toString(),
              itemKey: key.toString(),
              status: value['status'] ?? " ",
            );
            dummyData.add(item);
          });
          print(".............................FINISHED LOOOP!!!");
          setState(() {});
        }
      });

      today = "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
      ;
      await availableRoomsByDateDb
          .child(today)
          .once()
          .then((DataSnapshot snapshot) {
        var values = snapshot.value;
        print("AVAILABLE values = ${values}");

        if (values != null) {
          Map<dynamic, dynamic> valueList = snapshot.value;
          valueList.forEach((key, value) {
            AvailableItem item = AvailableItem(
              roomNo: value['roomNo'].toString(),
              startTime: value['startTime'].toString(),
              endTime: value['endTime'].toString(),
              itemKey: key.toString(),
              status: value['status'] ?? " ",
            );
            dummyData.add(item);
          });
          print(".............................FINISHED LOOOP!!!");
          setState(() {});
        }
      });

      await bookedRoomsDb.child(today).once().then((DataSnapshot snapshot) {
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
    } catch (e) {
      print("ERROR EXCEPTION : e=$e");
    }
  }

  @override
  void initState() {
    super.initState();
    setUpDummyData();
  }

  DateTime selectedDate;
  var days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  var dayName = " ";

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
        _resetData(dayName, selectedDate);
      });
  }

  void isDatasetChanged(bool isChanged) {
    if (isChanged) {
      print("GOING TO resetData() function");
      _resetData(dayName, selectedDate);
    } else {
      print("DATASET did not changed");
    }
  }

  Future<void> _resetData(String today, DateTime selectedDate) async {
    dummyData.clear();
    try {
      await availableRoomsByDayDb
          .child(today.toUpperCase())
          .once()
          .then((DataSnapshot snapshot) {
        var values = snapshot.value;
        print("AVAILABLE values = ${values}");
        dummyData.clear();

        if (values != null) {
          Map<dynamic, dynamic> valueList = snapshot.value;
          valueList.forEach((key, value) {
            AvailableItem item = AvailableItem(
              roomNo: value['roomNo'].toString(),
              startTime: value['startTime'].toString(),
              endTime: value['endTime'].toString(),
              itemKey: key.toString(),
              status: value['status'] ?? " ",
            );
            dummyData.add(item);
          });
          print(".............................FINISHED LOOOP!!!");
          setState(() {});
        }
      });

      today = "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
      await availableRoomsByDateDb
          .child(today)
          .once()
          .then((DataSnapshot snapshot) {
        var values = snapshot.value;
        print("AVAILABLE values = ${values}");

        if (values != null) {
          Map<dynamic, dynamic> valueList = snapshot.value;
          valueList.forEach((key, value) {
            AvailableItem item = AvailableItem(
              roomNo: value['roomNo'].toString(),
              startTime: value['startTime'].toString(),
              endTime: value['endTime'].toString(),
              itemKey: key.toString(),
              status: value['status'] ?? " ",
            );
            dummyData.add(item);
          });
          print(".............................FINISHED LOOOP!!!");
          setState(() {});
        }
      });

      await bookedRoomsDb.child(today).once().then((DataSnapshot snapshot) {
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
    } catch (e) {
      print("ERROR EXCEPTION : e=$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    print("AVAILABLE SCREEN : dummyDATA = $dummyData");
    return Scaffold(
        appBar: AppBar(
          title: Text("Available Rooms"),
          centerTitle: true,
        ),
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
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Routine", style: TextStyle(fontSize: 26)),
                  */ /*GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AvailableScreen()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.add),
                    ),
                  ),*/ /*
                ],
              ),*/
              Expanded(
                child: dummyData.length == 0
                    ? Text("NO ITEM")
                    : ListView.builder(
                        itemCount: dummyData.length,
                        itemBuilder: (context, i) => Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: AvailableItemTile(
                            dummyData: dummyData[i],
                            date:
                                "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                            datasetChanged: isDatasetChanged,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ));
  }
}
