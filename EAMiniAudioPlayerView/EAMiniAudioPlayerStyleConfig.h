//
//  EAMiniAudioPlayerStyleConfig.h
//  EAAudioPlayerViewDemo
//
//  Created by talkweb on 5/20/16.
//  Copyright © 2016 EAH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EAMiniPlayerStyle) {
    EAMiniPlayerNormal = 1 << 0,   //Has play button,sound icon
    EAMiniPlayerHidePlayButton = 1 << 1, //Hide play button
    EAMiniPlayerHideSoundIcon = 1 << 2, //Hide sound icon
    EAMiniPlayerHideText = 1 << 3, //Hide text label
};

@interface EAMiniAudioPlayerStyleConfig : NSObject

//The style of EAMiniAudioPlayerView
@property (nonatomic , assign) EAMiniPlayerStyle playerStyle;

//The radius on both side of the MiniAudioPlayerView
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 * The inset of the content to display
 *  ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 +                       top                          +
 +                                                    +
 +  left  play button |  sound icon | text   right    +
 +                                                    +
 +                       bottom                       +
 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

//play button background color
@property (nonatomic, strong) UIColor *playButtonBackgroundColor;
//play button border color
@property (nonatomic, strong) UIColor *playButtonBorderColor;
// play progress bar color
@property (nonatomic, strong) UIColor *playProgressColor;
// play progress bar color
@property (nonatomic, assign) CGFloat playProgressWidth;

// download progress bar color
@property (nonatomic, strong) UIColor *downloadProgressColor;

+ (instancetype) defaultConfig;

@end
