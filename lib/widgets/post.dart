import 'package:app/helper/map_helper.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../model/media.dart';
import '../model/post.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final Media media;
  final Function(Post) onLike;

  PostWidget(
      {super.key,
      required this.post,
      required this.media,
      required this.onLike});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late VideoPlayerController videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    setState(() {
      videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.media.link));
    });
    _initializeVideoPlayerFuture = videoController.initialize();
    videoController.setVolume(1);
    videoController.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.drawer,
      title: Center(child: Text(widget.post.title, style: TextStyle(fontSize: 27))),
      subtitle: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: videoController.value.aspectRatio,
              child: Column(children
                  : [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: VideoPlayer(videoController),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          if (videoController.value.isPlaying) {
                            videoController.pause();
                          } else {
                            videoController.play();
                          }
                        });
                      },
                      child: Icon(
                        videoController.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (widget.post.longitude != null &&
                            widget.post.latitude != null) {
                          MapHelper.navigateTo(
                              double.parse(widget.post.latitude!),
                              double.parse(widget.post.longitude!));
                        }
                      },
                      child: const Icon(
                        Icons.map_outlined,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    FloatingActionButton(
                        onPressed: () => widget.onLike(widget.post),
                        child: Icon(
                            widget.post.favorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red)),
                  ],
                ),
              ]),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
