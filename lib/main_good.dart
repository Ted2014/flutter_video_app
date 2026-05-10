import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'services/ffmpeg_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VideoPage(),
    );
  }
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController? controller;
  bool isConverting = false;

  Future<void> pickVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );

      if (result == null) return;

      final path = result.files.single.path!;

      debugPrint(path);

      String playPath = path;

      // 変換開始
      setState(() {
        isConverting = true;
      });

      if (path.toLowerCase().endsWith('.avi')) {
        playPath =
            await FFmpegService.convertAviToMp4(path);

        debugPrint(playPath);
      }

      controller?.dispose();

      controller = VideoPlayerController.file(
        File(playPath),
      );

      await controller!.initialize();

      setState(() {});

      await controller!.play();

      setState(() {
        isConverting = false;
      });

    } catch (e) {
      
      setState(() {
        isConverting = false;
      });

      debugPrint('ERROR: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Test'),
      ),
      body: Center(
        child: isConverting
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Converting AVI to MP4...'),
                ],
              )
            : controller != null &&
                    controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio:
                        controller!.value.aspectRatio,
                    child: VideoPlayer(controller!),
                  )
                : const Text('No Video'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await pickVideo();
        },
        child: const Icon(Icons.folder_open),
      ),
    );
  }
}