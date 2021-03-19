import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:make_up_class_schedule/model/available_item.dart';
import 'package:make_up_class_schedule/model/available_item_tile.dart';

class AvailableScreen extends StatefulWidget {
  @override
  _AvailableScreenState createState() => _AvailableScreenState();
}

class _AvailableScreenState extends State<AvailableScreen> {
  final availableRoomDb = FirebaseDatabase.instance.reference().child("AvailableRooms");
  final bookedRoomsDb = FirebaseDatabase.instance.reference().child("BookedRooms");
  List<AvailableItem> dummyData = [];

  @override
  void initState() {
    super.initState();

    DateTime date = DateTime.now();
    var today = DateFormat('EEEE').format(date);

    try{
      availableRoomDb.child(today).once().then((DataSnapshot snapshot){
        var values = snapshot.value;
        print("AVAILABLE values = ${values}");
        dummyData.clear();

        try{
          var length = values.length;
          print("LENGTH = $length");
          for(var i=0; i<length; i++){
            var item = AvailableItem();
            item.endTime = values[i]["endTime"] == null ? "" : values[i]["endTime"];
            item.roomNo = values[i]["roomNo"] == null ? "" : values[i]["roomNo"];
            item.startTime = values[i]["startTime"] == null ? "" : values[i]["startTime"];
            item.status = values[i]["status"] == null ? "" : values[i]["status"];

            dummyData.add(item);
          }
        }
        catch(e){
          print("AVAILABLE CLASSES INNER ERROR1 = $e");
        }
        print(".............................FINISHED LOOOP!!!");
        setState(() {
        });
      });
    }
    catch(e){
      print("AVAILABLE CLASSES: OUTSIDE ERROR1 = $e");
    }

    today = "${date.day}-${date.month}-${date.year}";
    try{
      bookedRoomsDb.child(today).once().then((DataSnapshot snapshot){
        var values = snapshot.value;
        print("BOOKED values = $values");

        try{
          var length = values.length;
          print("LENGTH = $length");
          for(var i=0; i<length; i++){
            var item = AvailableItem();
            item.endTime = values[i]["endTime"] == null ? "" : values[i]["endTime"];
            item.roomNo = values[i]["roomNo"] == null ? "" : values[i]["roomNo"];
            item.startTime = values[i]["startTime"] == null ? "" : values[i]["startTime"];
            item.status = values[i]["status"] == null ? "" : values[i]["status"];

            dummyData.remove(item);
          }
        }
        catch(e){
          print("AVAILABLE CLASSES INNER ERROR2 = $e");
        }

        print(".............................FINISHED LOOOP!!!");
        setState(() {
        });
      });
    }
    catch(e){
      print("AVAILABLE CLASSES OUTSIDE ERROR2 = $e");
    }
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
        dayName = days[selectedDate.weekday];
        _resetData(dayName, selectedDate);
      });
  }

  void _resetData(String today, DateTime selectedDate) {
    dummyData.clear();

    availableRoomDb.child(today).once().then((DataSnapshot snapshot){
      var values = snapshot.value;
      dummyData.clear();

      var length = values.length;
      print("LENGTH = $length");
      for(var i=0; i<length; i++){
        var item = AvailableItem();
        item.endTime = values[i]["endTime"] == null ? "" : values[i]["endTime"];
        item.roomNo = values[i]["roomNo"] == null ? "" : values[i]["roomNo"];
        item.startTime = values[i]["startTime"] == null ? "" : values[i]["startTime"];
        item.status = values[i]["status"] == null ? "" : values[i]["status"];

        dummyData.add(item);
      }
      print(".............................FINISHED LOOOP!!!");
      setState(() {
      });
    });

    today = "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
    bookedRoomsDb.child(today).once().then((DataSnapshot snapshot){
      var values = snapshot.value;

      var length = values.length;
      print("LENGTH = $length");
      for(var i=0; i<length; i++){
        var item = AvailableItem();
        item.endTime = values[i]["endTime"] == null ? "" : values[i]["endTime"];
        item.roomNo = values[i]["roomNo"] == null ? "" : values[i]["roomNo"];
        item.startTime = values[i]["startTime"] == null ? "" : values[i]["startTime"];
        item.status = values[i]["status"] == null ? "" : values[i]["status"];

        dummyData.remove(item);
      }
      print(".............................FINISHED LOOOP!!!");
      setState(() {
      });
    });
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
                        "${days[selectedDate.weekday]} ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
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
                    child: AvailableItemTile(dummyData[i]),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
