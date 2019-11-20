# flutter_xinge_push

A new flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.


android :

gradle

defaultConfig {
    // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
    applicationId "com.titilife.halfoff"
    minSdkVersion 19
    targetSdkVersion 28
    versionCode currentVersionCode
    versionName currentVersionName + "_" + releaseTime
    testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
//        manifestPlaceholders = [
//        ]
    multiDexEnabled true
    ndk {
        //设置支持的SO库架构
        abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86', 'x86_64'
    }

    manifestPlaceholders = [
            AMAP_KEY : "ff8d919defaf4bc376b338e0db74a27a", /// 高德地图key
            XG_ACCESS_ID:"2100335343",
            XG_ACCESS_KEY : "AJ6AXV9J188H",
            //如果需要华为通道，则加上华为的APPID
            HW_APPID: "100471067",
            //如果需要加入小米通道，则加上应用包名
            PACKAGE_NAME:"com.titilife.halfoff"
    ]
}