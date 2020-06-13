import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class _IndexPageState extends State<IndexPage> {
  var _url = '';
  var _content = '测试';

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
            children: <Widget>[
              Expanded(child: CupertinoButton(
                onPressed: () {},
                child: Text('粘贴'),
                color: Colors.redAccent,
              )),
              Expanded( child:Container(
                width: 100,
                height: 40,
                child: CupertinoButton(
                  onPressed: () {
                    _downloadVideo();
                    },
                  child: Text('下 载',style: TextStyle(color: Colors.white,fontSize: 15)),
                  color: Colors.redAccent,
                ),
              )),
            ],
          )
        ],
      ),
    );
  }

  Container _buildInput() {
    return Container(
        margin: EdgeInsets.all(26),
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
    toast('开始下载');

    if (_url.endsWith('/')) {
      _url = _url.substring(0, _url.length - 1);
    }

    getVideoPath().then((value){
      String path = value + '/VDVideo';
      _saveVideo(path);
    });
  }

  void _saveVideo(String path) {
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
        new File('$path/${_url.substring(_url.lastIndexOf('/') + 1)}.mp4')
            .writeAsBytes(value.bodyBytes);
        toast('下载成功');
        eventBus.fire(new Video(path: path));
      });
    });
  }
}
