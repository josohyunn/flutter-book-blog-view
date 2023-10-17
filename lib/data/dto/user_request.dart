class JoinReqDTO {
  String username;
  String password;
  String email;

  JoinReqDTO({
    required this.username,
    required this.password,
    required this.email,
  });

  // json으로 데이터를 준다.(프론트 -> 백)
  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "email": email,
      };
}

class LoginReqDTO {
  final String username;
  final String password;

  LoginReqDTO({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
