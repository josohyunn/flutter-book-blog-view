import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/provider/param_provider.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_view_model.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListBody extends ConsumerWidget {
  const PostListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 구독(구독하는 순간 창고관리자가 실행됨)
    PostListModel? model = ref.watch(postListProvider); // state == null

    List<Post> posts = [];

    if (model != null) {
      posts = model.posts;
    }

    return ListView.separated(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // // 여기서 selectedPost에 선택된 Post값 넣어주기
            // // Detail 창고 관리자에게 post id를 전달(동적)
            // ref.read(postDetailProvider(posts[index].id));

            // 1. postId를 paramStore에 저장
            ParamStore paramStore = ref.read(paramProvider);
            paramStore.postDetailId = posts[index].id;

            // 2. 화면 이동
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        PostDetailPage())); // 코드 추가(파라메터) - 위에 [index].id로 넘기는걸로 바꿈
            // id만 넘긴다-통신한다
            // id만 넘기는 이유?
          },
          child: PostListItem(posts[index]),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
