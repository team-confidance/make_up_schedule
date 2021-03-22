import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/model/schedule_item.dart';
import 'package:make_up_class_schedule/utils/constraints.dart';

class ItemTile extends StatefulWidget {
  final ScheduleItem dummyData;
  final String date;
  Function datasetChanged;
  Function progressLoading;
  ItemTile({Key key, this.progressLoading, this.dummyData, this.date, this.datasetChanged}) : super(key: key);
  @override
  _ItemTileState createState() => _ItemTileState();
}

var tileWidth = 50.0, tileHeight = 25.0;

class _ItemTileState extends State<ItemTile> {
  bool isRoomInOneWord(List<String> afterSplit){
    print("isRoomInOneWord:: afterSplit = $afterSplit");
    if(afterSplit.length>1){
      setState(() {
        tileHeight = 30.0;
      });
      return false;
    }
    else{
      return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    var afterSplit = widget.dummyData.roomNo.split(' ');
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xFFF8F8F8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.dummyData.courseId, style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: Color(0xFFA6BECB),
                    size: 14,
                  ),
                  Text(
                      " " +
                          convertString(widget.dummyData.startTime) +
                          " - " +
                          convertString(widget.dummyData.endTime) +
                          "    ",
                      style: TextStyle(color: Colors.grey)),
                  Icon(
                    Icons.stacked_bar_chart,
                    color: Color(0xFFA6BECB),
                    size: 14,
                  ),
                  Text(
                    widget.dummyData.section,
                    /*style: TextStyle(
                        color: statusColorOf(widget.dummyData.status),
                        fontWeight: FontWeight.bold),*/
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              Column(children: [
                /*Text("Room No",
                    style: TextStyle(fontSize: 8, color: Colors.black)),*/
                Container(
                  /*height: tileHeight,
                  width: tileWidth,*/
                  decoration: BoxDecoration(
                    // color: Color(0x20FF0070),
                    color: Color(0xFF69C25A),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0)
                    ),
                    // border: Border.all(color: Color(0xFF376D28)),
                  ),
                  child: Center(
                    child: isRoomInOneWord(afterSplit) ? Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                      child: Text(
                        widget.dummyData.roomNo.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ) : Container(
                      margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            afterSplit[0],
                            style: TextStyle(
                              // color: Color(0xff565756),
                              color: Colors.white,
                              fontSize: 10,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            afterSplit[1],
                            style: TextStyle(
                              // color: Color(0xff565756),
                              color: Colors.white,
                              fontSize: 15,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ]),
              PopupMenuButton(
                onSelected: (value) async {
                  toast(context, "Clicked on $value");
                  if(value == 1){
                    setState(() {
                      widget.progressLoading(true);
                    });
                    var itemKey = widget.dummyData.itemKey;
                    var result = await cancelClass(itemKey, widget.date);
                    if(result == null){
                      setState(() {
                        widget.datasetChanged(true);
                        widget.progressLoading(false);
                      });
                    }
                    else{
                      print(result);
                      setState(() {
                        widget.progressLoading(false);
                      });
                    }
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text('Cancel Class'),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text('Change Title'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  statusColorOf(String status) {
    if (status == "Canceled")
      return Colors.red;
    else if (status == "Upcoming")
      return Colors.orange;
    else if (status == "Running")
      return Colors.greenAccent[400];
    else if (status == "Completed") return Colors.grey;
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

  Future<String> cancelClass(String itemKey, String date) async {
    try{
      DatabaseReference reference = await FirebaseDatabase.instance.reference();
      await reference.child("CancelledSchedule").child(date).child("AAC").push().set({
        "itemKey" : itemKey,
      });
      print("SUCCESSFULLY added in CANCELLED!!");
      await reference.child("AvailableRoomsByDate").child(date).push().set(
        {
          "roomNo" : widget.dummyData.roomNo,
          "startTime" : widget.dummyData.startTime,
          "endTime" : widget.dummyData.endTime,
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
