//
//  EAAudioPlayerView.m
//  EAAudioPlayerView
//
//  Created by EA.Huang on 5/19/16.
//  Copyright © 2016 EAH. All rights reserved.
//

#import "EAMiniAudioPlayerView.h"
#import "UIButton+EAButtonExtendedHit.h"

@interface EAMiniAudioPlayerView ()

@property (nonatomic, assign) EAMiniPlayerStyle preStyle;

//A UIView used to wrap play button and playProgressLayer
@property (nonatomic , strong) UIView *playButtonContentView;
//Used to draw playing progress
@property (nonatomic, strong) CAShapeLayer *playProgressLayer;

@property (nonatomic, strong) CAShapeLayer *downloadProgressLayer;

@end

static void  *EAAudioPlayerTextLabelContext = &EAAudioPlayerTextLabelContext;

@implementation EAMiniAudioPlayerView

- (instancetype)initWithPlayerStyleConfig:(EAMiniAudioPlayerStyleConfig *) config
{
    self = [self init];
    if(self)
    {
        self.styleConfig = config;
        [self prepareContetxt];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.styleConfig = [EAMiniAudioPlayerStyleConfig defaultConfig];
        [self prepareContetxt];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.styleConfig = [EAMiniAudioPlayerStyleConfig defaultConfig];
        [self prepareContetxt];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.styleConfig = [EAMiniAudioPlayerStyleConfig defaultConfig];
        
        [self prepareContetxt];
    }
    return self;
}

- (void)prepareContetxt
{
    self.layer.borderColor = [UIColor colorWithRed:0.8784 green:0.8784 blue:0.8784 alpha:1.0].CGColor;
    self.layer.borderWidth = .5;
    self.layer.masksToBounds  = YES;

    if(!self.downloadProgressLayer)
    {
        self.downloadProgressLayer = [CAShapeLayer layer];
        self.downloadProgressLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        [self.layer addSublayer:self.downloadProgressLayer];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
        recognizer.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:recognizer];
        
        [self createPlayButtonIfNeed];
        [self createSoundIconIfNeed];
        [self createTextLabelIfNeed];
    }
    
}

- (void)setStyleConfig:(EAMiniAudioPlayerStyleConfig *)styleConfig
{
    _styleConfig = styleConfig;
    [self setNeedsLayout];
}

- (void)setPlayProgress:(CGFloat)progress
{
    _playProgress = progress;
    [self updatePlayProgress];
}

- (void)setDownloadProgress:(CGFloat)downloadProgress
{
    _downloadProgress = downloadProgress;
    [self updateDownloadProgress];
}

//Update player's progress
- (void)updatePlayProgress
{
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = startAngle + self.playProgress * M_PI * 2;
    
    //if the player is play end
    if(fabs(endAngle - startAngle) > M_PI * 2)
    {
        if(self.playButton.selected)
        {
            [self.playButton setSelected:NO];
            
            if(self.playCompleted)
            {
                self.playCompleted();
            }
        }
        return;
    }
    //if the player is playing
    else if(fabs(endAngle - startAngle) > 0)
    {
        if(!self.playButton.selected)
        {
            [self.playButton setSelected:YES];
        }
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.playButtonContentView.bounds) / 2, CGRectGetHeight(self.playButtonContentView.bounds) / 2) radius:ceilf(self.playButtonContentView.layer.cornerRadius - self.playButtonContentView.layer.borderWidth) startAngle:startAngle endAngle:endAngle clockwise:YES];
    [self.playProgressLayer setPath:path.CGPath];
}

- (void)updateDownloadProgress
{
    if(self.downloadProgress > 1.0f)
    {
        if(self.downloadCompleted)
        {
            self.downloadCompleted();
        }
        return;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ceilf(self.downloadProgress * self.bounds.size.width), self.bounds.size.height) cornerRadius:0];
    [self.downloadProgressLayer setPath:path.CGPath];
}

