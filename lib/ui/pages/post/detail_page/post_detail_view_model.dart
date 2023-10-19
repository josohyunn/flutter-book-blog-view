import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/param_provider.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// 창고 데이터
// 값 받는법 : PostDetailViewModel(family)로 받는법 or 통신으로 받는법 2가지있음
class PostDetailModel {
  Post post;
  PostDetailModel(this.post);
}

// 창고
class PostDetailViewModel extends StateNotifier<PostDetailModel?> {
  PostDetailViewModel(super._state, this.ref);

  Ref ref;

  Future<void> notifyInit(int id) async {
    Logger().d("notifyInit");
    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().fetchPost(sessionUser.jwt!, id);
    state = PostDetailModel(responseDTO.data);
  }
}

// 창고 관리자
// family : 창고 관리자한테 데이터를 전달해주는 방법
// 왜 id를 전달받았나? 통신 코드인 notifyInit()호출하기 위해서
// autoDispose하는 이유 : 예를들어 4번 글을 상세보기 하면 데이터는 null인 화면을 주고, 통신을 통해 제목4와 내용4를 가져온다.
// 하지만 PostDetailModel는 싱글톤 패턴(new를 한번만 한다.)이기 때문에 통신을 통해 메모리에 제목4, 내용4가 떠있으면 다음에 다시 호출해도 캐싱하기 때문에 제목4, 내용4를 불러온다.
// 고로 뒤로갔다가 2번 글을 선택하면 먼저 view의 데이터는 null이 들어오게 되고 후에 메모리에서 값을 가져와야 하는데 싱글톤이기 때문에 (제목2, 내용2가 아닌) 제목4와 내용4가 불러오게 된다.
// 그래서 메모리까지 날려주기 위해 autoDispose를 해주어야 한다.
final postDetailProvider =
    StateNotifierProvider.autoDispose<PostDetailViewModel, PostDetailModel?>(
        (ref) {
  int postId = ref.read(paramProvider).postDetailId!;
  return PostDetailViewModel(null, ref)..notifyInit(postId);
});
