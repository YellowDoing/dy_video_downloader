import 'dart:typed_data';

class Video{

  Uint8List thumbnail;
  String path;
  String name;
  String size;

  Video({this.path,this.name});

  @override
  String toString() {
    return 'Video{thumbnail: $thumbnail, path: $path, name: $name, size: $size}';
  }
}