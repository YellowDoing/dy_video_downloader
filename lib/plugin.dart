import 'dart:typed_data';

import 'package:flutter/services.dart';

const methodChannel =  const MethodChannel("com.hg.dy");



void vd(){
  methodChannel.invokeMethod("vd");
}

void test(){
  methodChannel.invokeMethod("test");
}

Future<String> getPath() async{

   String path = await methodChannel.invokeMethod("getPath");

   return path;
}

Future<Map> getVideoThumbnail(String videoPath) async{
  Map data = await methodChannel.invokeMethod("getVideoThumbnail",videoPath);
  return data;
}

void share(String path){
  methodChannel.invokeMethod("share",path);
}

