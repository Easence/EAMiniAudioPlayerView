# EAMiniAudioPlayerView

##What is the EAMiniAudioPlayerView
EAMiniAudioPlayerView is a mini Audio player view for ios, it just decide how to display，but don't manage how to download the audio and how to play the audio.

![image](http://upload-images.jianshu.io/upload_images/1801567-76c4d8ccfcad618a.gif?imageMogr2/auto-orient/strip)

##What can EAMiniAudioPlayerView do
- It's easy to config what subView can display,another can not.
Just set `EAMiniAudioPlayerStyleConfig`,s`playerStyle`property,it is a ENUM：
```
    typedef NS_ENUM(NSUInteger, EAMiniPlayerStyle) {
    EAMiniPlayerNormal = 1 << 0,   //Has play button,sound icon
    EAMiniPlayerHidePlayButton = 1 << 1, //Hide play button
    EAMiniPlayerHideSoundIcon = 1 << 2, //Hide sound icon
    EAMiniPlayerHideText = 1 << 3, //Hide text label
};
```
    
eg.：

```
 EAMiniAudioPlayerStyleConfig *config = [EAMiniAudioPlayerStyleConfig defaultConfig];
 config.playerStyle |= EAMiniPlayerHidePlayButton;
```
- The dowload progress
Set value to `EAMiniAudioPlayerView`'s`downloadProgress`property（0<downloadProgress<1）can change the downloading progress .When `downloadProgress`'s value is greater than or equal 1,`void(^downloadCompleted)(void)`will be call back。

- The play progress
Set value to `EAMiniAudioPlayerView`'s`playProgress`property（0<downloadProgress<1）can change the playing progress .When `playProgress`'s value is greater than or equal 1,`void(^playCompleted)(void)`will be call back。

- Other
Custom cornerRadius、Edge insets、custom colors。


