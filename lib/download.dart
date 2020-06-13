import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vd/palyer.dart';
import 'package:vd/plugin.dart';
import 'package:vd/util.dart';
import 'package:vd/video.dart';
import 'package:event_bus/event_bus.dart';

/// 下载列表
class DownloadsPage extends StatefulWidget {
  @override
  _DownloadsPageState createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  var _videos = new List<Video>();

  @override
  void initState() {
    getVideoPath().then((value) {
      String path = value + '/VDVideo';
      _getVideos(path);
    });

    eventBus.on<Video>().listen((video) => _newVideo(video));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemBuilder: (ctx, index) => _listItem(_videos[index]),
          itemCount: _videos.length),
    );
  }

  Widget _listItem(Video video) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => PlayerPage(video, MediaQuery.of(context).size)));
      },
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                video.thumbnail == null
                    ? Container()
                    : Image.memory(
                        video.thumbnail,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(video.name, style: TextStyle(fontSize: 16)),
                              Container(
                                margin: EdgeInsets.only(top: 6, bottom: 6),
                                child: Text(video.size,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey))),
                              Text(_getVideoTime(video.duration),
                                  style: TextStyle(fontSize: 12, color: Colors.grey))
                            ]))),
                _icons(video)
              ],
            ),
          ),
          Divider(height: 0)
        ],
      ),
    );
  }

  ///三个图标按钮
  Widget _icons(Video video) {
    return Row(
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.edit), onPressed: () => _showRenameDialog(video)),
        IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => _showDeleteDialog(video)),
        IconButton(icon: Icon(Icons.share), onPressed: () => share(video.path))
      ],
    );
  }

  void _showRenameDialog(Video video) {
    var name = '';

    showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
              title: Text(
                "重命名",
              ),
              content: CupertinoTextField(
                autofocus: true,
                onChanged: (value) {
                  name = value;
                },
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: Text('修改'),
                  isDefaultAction: true, //加红
                  onPressed: () {
                    String newPath = video.path
                            .substring(0, video.path.lastIndexOf("/") + 1) +
                        name +
                        '.mp4';
                    new File(video.path).rename(newPath);
                    setState(() {
                      video.name = name + ".mp4";
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  ///删除视频
  void _showDeleteDialog(Video video) {
    showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
              content: Text('确定要删除该视频吗？', style: TextStyle(fontSize: 16)),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('取消'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: Text('删除'),
                  isDestructiveAction: true, //加红
                  onPressed: () {
                    new File(video.path).deleteSync();
                    setState(() {
                      _videos.remove(video);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }

  void _getVideos(String path) {
    Directory directory = new Directory(path);

    bool exists = directory.existsSync();

    if (!exists) {
      directory.createSync();
      debugPrint('创建目录');
    } else {
      List<FileSystemEntity> paths = directory.listSync();
      debugPrint('视频数量:${paths.length}');

      var videos = paths.map((element) {
        Video video = new Video();
        video.path = element.path;
        video.size = _getFileSize(element.path);
        getVideoThumbnail(element.path).then((value) {
          video.thumbnail = value['thumbnail'];
          video.duration = value['duration'];
        });
        video.name = element.path.substring(element.path.lastIndexOf("/") + 1);

        return video;
      }).toList();

      setState(() {
        _videos = videos;
      });
    }
  }

  void _newVideo(Video video) {
    video.size = _getFileSize(video.path);
    video.name = video.path.substring(video.path.lastIndexOf("/") + 1);
    getVideoThumbnail(video.path).then((value) {
      video.thumbnail = value['thumbnail'];
      video.duration = value['duration'];
      setState(() {
        _videos.add(video);
      });
    });
  }

  String _getFileSize(String path) {
    int sizeInt = new File(path).lengthSync();
    String size = "";
    String pre = '';
    if (sizeInt < 1024) {
      size = '$sizeInt';
      pre = ' B';
    } else if (sizeInt < 1048576) {
      size = '${sizeInt / 1024}';
      pre = ' KB';
    } else if (sizeInt < 1073741824) {
      size = '${sizeInt / 1048576}';
      pre = ' MB';
    } else {
      size = '${sizeInt / 1073741824}';
      pre = ' GB';
    }

    if (size.contains('.')) {
      size = size.substring(0, size.indexOf('.') + 3);
    }

    return size + pre;
  }

  String _getVideoTime(int duration) {
    if (duration < 60) {
      return '$duration 秒';
    } else if (duration < 3600) {
      return '${duration ~/ 60} 分 ${duration % 60} 秒';
    } else {
      return '${duration ~/ 3600} 小时 ${duration % 3600} 分';
    }
  }
}
