import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:vd/plugin.dart';
import 'package:vd/util.dart';
import 'package:vd/video.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

final List<String> videoPaths = new List();

class _IndexPageState extends State<IndexPage> {
  var _url = '';
  var _content = '';

  @override
  void initState() {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'download') {
        _url = call.arguments;
        _downloadVideo();
      }
      return true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: <Widget>[
          _buildInput(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _btn('粘 贴', () {
                Clipboard.getData(Clipboard.kTextPlain).then((value) {
                  var url = _parseDVLink(value.text);
                  setState(() {
                    _content = url;
                    _url = url;
                  });
                });
              }, Colors.redAccent),
              _btn('下 载', () {
                _downloadVideo();
              }, Colors.blue),
            ],
          )
        ],
      ),
    );
  }

  Widget _btn(String text, VoidCallback tap, Color color) {
    return CupertinoButton(
      padding: EdgeInsets.fromLTRB(46, 0, 46, 0),
      onPressed: tap,
      child: Text(text,style: TextStyle(fontSize: 16),),
      color: color,
    );
  }

  Container _buildInput() {
    return Container(
        margin: EdgeInsets.fromLTRB(26, 34, 26, 34),
        padding: EdgeInsets.only(left: 24, right: 24),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(90),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 5.0), //阴影xy轴偏移量
                  blurRadius: 10.0, //阴影模糊程度
                  spreadRadius: 0.5 //阴影扩散程度
                  )
            ]),
        height: 56,
        child: Center(
          child: TextField(
            controller: TextEditingController.fromValue(
                TextEditingValue(text: _content)),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (value) {
              _url = value;
            },
          ),
        ));
  }

  void _downloadVideo() {
    if (_url.endsWith('/')) {
      _url = _url.substring(0, _url.length - 1);
    }

    String name = _url.substring(_url.lastIndexOf("/") + 1) + '.mp4';
    if (videoPaths.contains(name)) {
      toast('该视频已经下载了');
      return;
    }

    toast('开始下载');

    getVideoPath().then((value) {
      String path = value + '/VDVideo';
      _saveVideo(path, name);
    });
  }

  void _saveVideo(String path, String name) {
    http.get(_url).then((value) {
      var matchUrl = new RegExp("(?<=playAddr: \")https?://.+(?=\",)")
          .stringMatch(value.body)
          .replaceAll("playwm", "play");
      http.get(matchUrl, headers: {
        "Connection": "keep-alive",
        "Host": "aweme.snssdk.com",
        "User-Agent":
            "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16D57 Version/12.0 Safari/604.1",
      }).then((value) {
        String filePath = '$path/$name';
        new File(filePath).writeAsBytes(value.bodyBytes).then((value) {
          toast('下载成功');
          eventBus.fire(new Video(path: filePath, name: name));
        });
      });
    });
  }

  String _parseDVLink(String link) {
    int start = link.indexOf("http");
    int end = link.lastIndexOf("/");
    return link.substring(start, end);
  }
}
