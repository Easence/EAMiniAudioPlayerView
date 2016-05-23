//
//  EAMiniAudioPlayerStyleConfig.m
//  EAAudioPlayerViewDemo
//
//  Created by talkweb on 5/20/16.
//  Copyright © 2016 EAH. All rights reserved.
//

#import "EAMiniAudioPlayerStyleConfig.h"

@implementation EAMiniAudioPlayerStyleConfig

+ (instancetype) defaultConfig
{
    EAMiniAudioPlayerStyleConfig* defautConfig = [[EAMiniAudioPlayerStyleConfig alloc] init];

    defautConfig.playerStyle = EAMiniPlayerNormal;
    defautConfig.playProgressColor = [UIColor colorWithRed:0.1961 green:0.6667 blue:0.2235 alpha:1.0];
    defautConfig.playProgressWidth = 4.f;
    defautConfig.downloadProgressColor = [UIColor whiteColor];
    defautConfig.playButtonBackgroundColor = [UIColor whiteColor];
    defautConfig.playButtonBorderColor = [UIColor colorWithRed:0.8784 green:0.8784 blue:0.8784 alpha:1.0];
    
    return defautConfig;
}

@end
