class AvailableItem {
  var startTime = "09:00AM";
  var endTime = "12:00PM";
  var roomNo = "123";
  var status = "available";

  AvailableItem({this.startTime, this.endTime, this.roomNo, this.status});
  AvailableItem.fromJson(Map<dynamic, dynamic> json)
      : startTime = json['startTime'],
        endTime = json['endTime'],
        roomNo = json['roomNo'],
        status = json['status'];
}