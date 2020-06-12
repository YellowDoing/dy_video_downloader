import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vd/download.dart';
import 'package:vd/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('抖音/快手视频无水印下载'),
      ),
      body: IndexedStack(
            index: _currentIndex,
            children: <Widget>[
              IndexPage(),
              DownloadsPage()],
          ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  CupertinoTabBar _buildBottomNavigationBar() {
    return CupertinoTabBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
        BottomNavigationBarItem(
            icon: Icon(Icons.file_download), title: Text("下载"))
      ],
    );
  }
}
