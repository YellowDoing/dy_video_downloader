import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vd/plugin.dart';

final EventBus eventBus = EventBus();

void toast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
}

Future<String> getVideoPath() async {
  if (Platform.isAndroid) {
    String path = await getPath();
    return path;
  } else {
    Directory directory = await getLibraryDirectory();
    return directory.path;
  }
}
