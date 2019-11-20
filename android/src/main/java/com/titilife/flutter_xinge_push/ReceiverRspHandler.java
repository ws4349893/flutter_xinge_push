package com.titilife.flutter_xinge_push;
import io.flutter.plugin.common.MethodChannel;

public class ReceiverRspHandler {
    static MethodChannel channel;
    public static void setChannel(MethodChannel channel) {
        ReceiverRspHandler.channel = channel;
    }

    static void handlerMessage(String message){
        if(null != channel){
            channel.invokeMethod("onReceivedMessage",message);
        }
    }

}
