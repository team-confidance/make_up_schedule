import 'package:make_up_class_schedule/utils/constants.dart';

class AvailableItem {
  var startTime = "09:00AM";
  var endTime = "12:00PM";
  var roomNo = "123";
  var status = "available";
  var itemKey = "";
  var regularItemKeyInThisTime = "";
  var regularItemRoomInThisTime = "";

  AvailableItem({this.regularItemRoomInThisTime, this.regularItemKeyInThisTime, this.startTime, this.endTime, this.roomNo, this.status, this.itemKey});
  AvailableItem.fromJson(Map<dynamic, dynamic> json)
      : startTime = json['startTime'],
        endTime = json['endTime'],
        roomNo = json['roomNo'],
        status = json['status'],
        itemKey = json['itemKey'],
        regularItemKeyInThisTime = json[Constants.regularItemKeyInThisTime],
        regularItemRoomInThisTime = json[Constants.regularItemRoomInThisTime];
}