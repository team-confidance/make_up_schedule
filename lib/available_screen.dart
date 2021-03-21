import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  List<AvailableItem> dummyData = [];

  @override
  void initState() {
    super.initState();
    availableRoomsByDayDb = reference.child("AvailableRoomsByDay");
    availableRoomsByDateDb = reference.child("AvailableRoomsByDate");

    var today = widget.day;
    dayName = widget.day;
    selectedDate = widget.date;

    try {
      availableRoomsByDayDb.child(today.toUpperCase()).once().then((DataSnapshot snapshot) {
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
              itemKey: value['itemKey'].toString(),
              status: value['status'] ?? " ",
            );
            dummyData.add(item);
          });
          print(".............................FINISHED LOOOP!!!");
          setState(() {});
        }
      });

      today = "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";;
      availableRoomsByDateDb.child(today).once().then((DataSnapshot snapshot) {
        var values = snapshot.value;
        print("AVAILABLE values = ${values}");

        if (values != null) {
          Map<dynamic, dynamic> valueList = snapshot.value;
          valueList.forEach((key, value) {
            AvailableItem item = AvailableItem(
              roomNo: value['roomNo'].toString(),
              startTime: value['startTime'].toString(),
              endTime: value['endTime'].toString(),
              itemKey: value['itemKey'].toString(),
              status: value['status'] ?? " ",
            );
            dummyData.add(item);
          });
          print(".............................FINISHED LOOOP!!!");
          setState(() {});
        }
      });
    }
    catch (e) {
      print("ERROR EXCEPTION : e=$e");
    }
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

  void isDatasetChanged(bool isChanged){
    if(isChanged){
      print("GOING TO resetData() function");
      _resetData(dayName, selectedDate);
    }
    else{
      print("DATASET did not changed");
    }
  }

  void _resetData(String today, DateTime selectedDate) {
    dummyData.clear();
    try {
      availableRoomsByDayDb.child(today.toUpperCase()).once().then((DataSnapshot snapshot) {
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
              itemKey: value['itemKey'].toString(),
              status: value['status'] ?? " ",
            );
            dummyData.add(item);
          });
          print(".............................FINISHED LOOOP!!!");
          setState(() {});
        }
      });

      today = "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
      availableRoomsByDateDb.child(today).once().then((DataSnapshot snapshot) {
        var values = snapshot.value;
        print("AVAILABLE values = ${values}");

        if (values != null) {
          Map<dynamic, dynamic> valueList = snapshot.value;
          valueList.forEach((key, value) {
            AvailableItem item = AvailableItem(
              roomNo: value['roomNo'].toString(),
              startTime: value['startTime'].toString(),
              endTime: value['endTime'].toString(),
              itemKey: value['itemKey'].toString(),
              status: value['status'] ?? " ",
            );
            dummyData.add(item);
          });
          print(".............................FINISHED LOOOP!!!");
          setState(() {});
        }
      });
    }
    catch (e) {
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
                        "$dayName ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
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
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Routine", style: TextStyle(fontSize: 26)),
                  *//*GestureDetector(
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
                  ),*//*
                ],
              ),*/
              Expanded(
                child: ListView.builder(
                  itemCount: dummyData.length,
                  itemBuilder: (context, i) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: AvailableItemTile(dummyData: dummyData[i], date: "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}", datasetChanged: isDatasetChanged,),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
