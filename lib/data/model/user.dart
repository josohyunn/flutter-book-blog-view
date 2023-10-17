import 'package:intl/intl.dart';

class User {
  int id;
  String username;
  String email;
  DateTime created;
  DateTime updated;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.created,
      required this.updated});

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "created": created,
        "updated": updated
      };

  // :쓰는 이유 : 생성자가 생성되기 전에 객체를 초기화하고 만들어진다.
  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        username = json["username"],
        email = json["email"],
        created = DateFormat("yyyy-mm-dd").parse(json["created"]), // 3
        updated = DateFormat("yyyy-mm-dd").parse(json["updated"]);
}
