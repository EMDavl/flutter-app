import 'dart:io';

import 'package:app/controller/upload_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ConfirmationView extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmationView({super.key, required this.videoPath, required this.videoFile});

  @override
  State<ConfirmationView> createState() => _ConfirmationViewState();
}

class _ConfirmationViewState extends State<ConfirmationView> {
  late VideoPlayerController controller;
  late TextEditingController textController = TextEditingController();
  late UploadVideoController uploadVideoController = UploadVideoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.6,
              child: VideoPlayer(controller),
            ),
            const SizedBox(height: 30,),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextField(
                      controller: textController,
                    ),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(onPressed: () => uploadVideoController.uploadVideo(textController.text, widget.videoPath, context), child: Text("Save!"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(false);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

}

