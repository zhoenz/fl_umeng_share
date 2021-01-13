import 'dart:async';
import 'package:flutter/services.dart';

class FlutterUmengPlugin {
  static const MethodChannel _channel = const MethodChannel('fl_umeng_share');

  static Future<String> shareInit({
    String umengAppkey,
    String umengMessageSecret = '',
    String channel,
    String wxAppKey,
    String wxAppSecret,
    String wxRedirectURL,
    String qqAppID,
    String qqRedirectURL,
    String wbAppKey,
    String wbAppSecret,
    String wbRedirectURL,
    String qqAppKey,
    String qqAppSecret,
  }) async {
    Map<String, dynamic> shareMap = {
      "umengAppkey": umengAppkey,
      "umengMessageSecret": umengMessageSecret,
      "channel": channel,
      "wxAppKey": wxAppKey,
      "wxAppSecret": wxAppSecret,
      "qqAppKey": qqAppKey,
      "qqAppSecret": qqAppSecret,
      "wxRedirectURL": wxRedirectURL,
      "qqAppID": qqAppID,
      "qqRedirectURL": qqRedirectURL,
      "wbAppKey": wbAppKey,
      "wbAppSecret": wbAppSecret,
      "wbRedirectURL": wbRedirectURL,
    };
    final String result = await _channel.invokeMethod('shareInit', shareMap);
    return result;
  }

  static Future<String> shareText({String shareString, String platform}) async {
    Map<String, dynamic> shareMap = {
      "shareString": shareString,
      "platform": platform ?? ""
    };
    final String result = await _channel.invokeMethod('shareText', shareMap);
    return result;
  }

  static Future<String> shareImage({String shareImage, String platform}) async {
    Map<String, dynamic> shareMap = {
      "shareImage": shareImage,
      "platform": platform ?? "",
    };
    final String result = await _channel.invokeMethod('shareImage', shareMap);
    return result;
  }

  static Future<String> shareImageText(
      {String shareText, String shareImage, String platform}) async {
    Map<String, dynamic> shareMap = {
      "shareText": shareText,
      "shareImage": shareImage,
      "platform": platform ?? "",
    };
    final String result =
        await _channel.invokeMethod('shareImageText', shareMap);
    return result;
  }

  static Future<String> shareWeb(
      {String shareTitle,
      String descr,
      String icon,
      String webUrl,
      String platform}) async {
    Map<String, dynamic> shareMap = {
      "shareTitle": shareTitle,
      "descr": descr,
      "icon": icon,
      "webUrl": webUrl,
      "platform": platform ?? "",
    };
    final String result = await _channel.invokeMethod('shareWebView', shareMap);
    return result;
  }

  static Future<String> shareMusic(
      {String shareTitle, String descr, String icon, String musicUrl}) async {
    Map<String, dynamic> shareMap = {
      "shareTitle": shareTitle,
      "descr": descr,
      "icon": icon,
      "musicUrl": musicUrl,
    };
    final String result = await _channel.invokeMethod('shareMusic', shareMap);
    return result;
  }

  static Future<String> shareVideo(
      {String shareTitle, String descr, String icon, String videoUrl}) async {
    Map<String, dynamic> shareMap = {
      "shareTitle": shareTitle,
      "descr": descr,
      "icon": icon,
      "videoUrl": videoUrl,
    };
    final String result = await _channel.invokeMethod('shareVideo', shareMap);
    return result;
  }

  static Future<String> shareWXExpression(
      //TODO 暂不开发分享表情 后续有需要会添加
      {String shareText,
      String shareImage}) async {
    final String result = await _channel.invokeMethod('shareWXExpression');
    return result;
  }

  static Future<String> shareApplets(
      //TODO 暂不开发分享小程序 后续有需要会添加
      {String shareText,
      String shareImage}) async {
    final String result = await _channel.invokeMethod('shareApplets');
    return result;
  }

  //三方登录
  static Future<Map> get loginWechat async {
    final Map resultMap = await _channel.invokeMethod('loginWX');
    return resultMap;
  }

  static Future<Map> get loginQQ async {
    final Map resultMap = await _channel.invokeMethod('loginQQ');
    return resultMap;
  }

  static Future<Map> get loginSina async {
    final Map resultMap = await _channel.invokeMethod('loginSina');
    return resultMap;
  }

  // 打开页面时进行统计
  static Future<Null> beginPageView(String pageName) async {
    _channel.invokeMethod("beginPageView", {"pageName": pageName});
    return null;
  }

  // 关闭页面时结束统计
  static Future<Null> endPageView(String pageName) async {
    _channel.invokeMethod("endPageView", {"pageName": pageName});
    return null;
  }

  //页面时常统计
  static Future<Null> logPageView(String pageName, {int seconds}) async {
    _channel
        .invokeMethod("logPageView", {"pageName": pageName, seconds: seconds});
    return null;
  }

  // 事件统计 只进行标签统计
  static Future<Null> analyticsEvent(String pageName, {String label}) async {
    _channel
        .invokeMethod("analyticsEvent", {"pageName": pageName, "label": label});
    return null;
  }
}
