import 'dart:io';
import 'package:video_player/video_player.dart';

class VideoService {

  VideoPlayerController? controller;

    Future<void> load(String path) async {

    try {

      controller =
          VideoPlayerController.file(
            File(path),
          );

      await controller!.initialize();

      print("INITIALIZED");

    } catch (e) {

      print(e);

    }
  }

  void play() {
    controller?.play();
  }

  void dispose() {
    controller?.dispose();
  }
}