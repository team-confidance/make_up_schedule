import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:make_up_class_schedule/model/available_item.dart';
import 'package:make_up_class_schedule/utils/constraints.dart';

class AvailableItemTile extends StatelessWidget {
  final AvailableItem dummyData;

  AvailableItemTile(this.dummyData);

  @override
  Widget build(BuildContext context) {
    print("AVAILABLE ITEM TILE: dummyData = $dummyData");
    return Container(
      padding: EdgeInsets.fromLTRB(10,10,0,10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Room - " + dummyData.roomNo.toString(), style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, color: Color(0xFFA6BECB),size: 14,),
                  Text(" " + dummyData.startTime.toString() + " - " + dummyData.endTime.toString()+"    ",style: TextStyle(color: Colors.grey)),
                  Icon(Icons.stacked_bar_chart, color: Color(0xFFA6BECB),size: 14,),
                  Text(
                    " "+dummyData.status.toString(),
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
    if (status == "Another Class")
      return Colors.red;
    else if (status == "Available")
      return Colors.greenAccent[400];
  }
}
