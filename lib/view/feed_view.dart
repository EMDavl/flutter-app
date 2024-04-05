import 'package:app/model/post.dart';
import 'package:app/repository/post_repository.dart';
import 'package:flutter/material.dart';

import '../model/media.dart';
import '../repository/media_repository.dart';
import '../widgets/post.dart';

class FeedView extends StatefulWidget {
  late PostRepository postRepo;
  late MediaRepository mediaRepo;

  FeedView({super.key}) {
    postRepo = PostRepository();
    mediaRepo = MediaRepository();
  }

  @override
  State<StatefulWidget> createState() => FeedViewState();
}

class FeedViewState extends State<FeedView> {
  final Map<Post, Media> _posts = {};

  @override
  void initState() {
    Map<Post, Media> someMap = {};
    super.initState();
    Future<List<Post>> pageFut = widget.postRepo.postsPage(0, 20);
    pageFut.then((value) async {
      for (final post in value) {
        someMap[post] = await widget.mediaRepo.getByPost(post.id);
      }
    }).then((value) => setState(() {
          _posts.addAll(someMap);
        })
    );
  }

  void _onLike(Post post) {
    post.favorite = !post.favorite;
    if (post.favorite) {
      widget.postRepo.likePost(post.id);
    } else {
      widget.postRepo.dislikePost(post.id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var keys = _posts.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
        titleTextStyle: const TextStyle(color: Colors.green, fontSize: 25.0),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            Post post = keys[index];
            Media media = _posts[post]!;
            return Column(
              children: [
                PostWidget(
                  post: post,
                  media: media,
                  onLike: _onLike,
                )
              ],
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }
}
