class LoginInfo{
  var email = "example@email.com";
  var password = "123456";
  var name = "ExampleName";
  var designation = "Designation";
  var phone = "Phone";
  var photoUrl = "photoUrl";
  var firebaseKey = "firebaseKey";
  var isAdmin = "isAdmin";
  var currentPassword = "currentPassword";

  LoginInfo({this.currentPassword, this.isAdmin, this.email, this.password, this.name, this.designation, this.phone, this.photoUrl, this.firebaseKey});
  LoginInfo.fromJsond(Map<dynamic,dynamic> json)
    : email = json['email'],
      password = json['password'],
      name = json['name'],
      designation = json['designation'],
      phone = json['phone'],
      photoUrl = json['photoUrl'],
      firebaseKey = json['firebaseKey'],
      isAdmin = json['isAdmin'];
}