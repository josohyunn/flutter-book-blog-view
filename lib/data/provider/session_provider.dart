import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 책임 : 비즈니스 로직 처리

// 1. 창고 데이터
class SessionUser {
  // 1. 화면 context에 접근하는 법
  final mContext = navigatorKey.currentContext;

  User? user; // 로그인 안하면 null이기 때문에
  // 토큰 정보
  String? jwt;
  bool isLogin; // 시간이 만료될 수도 있기 때문에

  SessionUser({this.user, this.jwt, this.isLogin = false});

  Future<void> join(JoinReqDTO joinReqDTO) async {
    // 1. 통신 코드
    ResponseDTO responseDTO = await UserRepository().fetchJoin(joinReqDTO);

    // 2. 비즈니스 로직
    if (responseDTO.code == 1) {
      Navigator.pushNamed(mContext!, Move.loginPage);
    } else {
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text(responseDTO.msg)));
    }
  }

  Future<void> login(LoginReqDTO loginReqDTO) async {
    // 1. 통신 코드
    ResponseDTO responseDTO = await UserRepository().fetchLogin(loginReqDTO);

    // 2. 비즈니스 로직
    if (responseDTO.code == 1) {
      // 1. 세션값(창고데이터) 갱신
      this.user = responseDTO.data as User; // as : 다운캐스팅
      this.jwt = responseDTO.token!;
      this.isLogin = true;

      // 2. 디바이스에 JWT 저장 (자동 로그인)
      await secureStorage.write(key: "jwt", value: responseDTO.token);

      // 3. 페이지 이동
      Navigator.pushNamed(mContext!, Move.postListPage);
    } else {
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text(responseDTO.msg)));
    }
  }

  Future<void> logout() async {
    this.jwt = null;
    this.isLogin = false;
    this.user = null;

    // jwt는 로그아웃할 때 서버측으로 요청할 필요가 없음
    // await 안붙이면 jwt가 삭제되기 전에 로그인 페이지 가서 자동로그인이 된다.
    await secureStorage.delete(key: "jwt");

    Navigator.pushNamedAndRemoveUntil(
        mContext!,
        "/login",
        (route) =>
            false); // pushNamedAndRemoveUntil의 false : 다날리고 이동(pop해버리면 login페이지가 두개 겹쳐있기 때문)
  }
}

// 2. 창고 관리자
final sessionProvider = Provider<SessionUser>((ref) {
  return SessionUser();
});
