import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:logger/logger.dart';

// 컨벤션:
// deletePost, updatePost, savePost
// fetchPost, fetchPostList

// View -> Provider(전역provider / view model) -> Repository 요청
// 책임 : 통신과 파싱
// 여기서 Ref에 접근하면 안된다. 책임이 없기 때문
class PostRepository {
  // 통신
  Future<ResponseDTO> fetchPostList(String jwt) async {
    // 통신은 무조건 try-catch 있어야됨
    try {
      // 1.통신
      // 헤더 주는 이유 : 토큰 전달하기 위해서
      final response = await dio.get("/post",
          options: Options(headers: {"Authorization": "${jwt}"}));

      // 2. ResponseDTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      // 3. ResponseDTO의 data 파싱
      List<dynamic> mapList =
          responseDTO.data as List<dynamic>; // dynamic 하나하나 : Map형
      List<Post> postList = mapList.map((e) => Post.fromJson(e)).toList();

      // // 4. 파싱된 데이터를 다시 공통 DTO로 덮어씌우기
      responseDTO.data = postList;

      return responseDTO;
    } catch (e) {
      // dio는 200이 아니면 catch로 간다.
      return ResponseDTO(-1, "게시글 목록 불러오기 실패.", null);
    }
  }

  Future<ResponseDTO> savePost(String jwt, PostSaveReqDTO dto) async {
    try {
      // 1.통신
      // 헤더 주는 이유 : 토큰 전달하기 위해서
      final response = await dio.post("/post",
          data: dto.toJson(),
          options: Options(headers: {"Authorization": "${jwt}"}));

      Logger().d(response.data);

      // 2. ResponseDTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      Logger().d(response.data);

      // 3. ResponseDTO의 data 파싱
      Post post = Post.fromJson(responseDTO.data); // Map으로 바로 받음

      // // 4. 파싱된 데이터를 다시 공통 DTO로 덮어씌우기
      responseDTO.data = post;

      return responseDTO;
    } catch (e) {
      // dio는 200이 아니면 catch로 간다.
      return ResponseDTO(-1, "게시글 작성 실패", null);
    }
  }

  Future<ResponseDTO> fetchPost(String jwt, int id) async {
    try {
      // 통신
      Response response = await dio.get("/post/$id",
          options: Options(headers: {"Authorization": "$jwt"}));

      // 응답 받은 데이터 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = Post.fromJson(responseDTO.data);

      return responseDTO;
    } catch (e) {
      return ResponseDTO(-1, "게시글 한건 불러오기 실패", null);
    }
  }
}
