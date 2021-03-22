import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/model/available_item.dart';
import 'package:make_up_class_schedule/utils/constraints.dart';
import 'package:make_up_class_schedule/utils/custom_dialog.dart';

class AvailableItemTile extends StatefulWidget {
  final AvailableItem dummyData;
  final String date;
  Function datasetChanged;

  AvailableItemTile({this.dummyData, this.date, this.datasetChanged});

  @override
  _AvailableItemTileState createState() => _AvailableItemTileState();
}

class _AvailableItemTileState extends State<AvailableItemTile> {
  @override
  Widget build(BuildContext context) {
    print("AVAILABLE ITEM TILE: dummyData = ${widget.dummyData}");
    return Container(
      padding: EdgeInsets.fromLTRB(10,10,0,10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xFFF8F8F8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(" "+ widget.dummyData.roomNo.toString(), style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, color: Color(0xFFA6BECB),size: 14,),
                  Text(" " + convertString(widget.dummyData.startTime) + " - " + convertString(widget.dummyData.endTime) +"    ",style: TextStyle(color: Colors.grey)),
                  /*Icon(Icons.stacked_bar_chart, color: Color(0xFFA6BECB),size: 14,),
                  Text(
                    " "+widget.dummyData.status.toString(),
                    style: TextStyle(
                        color: statusColorOf(widget.dummyData.status),
                        fontWeight: FontWeight.bold),
                  )*/
                ],
              )
            ],
          ),
          Row(
            children: [
              PopupMenuButton(
                onSelected: (value) async {
                  toast(context, "Clicked on $value");
                  if(value == 1){
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            function: callBackFunction,
                          );
                        });

                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text('Book Class'),
                  ),
                  /*PopupMenuItem(
                    value: 2,
                    child: Text('Change Title'),
                  ),*/
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void callBackFunction(String courseInfo, String sectionInfo) async{
    var itemKey = widget.dummyData.itemKey;
    var result = await bookClass(itemKey, widget.date, courseInfo, sectionInfo);
    if(result == null){
      setState(() {
        widget.datasetChanged(true);
      });
    }
    else{
      print(result);
    }
  }
  statusColorOf(String status) {
    if (status == "Another Class")
      return Colors.red;
    else if (status == "Available")
      return Colors.greenAccent[400];
  }

  String convertString(String time){
    int totalTime = int.parse(time);
    int hour = 0, minute = 0;
    String amOrPm = "AM";
    if(totalTime>=720){
      hour = 12;
      totalTime -= 720;
      amOrPm = "PM";
    }
    hour += totalTime.toDouble()~/60;
    if(hour>=13) {
      hour-=12;
    }
    minute = totalTime % 60;
    String strHour = hour.toString(), strMinute = minute.toString();
    if(strHour.length == 1){
      strHour = "0$strHour";
    }
    if(strMinute.length == 1){
      strMinute = "0$strMinute";
    }
    String retString = "$strHour : $strMinute $amOrPm";
    return retString;
  }
  Future<String> bookClass(String itemKey, String date, String courseInfo, String sectionInfo) async {
    try{
      DatabaseReference reference = await FirebaseDatabase.instance.reference();
      await reference.child("BookedRooms").child(date).push().set({
        "itemKey" : itemKey,
      });
      print("SUCCESSFULLY added in CANCELLED!!");
      await reference.child("MakeupSchedule").child(date).child("AAC").push().set(
          {
            "roomNo" : widget.dummyData.roomNo,
            "startTime" : widget.dummyData.startTime,
            "endTime" : widget.dummyData.endTime,
            "courseId" : courseInfo,
            "section" : sectionInfo,
          }
      );
      print("SUCCESSFULLY added in AVAILABLE by DATE!!");
      return null;
    }
    catch (e){
      print("ERROR OCCURED in cancelling data!!");
      return "ERROR OCCURED in cancelling data!!";
    }
  }
}
