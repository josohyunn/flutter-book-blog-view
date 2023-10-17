import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 화면에 뿌릴 데이터 : ViewModel

// 1. 창고 데이터
class PostListModel {
  List<Post> posts;
  PostListModel(this.posts);
}

// 2. 창고
// 처음에 빈 화면(null)을 주고 통신이 끝나면 값을 가져올 수 있으므로 extends의 PostListModel은 ?가 붙어야한다.
class PostListViewModel extends StateNotifier<PostListModel?> {
  // state타입 : stateNotifier의 <>안의 타입 따라감
  PostListViewModel(super._state, this.ref);

  Ref ref;

  // init : state값을 변경하면 항상 view에 알려준다.
  Future<void> notifyInit() async {
    // jwt 가져오기
    SessionUser sessionUser = ref.read(sessionProvider);

    ResponseDTO responseDTO =
        await PostRepository().fetchPostList(sessionUser.jwt!);
    state = PostListModel(responseDTO.data);
  }
}

// 3. 창고 관리자(View가 빌드되기 직전에 생성됨)
// autoDispose : 메모리관리 해줌(View가 파괴되면 ViewModel도 파괴)
final postListProvider =
    StateNotifierProvider.autoDispose<PostListViewModel, PostListModel?>((ref) {
  return PostListViewModel(null, ref)..notifyInit();
});
