import 'package:doki/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class File {
  final int id;
  final int size;
  final int unixTime;
  final String fileUrl;
  final String? thumbnail;
  final Author author;
  final int likes;
  final bool nsfw;
  final String? folder;
  final int views;
  final String? tags;
  final String? report;
  final String? title;
  final String? description;

  File(
      {required this.id,
      required this.size,
      required this.unixTime,
      required this.fileUrl,
      required this.thumbnail,
      required this.author,
      required this.likes,
      required this.nsfw,
      required this.folder,
      required this.views,
      required this.tags,
      required this.report,
      required this.title,
      required this.description});

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
        id: json['Id'],
        size: json['Size'],
        unixTime: json['UnixTime'],
        fileUrl: json['FileURL'],
        title: json['Title'],
        description: json['Description'],
        thumbnail: json['Thumbnail'],
        views: json['Views'],
        likes: json['Likes'],
        folder: json['Folder'],
        tags: json['Tags'],
        nsfw: json['NSFW'] == 0 ? false : true,
        author: Author(
            authorId: json['Author']['AuthorId'],
            name: json['Author']['Name'],
            creationDate: json['Author']['CreationDate']),
        report: '');
  }
}

class Author {
  final int authorId;
  final String name;
  final int creationDate;

  const Author(
      {required this.authorId, required this.name, required this.creationDate});
}

class ViewCard {
  final File file;
  bool disposed = false;
  VideoPlayerController? controller;

  ViewCard({required this.file});

  Future<void> loadController(bool loop) async {
    try {
      controller = VideoPlayerController.network("$dokiBaseUrl${file.fileUrl}");
      await controller?.initialize();
      controller?.setLooping(loop);
    } on Exception catch (err) {
      Fluttertoast.showToast(msg: err.toString());
    }
  }
}
