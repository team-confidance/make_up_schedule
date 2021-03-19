class LoginInfo{
  var email = "example@email.com";
  var password = "123456";
  LoginInfo({this.email, this.password});
  LoginInfo.fromJsond(Map<dynamic,dynamic> json)
    : email = json['email'],
      password = json['password'];
}