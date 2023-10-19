import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 창고 데이터
class RequestParam {
  int? postDetailId;
  //int? commentId;

  RequestParam({this.postDetailId});

  void reset() {
    postDetailId = null;
    //commentId = null;
  }
}

// 2. 창고(비지니스 로직이 들어간다.)
class ParamStore extends RequestParam {
  void addPostDetailId(int postId) {
    final mContext = navigatorKey.currentContext;
  }
}

// 3. 창고 관리자
final paramProvider = Provider<ParamStore>((ref) {
  return ParamStore();
});
