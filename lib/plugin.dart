import 'dart:io';
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

//Future<int> getVideoDuration(String videoPath) async{
//  int data = await methodChannel.invokeMethod("getVideoDuration",videoPath);
//  return data;
//}

void share(String path){
  if(Platform.isAndroid){
    methodChannel.invokeMethod("share",path);
  }else{
    methodChannel.invokeMethod('shareVideo',path);
  }
}

Future<String> getVideoSize(String path) async{
  var size = await methodChannel.invokeMethod("getVideoSize",path);
return size;
}
