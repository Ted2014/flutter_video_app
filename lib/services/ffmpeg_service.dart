import 'dart:io';

class FFmpegService {
  static Future<String> convertAviToMp4(String aviPath) async {
    final mp4Path = aviPath.replaceAll('.avi', '.mp4');

    final result = await Process.run(
      'ffmpeg', // Windowsは".exe"をつける
      [
        '-y',
        '-i',
        aviPath,
        '-c:v',
        'libx264',
        '-c:a',
        'aac',
        mp4Path,
      ],
    );

    if (result.exitCode != 0) {
      throw Exception(result.stderr);
    }

    print(result.stdout);
    print(result.stderr);

    return mp4Path;
  }
}