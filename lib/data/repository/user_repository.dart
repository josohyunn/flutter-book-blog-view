import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';

// View -> Provider(전역provider / view model) -> Repository 요청
// 책임 : 통신과 파싱
class UserRepository {
  // 통신
  Future<ResponseDTO> fetchJoin(JoinReqDTO requestDTO) async {
    // 통신은 무조건 try-catch 있어야됨
    try {
      // dynamic -> http body
      Response<dynamic> response =
          await dio.post("/join", data: requestDTO.toJson()); // 통신 끝
      // ※ ResponseDTO<T>로 못받는 이유 : ResponseDTO에서 파싱을 해주어야 하는데 들어오는 데이터가 어떤 데이터타입인지 모르니까 파싱을 정의할 수 없기 때문에
      // 1. ResponseDTO 파싱하기(dynamic타입 - 실제 들어있는 타입은 Map타입)
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      // 2. User객체로 파싱하기(회원가입 에서는 프론트에서 데이터를 받아오기만 하면 되기 때문에 User로 파싱할 필요가 없다.)
      // User user = User.fromJson(responseDTO.data);

      // 3. responseDTO는 파싱 완료된 responseDTO
      // responseDTO.data = User.fromJson(responseDTO.data);

      return responseDTO;
    } catch (e) {
      // dio는 200이 아니면 catch로 간다.
      return ResponseDTO(-1, "중복되는 유저명입니다.", null);
    }
  }

  Future<ResponseDTO> fetchLogin(LoginReqDTO requestDTO) async {
    // 통신은 무조건 try-catch 있어야됨
    try {
      Response<dynamic> response =
          await dio.post("/login", data: requestDTO.toJson()); // 통신 끝
      // ※ ResponseDTO<T>로 못받는 이유 : ResponseDTO에서 파싱을 해주어야 하는데 들어오는 데이터가 어떤 데이터타입인지 모르니까 파싱을 정의할 수 없기 때문에
      // 1. ResponseDTO 파싱하기(dynamic타입 - 실제 들어있는 타입은 Map타입)
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      // 2. User객체로 파싱하기
      // User user = User.fromJson(responseDTO.data);

      // // 3. responseDTO는 파싱 완료된 responseDTO
      responseDTO.data = User.fromJson(responseDTO.data);

      // 로그인 하면 토큰을 받아야 하기 때문에 3번을 실행하는 것.(3번 : 받아오는 건 Map형이기 때문에 파싱해주는 작업)
      final jwt = response.headers["Autorization"];

      if (jwt != null) {
        responseDTO.token = jwt.first; // first : 0번지
      }

      return responseDTO;
    } catch (e) {
      // dio는 200이 아니면 catch로 간다.
      return ResponseDTO(-1, "유저네임 혹은 비번이 틀렸습니다.", null);
    }
  }
}
