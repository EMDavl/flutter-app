import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'confirmation_view.dart';


class VideoView extends StatelessWidget {

  const VideoView({super.key});

  pickVideo(BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: ImageSource.camera);
    if (video != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (context) => ConfirmationView(videoFile: File(video.path), videoPath: video.path,))
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video"),
        titleTextStyle: const TextStyle(color: Colors.green, fontSize: 25.0),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: InkWell(
          onTap: () => pickVideo(context),
          child: Container(
            width: 190,
            height: 50,
            decoration: const BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.all(Radius.circular(10)) ),
            child: const Center(
              child: Text("Add video"),
            ),
          ),
        ),
      ),
    );
  }
}