- (void)createPlayButtonIfNeed
{
    if(!self.playButtonContentView)
    {
        self.playButtonContentView = [[UIView alloc] init];
        self.playButtonContentView.backgroundColor = self.styleConfig.playButtonBackgroundColor;
        self.playButtonContentView.layer.borderColor = self.styleConfig.playButtonBorderColor.CGColor;
        self.playButtonContentView.layer.borderWidth = .5;
        self.playButtonContentView.layer.masksToBounds = YES;
        
        [self addSubview:self.playButtonContentView];
        
        self.playProgressLayer = [CAShapeLayer layer];
        self.playProgressLayer.backgroundColor = [UIColor clearColor].CGColor;
        self.playProgressLayer.lineWidth = self.styleConfig.playProgressWidth;
        self.playProgressLayer.fillColor = [UIColor clearColor].CGColor;
        self.playProgressLayer.strokeColor = self.styleConfig.playProgressColor.CGColor;
        
        [self.playButtonContentView.layer addSublayer:self.playProgressLayer];
        
        if(!_playButton)
        {
            _playButton = [[UIButton alloc] init];
            [self.playButtonContentView addSubview:self.playButton];
        }
        [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"btn_stop"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(doplayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutPlayButton
{
    if(self.styleConfig.playerStyle & EAMiniPlayerHidePlayButton)
    {
        if(self.playButtonContentView)
        {
            [self.playButtonContentView removeFromSuperview];
            self.playButtonContentView = nil;
        }
    }
    else
    {
        [self createPlayButtonIfNeed];
        
        
        CGFloat offset = 10;
        
        CGRect frame = CGRectMake(offset + self.styleConfig.contentInsets.left, offset + self.styleConfig.contentInsets.top, self.bounds.size.height - 2 * offset - self.styleConfig.contentInsets.top - self.styleConfig.contentInsets.bottom, self.bounds.size.height - 2 * offset- self.styleConfig.contentInsets.top - self.styleConfig.contentInsets.bottom);
        
        //If hide hide sound icon and text label
        if((self.styleConfig.playerStyle & EAMiniPlayerHideSoundIcon) && (self.styleConfig.playerStyle & EAMiniPlayerHideText))
        {
            frame = CGRectMake(offset + self.styleConfig.contentInsets.left, offset + self.styleConfig.contentInsets.top, self.bounds.size.width - self.styleConfig.contentInsets.left - self.styleConfig.contentInsets.right - 2 * offset ,self.bounds.size.height - self.styleConfig.contentInsets.top - self.styleConfig.contentInsets.bottom - 2 * offset);
        }
        
        self.playButtonContentView.frame = frame;
        self.playProgressLayer.frame = self.playButtonContentView.bounds;
        self.playButtonContentView.layer.cornerRadius = CGRectGetWidth(frame) / 2;
        
        //-------------------caculate playbutton's frame--------------------------
        CGSize buttonImageSize = [UIImage imageNamed:@"btn_play"].size;
        CGSize buttonSize = CGSizeMake(frame.size.width / 3, frame.size.height / 3);
        
        //if play button's background image size if samller than frame.size.height / 3
        if((buttonImageSize.height > buttonImageSize.width && buttonImageSize.height < buttonSize.height)
           || (buttonImageSize.width > buttonImageSize.height && buttonImageSize.width < buttonSize.width))
        {
            buttonSize = buttonImageSize;
        }
        
        frame.origin.x = (frame.size.width - buttonSize.width) / 2;
        frame.origin.y = (frame.size.height - buttonSize.height) / 2;
        frame.size.height = buttonSize.height;
        frame.size.width = buttonSize.width;
        
        self.playButton.frame = frame;
        
        self.playButton.hitEdgeInsets = UIEdgeInsetsMake(CGRectGetHeight(self.playButtonContentView.bounds) - CGRectGetHeight(self.playButton.bounds) / 2, CGRectGetWidth(self.playButtonContentView.bounds) - CGRectGetWidth(self.playButton.bounds) / 2, CGRectGetHeight(self.playButtonContentView.bounds) - CGRectGetHeight(self.playButton.bounds) / 2, CGRectGetWidth(self.playButtonContentView.bounds) - CGRectGetWidth(self.playButton.bounds) / 2);
        
    }
}

- (void)createSoundIconIfNeed
{
    if(!_soundIcon)
    {
        _soundIcon = [[UIImageView alloc] init];
        _soundIcon.contentMode = UIViewContentModeScaleAspectFit;
        _soundIcon.clipsToBounds = YES;
        _soundIcon.image = [UIImage imageNamed:@"icon_audio"];
        [self addSubview:_soundIcon];
    }
    
}

- (void)layoutSoundIcon
{
    if(self.styleConfig.playerStyle & EAMiniPlayerHideSoundIcon)
    {
        if(_soundIcon)
        {
            [_soundIcon removeFromSuperview];
            _soundIcon = nil;
        }
    }
    else
    {
     
        [self createSoundIconIfNeed];
        
        CGSize soundIconSize = [UIImage imageNamed:@"icon_audio"].size;

        CGFloat offset = 10;
        CGRect frame = CGRectMake(offset + self.styleConfig.contentInsets.left, self.styleConfig.contentInsets.top + (self.bounds.size.height - soundIconSize.height) / 2, soundIconSize.width ,soundIconSize.height);
        
        //If hide play button and hide sound icon
        if((self.styleConfig.playerStyle & EAMiniPlayerHidePlayButton) && (self.styleConfig.playerStyle & EAMiniPlayerHideText))
        {
            _soundIcon.frame = CGRectMake(0, 0, soundIconSize.width, soundIconSize.height);
            _soundIcon.center = self.center;
        }
        else if(self.styleConfig.playerStyle & EAMiniPlayerHideText)
        {
            frame.origin.x = CGRectGetMaxX(self.playButtonContentView.frame) + offset;
            frame.origin.y = self.playButtonContentView.center.y - soundIconSize.height / 2;
            frame.size.width = soundIconSize.width;
            frame.size.height = soundIconSize.height;
        }
        
        _soundIcon.frame = frame;
    }
}

- (void)createTextLabelIfNeed
{
    if(!_textLabel)
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentRight;
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor colorWithRed:0.6157 green:0.6157 blue:0.6157 alpha:1.0];
        [self addSubview:_textLabel];
        
        [self addObserver:self forKeyPath:@"textLabel.text" options:NSKeyValueObservingOptionNew context:EAAudioPlayerTextLabelContext];
    }
}

- (void)layoutTextLabel
{
    if(self.styleConfig.playerStyle & EAMiniPlayerHideText)
    {
        if(_textLabel)
        {
            [self addObserver:self forKeyPath:@"textLabel.text" options:NSKeyValueObservingOptionNew context:EAAudioPlayerTextLabelContext];
            [_textLabel removeFromSuperview];
            _textLabel = nil;
        }
    }
    else
    {
        [self createTextLabelIfNeed];
        
        CGFloat offset = 10;
        CGRect frame = CGRectMake(offset + self.styleConfig.contentInsets.left, offset + self.styleConfig.contentInsets.top, self.bounds.size.width - self.styleConfig.contentInsets.left - self.styleConfig.contentInsets.right - 2 * offset ,self.bounds.size.height - self.styleConfig.contentInsets.top - self.styleConfig.contentInsets.bottom - 2 * offset);
        
        //If hide play button and hide sound icon
        if((self.styleConfig.playerStyle & EAMiniPlayerHidePlayButton) && (self.styleConfig.playerStyle & EAMiniPlayerHideSoundIcon))
        {
            _textLabel.textAlignment = NSTextAlignmentCenter;
        }
        else if(self.styleConfig.playerStyle & EAMiniPlayerHideSoundIcon)
        {
            if(self.playButtonContentView)
            {
                frame.origin.x = CGRectGetMaxX(self.playButtonContentView.frame) + offset;
                frame.size.width = self.bounds.size.width - frame.origin.x - self.styleConfig.contentInsets.right- offset;
            }
        } else if(self.styleConfig.playerStyle & EAMiniPlayerHidePlayButton)
        {
             if(_soundIcon)
             {
                 frame.origin.x = CGRectGetMaxX(_soundIcon.frame) + offset;
                 frame.size.width = self.bounds.size.width - frame.origin.x - self.styleConfig.contentInsets.right;
             }
            _textLabel.textAlignment = NSTextAlignmentLeft;
            
        }
        else
        {
            CGSize soundIconSize = [UIImage imageNamed:@"icon_audio"].size;
            
            if(_soundIcon)
            {
                frame.origin.x = CGRectGetMaxX(_soundIcon.frame) + offset;
                frame.size.width = self.bounds.size.width - frame.origin.x - self.styleConfig.contentInsets.right;
                
                [_textLabel sizeToFit];
                
                //
                if(_textLabel.frame.size.width < frame.size.width)
                {
                    frame.origin.x = self.bounds.size.width - _textLabel.frame.size.width - offset - self.styleConfig.contentInsets.right;
                    frame.size.width = _textLabel.frame.size.width;
                    
                    CGRect soundIconFrame = _soundIcon.frame;
                    soundIconFrame.origin.x = frame.origin.x - offset - soundIconSize.width;
                    _soundIcon.frame = soundIconFrame;
                }
            }
            
        }
        
        _textLabel.frame = frame;
        
    }
}

- (void)doplayAction:(id) sender
{
    [self.playButton setSelected:!self.playButton.isSelected];
    
    if(self.doPlay)
    {
        self.doPlay(sender, self.playButton.isSelected);
    }
}

- (void)touched:(UITapGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if(self.touchedPlayerView)
        {
            self.touchedPlayerView(self);
        }
    }
}

- (void)layoutSubviews
{
    self.downloadProgressLayer.fillColor = self.styleConfig.downloadProgressColor.CGColor;
    self.layer.cornerRadius = self.styleConfig.cornerRadius;
    
    //layout play button
    [self layoutPlayButton];
    [self layoutSoundIcon];
    [self layoutTextLabel];
    
    [super layoutSubviews];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if(context == EAAudioPlayerTextLabelContext)
    {
        if([keyPath isEqualToString:@"textLabel.text"])
        {
            [self setNeedsLayout];
        }
    }
}

- (void)dealloc
{
    if(_textLabel)
    {
        [self removeObserver:self forKeyPath:@"textLabel.text"];
    }
}

@end
