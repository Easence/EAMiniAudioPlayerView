//
//  EAAudioPlayerView.h
//  EAAudioPlayerViewDemo
//
//  Created by EA.Huang on 5/19/16.
//  Copyright © 2016 EAH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAMiniAudioPlayerStyleConfig.h"

@interface EAMiniAudioPlayerView : UIView


//After touched play button,this block will be call back
@property (nonatomic, copy) void (^doPlay)(id sender, bool isPlay);

//After touched miniAudioPlayerView,this block will be call back
@property (nonatomic, copy) void (^touchedPlayerView)(id sender);

//wave icon
@property (nonatomic, strong) UIImageView *soundIcon;
//The label to display text
@property (nonatomic, strong ,readonly) UILabel* textLabel;

//The play button of the MiniAudioPlayerView. If the player style is set EAMiniPlayerHidelayButton,playButton will be nil.
@property (nonatomic, strong ,readonly) UIButton* playButton;

//The playing progress ratio for the player
@property (nonatomic, assign) CGFloat playProgress;

//when play completed,this block will be callback
@property (nonatomic, copy) void(^playCompleted)(void);

//The download progress ratio for the player
@property (nonatomic, assign) CGFloat downloadProgress;

//when download completed,this block will be callback
@property (nonatomic, copy) void(^downloadCompleted)(void);

//style configration
@property (nonatomic, strong) EAMiniAudioPlayerStyleConfig *styleConfig;

/**
 *  @param playerStyle  EAMiniPlayerStyle
 *  @param cornerRadius The radius on both side of the MiniAudioPlayerView
 */
- (instancetype)initWithPlayerStyleConfig:(EAMiniAudioPlayerStyleConfig *) config;

@end
