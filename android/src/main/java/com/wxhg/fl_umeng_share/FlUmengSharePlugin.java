package com.wxhg.fl_umeng_share;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.SimpleTarget;
import com.bumptech.glide.request.transition.Transition;
import com.umeng.analytics.MobclickAgent;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.socialize.PlatformConfig;
import com.umeng.socialize.ShareAction;
import com.umeng.socialize.UMShareAPI;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.media.UMWeb;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

@SuppressWarnings("all")
/** FlUmengSharePlugin */
public class FlUmengSharePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;
    private Activity activity;

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }

    public FlUmengSharePlugin(MethodChannel channel) {
        this.channel = channel;
    }

    public FlUmengSharePlugin() {
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "fl_umeng_share");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("shareInit")) {
            UMConfigure.setLogEnabled(false);
            String appkey = call.argument("umengAppkey");
            String umengMessageSecret = call.argument("umengMessageSecret");
            String wxAppKey = call.argument("wxAppKey");
            String wxAppSecret = call.argument("wxAppSecret");
            String qqAppKey = call.argument("qqAppKey");
            String qqAppSecret = call.argument("qqAppSecret");
            String shareType = call.argument("shareType");
            UMConfigure.init(context, appkey, "umeng", UMConfigure.DEVICE_TYPE_PHONE, umengMessageSecret);//58edcfeb310c93091c000be2 5965ee00734be40b580001a0
            UMConfigure.init(context, UMConfigure.DEVICE_TYPE_BOX, null);
            PlatformConfig.setWeixin(wxAppKey, wxAppSecret);
//        PlatformConfig.setSinaWeibo(appKey, appSecret, redirectURL);
            PlatformConfig.setQQZone(qqAppKey, qqAppSecret);
PlatformConfig.setWXFileProvider("com.wxhg.123.fileprovider");
PlatformConfig.setQQFileProvider("com.wxhg.123.fileprovider");
            // 选用AUTO页面采集模式
//      MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.AUTO);

            result.success("shareInitSuccess");
        } else if (call.method.equals("shareText")) {
            String shareText = call.argument("shareString");
            String platform = call.argument("platform");
            SHARE_MEDIA platFormMedia = getPlatFormMedia(platform);
            if (platFormMedia != null) {
                new ShareAction(activity).withText(shareText).
                        setPlatform(platFormMedia)
                        .setCallback(new UmengshareActionListener(activity, result)).share();
            } else {
                new ShareAction(activity).withText(shareText).
                        setDisplayList(SHARE_MEDIA.WEIXIN, SHARE_MEDIA.WEIXIN_CIRCLE, SHARE_MEDIA.QQ, SHARE_MEDIA.QZONE)
                        .setCallback(new UmengshareActionListener(activity, result)).open();
            }
        } else if (call.method.equals("shareImage")) {
            final String shareImage = call.argument("shareImage");
            UMImage sImage = new UMImage(activity, shareImage);  //分享图
            String platform = call.argument("platform");
            final SHARE_MEDIA platFormMedia = getPlatFormMedia(platform);
            if (platFormMedia != null) {
                final Result r=result;
                UMImage umImage = new UMImage(activity,shareImage);
                new ShareAction(activity)
                        .setPlatform(platFormMedia)//传入平台
                        .withMedia(umImage)
                        .setCallback(new UmengshareActionListener(activity, r))//回调监听器
                        .share();

                // final Result r=result;
                // activity.runOnUiThread(new Runnable() {
                //     @Override
                //     public void run() {
                //         Glide.with(activity).asBitmap().load(shareImage).into(new SimpleTarget<Bitmap>() {
                //             @Override
                //             public void onResourceReady(@NonNull Bitmap bitmap, @Nullable Transition<? super Bitmap> transition) {
                //                 UMImage umImage = new UMImage(activity, bitmap);
                //                 new ShareAction(activity)
                //                         .setPlatform(platFormMedia)//传入平台
                //                         .withMedia(umImage)
                //                         .setCallback(new UmengshareActionListener(activity, r))//回调监听器
                //                         .share();
                //             }
                //         });
                //     }
                // });
            } else {
                new ShareAction(activity)
                        .setDisplayList(SHARE_MEDIA.WEIXIN, SHARE_MEDIA.WEIXIN_CIRCLE, SHARE_MEDIA.QQ, SHARE_MEDIA.QZONE)
                        .withMedia(sImage)
                        .setCallback(new UmengshareActionListener(activity, result)).open();
            }
        } else if (call.method.equals("shareImageText")) {
            result.success("not support share type");
        } else if (call.method.equals("shareWebView")) {
            String shareTitle = call.argument("shareTitle");
            String descr = call.argument("descr");
            String icon = call.argument("icon");
            String webUrl = call.argument("webUrl");
            UMImage thumbImage = new UMImage(activity, icon);
            UMWeb web = new UMWeb(webUrl);
            web.setTitle(shareTitle);//标题
            web.setThumb(thumbImage);  //缩略图
            web.setDescription(descr);//描述
            String platform = call.argument("platform");
            SHARE_MEDIA platFormMedia = getPlatFormMedia(platform);
            if (platFormMedia != null) {
                new ShareAction(activity).setPlatform(platFormMedia)
                        .withMedia(web)
                        .setCallback(new UmengshareActionListener(activity, result)).share();
            } else {
                new ShareAction(activity).setDisplayList(SHARE_MEDIA.WEIXIN, SHARE_MEDIA.WEIXIN_CIRCLE, SHARE_MEDIA.QQ, SHARE_MEDIA.QZONE)
                        .withMedia(web)
                        .setCallback(new UmengshareActionListener(activity, result)).open();
            }
        } else if (call.method.equals("shareMusic")) {
            result.success("Android");
        } else if (call.method.equals("shareVideo")) {
            result.success("Android");
        } else if (call.method.equals("shareWXExpression")) {
            result.success("Android");
        } else if (call.method.equals("shareApplets")) {
            result.success("Android");
        }
//    else if (call.method.equals("loginWX")) {
//      login(SHARE_MEDIA.WEIXIN,result);
//    }
//    else if (call.method.equals("loginQQ")) {
//      login(SHARE_MEDIA.QQ,result);
//    }
//    else if (call.method.equals("loginSina")) {
//      login(SHARE_MEDIA.SINA,result);
//    }
        else if (call.method.equals("analyticsInit")) {
            result.success("Android");
        } else if (call.method.equals("beginPageView")) {
            String pageName = call.argument("pageName");
            MobclickAgent.onPageStart(pageName); //统计页面("MainScreen"为页面名称，可自定义)
        } else if (call.method.equals("endPageView")) {
            String pageName = call.argument("pageName");
            MobclickAgent.onPageEnd(pageName); //统计页面("MainScreen"为页面名称，可自定义)
        } else if (call.method.equals("logPageView")) {
            result.success("Android");
        } else if (call.method.equals("analyticsEvent")) {
            result.success("Android");
        } else {
            result.notImplemented();
        }
    }

    private SHARE_MEDIA getPlatFormMedia(String platform) {
        if(platform==null)return null;
        switch (platform) {
            case "WEIXIN":
                return SHARE_MEDIA.WEIXIN;
            case "WEIXIN_CIRCLE":
                return SHARE_MEDIA.WEIXIN_CIRCLE;
            case "QQ":
                return SHARE_MEDIA.QQ;
            case "QZONE":
                return SHARE_MEDIA.QZONE;
            default:
                return null;
        }
    }

    @Override
    public boolean onActivityResult(int i, int i1, Intent intent) {
        UMShareAPI.get(activity).onActivityResult(i, i1, intent);
        return false;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
