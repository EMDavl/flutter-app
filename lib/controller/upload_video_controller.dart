import 'package:app/constants.dart';
import 'package:app/model/media.dart';
import 'package:app/repository/post_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
import 'package:geolocator/geolocator.dart';

import '../model/post.dart';
import '../repository/media_repository.dart';

class UploadVideoController extends GetxController {
  late PostRepository postRepo;
  late MediaRepository mediasRepo;

  UploadVideoController() {
    postRepo = PostRepository();
    mediasRepo = MediaRepository();
  }

  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.MediumQuality);

    return compressedVideo!.file;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath),
        SettableMetadata(contentType: "image/jpg"));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo(String text, String videoPath, BuildContext context) async {
    try {
      var videoId = Uuid().v4().toString();

      String videoUrl = await _uploadVideoToStorage(videoId, videoPath);
      String thumbnailUrl = await _uploadImageToStorage(videoId, videoPath);
      // TODO накрутить проверок на то что есть доступ и так далее
      Position pos = await Geolocator.getCurrentPosition();
      postRepo.createPost(
          Post.forCreation(text, text, false, pos.latitude.toString(),
              pos.longitude.toString()),
          [
            Media.forCreation(videoUrl, Type.video),
            Media.forCreation(thumbnailUrl, Type.thumbnail)
          ]);
    } catch (e) {
      printError(info: e.toString());
    }
    Navigator.pop(context);
  }

  Future<String> _uploadVideoToStorage(String videoId, String videoPath) async {
    var ref = firestore.child("videos").child(videoId);
    var compressVideo = await _compressVideo(videoPath);

    UploadTask uploadTask =
        ref.putFile(compressVideo, SettableMetadata(contentType: "video/mp4"));
    TaskSnapshot snap = await uploadTask;
    return snap.ref.getDownloadURL();
  }
}
