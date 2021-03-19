import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/model/item_tile.dart';
import 'package:make_up_class_schedule/model/schedule_item.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final database = FirebaseDatabase.instance.reference().child("TodayClass");
  List<ScheduleItem> dummyData = [];

  @override
  void initState() {
    super.initState();
    database.once().then((DataSnapshot snapshot){
      var data = snapshot.value;
      var values = snapshot.value;
      // var keys = snapshot.value.keys;
      dummyData.clear();
      print("DATA...... = .....$data");
      print("VALUES...... = .....$values");
      /*print("KEYS...... = .....$keys");
      print("VALUES...... = .....$values");*/

      for(var value in values){
        print("value = $value");
        print("value = ${value["courseId"]}");
        print("value type = ${value.runtimeType}");
        print("value[courseId] type = ${value["courseId"].runtimeType}");
        // print("value = ${value.courseId}");

        /*Map itemMap = jsonDecode(value);
        print("itemMap = $itemMap");
        var item = ScheduleItem.fromJson(itemMap);*/
        // var item = ScheduleItem.fromJson(value);
        // print("ITEM BEFORE = $item");


        var item = ScheduleItem();
        item.courseId = value["courseId"] == null ? "" : value["courseId"];
        item.endTime = value["endTime"] == null ? "" : value["endTime"];
        item.roomNo = value["roomNo"] == null ? "" : value["roomNo"];
        item.startTime = value["startTime"] == null ? "" : value["startTime"];
        item.status = value["status"] == null ? "" : value["status"];



        /*item.courseId = value.courseId == null ? "" : value.courseId;
        item.endTime = value.endTime == null ? "" : value.endTime;
        item.roomNo = value.roomNo == null ? "" : value.roomNo;
        item.startTime = value.startTime == null ? "" : value.startTime;
        item.status = value.status == null ? "" : value.status;*/
        print("ITEM = $item");
        dummyData.add(item);
      }
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
      setState(() {
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, "/login_screen", (r) => false);
                })
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: _height,
          decoration: BoxDecoration(color: Color(0xFFE4ECF1)),
          child: ListView.builder(
            itemCount: dummyData.length,
            itemBuilder: (context, i) =>
              /*Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ItemTile(dummyData[i]),
                ),*/
                Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                  child: ItemTile(dummyData[i])
                ),
          ),
        ),
      ),
    );
  }
}
