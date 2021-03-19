import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/model/schedule_item.dart';
import 'package:make_up_class_schedule/utils/constraints.dart';

class ItemTile extends StatelessWidget {
  final ScheduleItem dummyData;

  ItemTile(this.dummyData);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10,10,0,10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dummyData.courseId, style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, color: Color(0xFFA6BECB),size: 14,),
                  Text(" " + dummyData.startTime + " - " + dummyData.endTime.toString()+"    ",style: TextStyle(color: Colors.grey)),
                  Icon(Icons.stacked_bar_chart, color: Color(0xFFA6BECB),size: 14,),
                  Text(
                    dummyData.status,
                    style: TextStyle(
                        color: statusColorOf(dummyData.status),
                        fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              Column(children: [
                Text("Room No",
                    style: TextStyle(fontSize: 8, color: Colors.black)),
                Container(
                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Color(0x20FF0070),
                    borderRadius: BorderRadius.all(Radius.elliptical(100, 80)),
                  ),
                  child: Center(
                      child: Text(dummyData.roomNo.toString(),
                          style: TextStyle(
                              color: Color(0xff565756),
                              fontSize: 20,
                              fontWeight: FontWeight.bold))),
                )
              ]),
              PopupMenuButton(
                onSelected: (value) {
                  toast(context, "Clicked on $value");
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
}
