#import "FlutterXingePushPlugin.h"
#import "XGPush.h"

@implementation FlutterXingePushPlugin

FlutterBasicMessageChannel* msgChannel;
FlutterMethodChannel* channel;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_xinge_push"
            binaryMessenger:[registrar messenger]];
  FlutterXingePushPlugin* instance = [[FlutterXingePushPlugin alloc] init];
    
    
    
  [registrar addMethodCallDelegate:instance channel:channel];
    
    msgChannel = [FlutterBasicMessageChannel messageChannelWithName:@"xinge_push_channel" binaryMessenger:[registrar messenger] codec:[FlutterStringCodec sharedInstance]];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if([@"init" isEqualToString:call.method]){
      NSDictionary* dic = [call arguments];
      NSString* xgAppId = [dic objectForKey:@"xgAppId"];
      NSString* xgAppKey = [dic objectForKey:@"xgAppKey"];
      uint32_t i = [xgAppId integerValue];
      NSLog(@"%@ %@",@"信鸽:",[[XGPush defaultManager] sdkVersion] );
//     [call arguments]
      
      [[XGPush defaultManager] startXGWithAppID:i  appKey: xgAppKey delegate:self ];
      [[XGPushTokenManager defaultTokenManager ] setDelegate:self];
  }  else if([@"unregisterPush" isEqualToString:call.method]){
      [[XGPush defaultManager] stopXGNotification];
  }    else if([@"bindAccount" isEqualToString:call.method]){
      NSString* param = [call arguments];
      [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:param type:XGPushTokenBindTypeAccount ];
      
//      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//          //账号二次绑定
//          [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:param type:XGPushTokenBindTypeAccount ];
//
//      });
//
//      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//          //账号三次绑定
//          [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:param type:XGPushTokenBindTypeAccount ];
//
//      });
      
  }   else if([@"delAccount" isEqualToString:call.method]){
      NSString* param = [call arguments];
      [[XGPushTokenManager defaultTokenManager] unbindWithIdentifer:param type:XGPushTokenBindTypeAccount];
  }    else if([@"setTag" isEqualToString:call.method]){
      NSString* param = [call arguments];
      [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:param type:XGPushTokenBindTypeTag];
  }    else if([@"deleteTag" isEqualToString:call.method]){
      NSString* param = [call arguments];
      [[XGPushTokenManager defaultTokenManager] unbindWithIdentifer:param type:XGPushTokenBindTypeTag];
  }  else if([@"isOpenNotification" isEqualToString:call.method]){
      [[XGPush defaultManager]deviceNotificationIsAllowed:^(BOOL isAllowed) {
          if(isAllowed){
              result(@"true");
          } else {
              result(@"false");
          }
          
      }];
  } else if([@"cleanTags" isEqualToString:call.method]){
      [[XGPushTokenManager defaultTokenManager] clearAllIdentifiers:XGPushTokenBindTypeTag];
  } else {
    result(FlutterMethodNotImplemented);
  }
    
}


- (void)xgPushDidRegisteredDeviceToken:(NSString *)deviceToken error:(NSError *)error {
    NSLog(@"%@ %@",@"信鸽token:", deviceToken);
    if(error != nil){
        NSLog(@"%@ %@",@"信鸽token失败:", error.userInfo);
    }
}
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(NSError *)error{
    if (isSuccess) {
         NSLog(@"%@ %@",@"信鸽:", @"初始化成功");
    } else {
         NSLog(@"%@ %@",@"信鸽:", @"初始化失败");
    }
    
}
- (void)xgPushDidReceiveRemoteNotification:(id)notification withCompletionHandler:(void (^)(NSUInteger))completionHandler {
    
    if(channel != nil){
        [channel invokeMethod:@"onReceivedMessage" arguments: nil];
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
    
    }
    
}

- (void)delayMethod :(UNNotificationResponse*) response API_AVAILABLE(ios(10.0)){
    [msgChannel sendMessage:[[[[response notification] request] content]categoryIdentifier]];
}
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"%@ %@",@"信鸽:", @"点击通知栏");
    [self performSelector:@selector(delayMethod:) withObject:response/*可传任意类型参数*/ afterDelay:1.5];
    

    completionHandler();
}

- (void)xgPushDidBindWithIdentifier:(NSString *)identifier type:(XGPushTokenBindType)type error:(NSError *)error {
    NSLog(@"%@ %@ %@",@"信鸽绑定:", identifier ,error == nil ? @"成功" : @"失败");
}

@end

