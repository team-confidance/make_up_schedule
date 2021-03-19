class ScheduleItem {
  var courseId = "CSE-2311";
  var courseName = "CSE-2311";
  var section = "9D";
  var startTime = "09:00AM";
  var endTime = "12:00PM";
  var status = "CSE-2311";
  var roomNo = "123";

  ScheduleItem(
      {this.courseId, this.courseName, this.startTime, this.endTime, this.status, this.roomNo});

  ScheduleItem.fromJson(Map<dynamic, dynamic> json)
      : courseId = json['courseId'],
        courseName = json['courseName'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        status = json['status'],
        roomNo = json['roomNo'];
}


/*List<ScheduleItem> dummyData=[
  ScheduleItem(courseId: "CSE-2211",courseName: "Introduction to Computer",startTime: "10:30AM",endTime: "12:00PM",status:"Upcoming", roomNo: "309"),
  ScheduleItem(courseId: "EEE-1233",courseName: "Electric & Electronics I",startTime: "11:30AM",endTime: "01:00PM",status:"Upcoming", roomNo: "309"),
  ScheduleItem(courseId: "PHY-2211",courseName: "Fundamentals of Physics",startTime: "12:30PM",endTime: "02:00PM",status:"Running", roomNo: "309"),
  ScheduleItem(courseId: "BBA-1111",courseName: "Accounting & Management",startTime: "01:30PM",endTime: "03:00PM",status:"Canceled", roomNo: "309"),
  ScheduleItem(courseId: "CSE-2211",courseName: "Algorithm",startTime: "02:30PM",endTime: "04:00PM",status:"Completed", roomNo: "309"),
  ScheduleItem(courseId: "BAN-1111",courseName: "Bangla Grammar",startTime: "04:30PM",endTime: "05:30PM",status:"Completed", roomNo: "309"),
  ScheduleItem(courseId: "BBA-2211",courseName: "Fundamentals of Finance",startTime: "03:30PM",endTime: "05:00PM",status:"Upcoming", roomNo: "309"),
  ScheduleItem(courseId: "EEE-2211",courseName: "Digital Device",startTime: "03:30PM",endTime: "05:00PM",status:"Upcoming", roomNo: "309"),
  ScheduleItem(courseId: "CSE-2211",courseName: "Data Encryption",startTime: "03:30PM",endTime: "05:00PM",status:"Running", roomNo: "309"),
  ScheduleItem(courseId: "EEE-2211",courseName: "Device Controlling",startTime: "03:30PM",endTime: "05:00PM",status:"Canceled", roomNo: "309"),
  ScheduleItem(courseId: "CSE-2211",courseName: "Software Engineering",startTime: "03:30PM",endTime: "05:00PM",status:"Upcoming", roomNo: "309"),
  ScheduleItem(courseId: "CSE-2211",courseName: "Object Orientation Programming",startTime: "03:30PM",endTime: "05:00PM",status:"Canceled", roomNo: "309"),
  ScheduleItem(courseId: "EEE-2211",courseName: "Electric & Electronics II",startTime: "03:30PM",endTime: "05:00PM",status:"Upcoming", roomNo: "309"),
  ScheduleItem(courseId: "CSE-2211",courseName: "Computer Programming",startTime: "03:30PM",endTime: "05:00PM",status:"Upcoming", roomNo: "309"),
  ScheduleItem(courseId: "ENG-2211",courseName: "Introduction to Speaking English",startTime: "03:30PM",endTime: "05:00PM",status:"Running", roomNo: "309"),
  ScheduleItem(courseId: "ENG-2211",courseName: "Introduction to Writing English",startTime: "03:30PM",endTime: "05:00PM",status:"Upcoming", roomNo: "309"),
  ScheduleItem(courseId: "ENG-2211",courseName: "Introduction to Reading English",startTime: "03:30PM",endTime: "05:00PM",status:"Canceled", roomNo: "309"),
];*/
