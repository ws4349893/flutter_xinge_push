package com.titilife.flutter_xinge_push;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.core.app.NotificationManagerCompat;

import com.tencent.android.tpush.XGIOperateCallback;
import com.tencent.android.tpush.XGPushConfig;
import com.tencent.android.tpush.XGPushManager;

import java.util.Map;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.StringCodec;

/** FlutterXingePushPlugin */
public class FlutterXingePushPlugin implements MethodCallHandler {
  /** Plugin registration. */
  static Activity activity;
  static BasicMessageChannel<String> messageChannel;
  public static void registerWith(Registrar registrar) {
    activity = registrar.activity();
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_xinge_push");
    channel.setMethodCallHandler(new FlutterXingePushPlugin());

    messageChannel = new BasicMessageChannel<>(registrar.messenger(), "xinge_push_channel", StringCodec.INSTANCE);
    ReceiverRspHandler.setChannel(channel);
  }

  @Override
  public void onMethodCall(final MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("init")){
//      StubAppUtils.attachBaseContext(activity);

      Map<String,String> param = (Map<String, String>) call.arguments;
      String miAppId = param.get("miAppId");
      String miAppKey = param.get("miAppKey");
      String mzAppId = param.get("mzAppId");
      String mzAppKey = param.get("mzAppKey");


      XGPushConfig.setHuaweiDebug(false);
      XGPushConfig.setMiPushAppId(activity.getApplicationContext(), miAppId);
      XGPushConfig.setMiPushAppKey(activity.getApplicationContext(), miAppKey);

      XGPushConfig.setMzPushAppId(activity, mzAppId);
      XGPushConfig.setMzPushAppKey(activity, mzAppKey);


      XGPushConfig.enableOtherPush(activity.getApplicationContext(), true);

      XGPushManager.registerPush(activity, new XGIOperateCallback() {
        @Override
        public void onSuccess(Object data, int flag) {
          //token在设备卸载重装的时候有可能会变
          Log.d("TPush", "注册成功，设备token为：" + data);
        }
        @Override
        public void onFail(Object data, int errCode, String msg) {
          Log.d("TPush", "注册失败，错误码：" + errCode + ",错误信息：" + msg);
        }
      });
    } else if(call.method.equals("bindAccount")){
      Log.d("TPush", "绑定账号。。。。。。。"+call.arguments);
      XGPushManager.bindAccount(activity, (String) call.arguments,new XGIOperateCallback() {
        @Override
        public void onSuccess(Object data, int flag) {
          //token在设备卸载重装的时候有可能会变
          Log.d("TPush", "绑定账号成功：" + call.arguments);
        }
        @Override
        public void onFail(Object data, int errCode, String msg) {
          Log.d("TPush", "绑定账号失败，错误码：" + errCode + ",错误信息：" + msg);
        }
      });
    } else if(call.method.equals("delAccount")){
      XGPushManager.delAccount(activity, (String) call.arguments,new XGIOperateCallback() {
        @Override
        public void onSuccess(Object data, int flag) {
          //token在设备卸载重装的时候有可能会变
          Log.d("TPush", "解除账号成功：" + call.arguments);
        }
        @Override
        public void onFail(Object data, int errCode, String msg) {
          Log.d("TPush", "解除账号失败，错误码：" + errCode + ",错误信息：" + msg);
        }
      });
    } else if(call.method.equals("unregisterPush")){
      XGPushManager.unregisterPush(activity);
    } else if(call.method.equals("setTag")){
      XGPushManager.setTag(activity, (String) call.arguments);
      Log.d("TPush","设置标签"+ call.arguments);
    } else if(call.method.equals("deleteTag")){
      XGPushManager.deleteTag(activity, (String) call.arguments);
    } else if(call.method.equals("isOpenNotification")){
      result.success(XGPushManager.isNotificationOpened(activity) ? "true" : "false");
    } else if(call.method.equals("cleanTags")){
      XGPushManager.cleanTags(activity,"clearTags:"+System.currentTimeMillis());
    } else {
      result.notImplemented();
    }
  }

  private boolean isNotificationEnabled(Context context) {
    boolean isOpened;
    try {
      isOpened = NotificationManagerCompat.from(context).areNotificationsEnabled();
    } catch (Exception e) {
      e.printStackTrace();
      isOpened = false;
    }
    return isOpened;

  }
}
