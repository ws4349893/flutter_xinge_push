import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterXingePush {
  static  MethodChannel _channel =
       MethodChannel('flutter_xinge_push') .. setMethodCallHandler(_handler);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///android
  static init(
      {String miAppId,
      String miAppKey,
      String mzAppId,
      String mzAppKey,
      String xgAppId,
      String xgAppKey}) {
    if (Platform.isAndroid) {
      _channel.invokeMethod("init", {
        "miAppId": miAppId,
        "miAppKey": miAppKey,
        "mzAppId": mzAppId,
        "mzAppKey": mzAppKey
      });
    } else {
      ///IOS
      _channel.invokeMethod("init", {
        "xgAppId": xgAppId,
        "xgAppKey": xgAppKey,
      });
    }
  }

  ///绑定账号
  static bindAccount(String account){
    _channel.invokeMethod('bindAccount',account);
  }
  ///删除账号
  static delAccount(String account){
    _channel.invokeMethod('delAccount',account);
  }
  ///注销
  static unregisterPush(){
    _channel.invokeMethod('unregisterPush');
  }
  ///设置标签
  static setTag(String tag){
    _channel.invokeMethod('setTag',tag);
  }
//  static setTags(List<String> tags){
//    _channel.invokeListMethod("setTags", tags);
//  }

  ///删除标签
  static deleteTag(String tag){
    _channel.invokeMethod('deleteTag',tag);
  }

  static Future<String> isOpenNotification(){
    return _channel.invokeMethod("isOpenNotification");
  }
  static Future<String> cleanTags(){
    return _channel.invokeMethod("cleanTags");
  }


  static Future<dynamic> _handler(MethodCall methodCall) {
    if("onReceivedMessage" == methodCall.method){
      _msgResponseController.sink.add(methodCall.arguments);
    }
    return Future.value(true);
  }
  static StreamController<String> _msgResponseController =
  new StreamController.broadcast();
  static Stream<String> get msgResponse =>
      _msgResponseController.stream;

  void dispose(){
    _msgResponseController.close();
  }

}

