import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {

  String email;
  String name;
  String phone;
  String address;
  String deviceToken;

  User({
    this.email,
    this.name,
    this.address,
    this.phone,
    this.deviceToken
  });

  factory User.fromJson(Map<dynamic, dynamic> json) => new User(
    address: json["address"],
    email: json["email"],
    deviceToken: json["device_token"],
    name: json["name"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "address": address,
    "device_token": deviceToken,
    "name": name,
    "phone": phone,
  };
}
