import 'dart:io';

import 'package:fl_umeng_share/flutter_umeng_plugin.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fl_umeng_share/fl_umeng_share.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initUMeng(); //初始化友盟控件
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlUmengShare.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Text('分享文本到微信'),
                onTap: () => shareText(platformStr: "WEIXIN"),
              ),
              Padding(padding: EdgeInsets.only(top: 50)),
              GestureDetector(
                child: Text('分享图片到微信'),
                onTap: () => shareImage(platformStr: "WEIXIN"),
              ),
              Padding(padding: EdgeInsets.only(top: 50)),
              GestureDetector(
                child: Text('分享文本到微信朋友圈'),
                onTap: () => shareText(platformStr: "WEIXIN_CIRCLE"),
              ),
              Padding(padding: EdgeInsets.only(top: 50)),
              GestureDetector(
                child: Text('分享图片到微信朋友圈'),
                onTap: () => shareImage(platformStr: "WEIXIN_CIRCLE"),
              ),
              Padding(padding: EdgeInsets.only(top: 50)),
              GestureDetector(
                child: Text('分享图片到QQ'),
                onTap: () => shareImage(platformStr: "QQ"),
              ),
              Padding(padding: EdgeInsets.only(top: 50)),
              GestureDetector(
                child: Text('分享图片到QQ空间'),
                onTap: () => shareImage(platformStr: "QZONE"),
              ),
            ],
          ),
        ),
      ),
    );
  }

// com.formal.flutter1r1y
// com.example.flutterUmengPluginExample
  //初始化友盟 同时初始化埋点
  Future<void> initUMeng() async {
    String umSocialSDKVersion;
    String umengKey = Platform.isIOS
        ? "5e6c42b7978eea0774044998"
        : Platform.isAndroid
            ? "5e685659dbc2ec076bd60fd4"
            : "";
    String qqAppKey = Platform.isIOS
        ? "1110253687"
        : Platform.isAndroid
            ? "1110253707"
            : "";
    String qqAppSecret = Platform.isIOS
        ? "6KKQMf8VJsVaEcT7"
        : Platform.isAndroid
            ? "RxxjEIgVJQHqh75W"
            : "";
    try {
      umSocialSDKVersion = await FlutterUmengPlugin.shareInit(
        umengAppkey: umengKey, //your Umeng appkey
        umengMessageSecret: '', //your Umeng Message Secret Of Android
        channel: Platform.isIOS ? "IOS" : "Android", //your Umeng channel
        //以下key secret 需要在各自的开放平台申请
        wxAppKey: "wx3cbd03e15e9714b1",
        wxAppSecret: "95b16849ab6658770b17f415e78d2ae5",
        qqAppKey: qqAppKey,
        qqAppSecret: qqAppSecret,
        wxRedirectURL: "http://mobile.umeng.com/social", //默认回调
        qqAppID: "1110253707",
        qqRedirectURL: "http://mobile.umeng.com/social",
        wbAppKey: "",
        wbAppSecret: "",
        wbRedirectURL: "", //微博中设置
      );
    } on PlatformException {
      umSocialSDKVersion = 'fail';
    }
    if (!mounted) return;
    setState(() {
      print(umSocialSDKVersion);
    });
  }

  Future<void> shareText({String platformStr}) async {
    String result;
    try {
      result = await FlutterUmengPlugin.shareText(
          shareString: "分享测试数据", platform: platformStr ?? "");
    } on PlatformException {
      result = 'fail';
    }
    if (!mounted) return;

    setState(() {
      print(result);
    });
  }

  Future<void> shareImage({String platformStr}) async {
    String result;
    try {
      result = await FlutterUmengPlugin.shareImage(
          platform: platformStr ?? "",
          shareImage:
              "https://share-benifit.oss-cn-zhangjiakou.aliyuncs.com/admin/upload/file/shareImg/1/3/20210202/07af34e1062c4045920bd3ab5558da63_preview.jpg");
    } on PlatformException {
      result = 'fail';
    }
    if (!mounted) return;
    setState(() {
      print(result);
    });
  }

  Future<void> shareImageText() async {
    String result;
    try {
      result = await FlutterUmengPlugin.shareImageText(
          shareText: "分享文字", platform: "WEIXIN");
    } on PlatformException {
      result = 'fail';
    }
    if (!mounted) return;
    setState(() {
      print(result);
    });
  }

  // 其中 icon 需要配置在项目中
  Future<void> shareWebView() async {
    String result;
    try {
      result = await FlutterUmengPlugin.shareWeb(
          shareTitle: '分享标题',
          descr: '分享简介',
          icon: 'AppIcon',
          webUrl: 'https://www.baidu.com');
    } on PlatformException {
      result = 'fail';
    }
    if (!mounted) return;
    setState(() {
      print(result);
    });
  }
}
