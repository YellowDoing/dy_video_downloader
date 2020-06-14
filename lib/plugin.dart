import 'dart:typed_data';

import 'package:flutter/services.dart';

const methodChannel =  const MethodChannel("com.hg.dy/DYPlugin");



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

Future<Uint8List> getVideoThumbnail(String videoPath) async{
  Uint8List data = await methodChannel.invokeMethod("getVideoThumbnail",videoPath);
  return data;
}

Future<int> getVideoDuration(String videoPath) async{
  int data = await methodChannel.invokeMethod("getVideoDuration",videoPath);
  return data;
}

void share(String path){
  methodChannel.invokeMethod("share",path);
}

