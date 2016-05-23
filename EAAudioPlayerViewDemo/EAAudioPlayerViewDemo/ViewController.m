//
//  ViewController.m
//  EAAudioPlayerViewDemo
//
//  Created by talkweb on 5/19/16.
//  Copyright © 2016 EAH. All rights reserved.
//

#import "ViewController.h"
#import "EAMiniAudioPlayerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet EAMiniAudioPlayerView *miniAudioPlayerView;
@property (weak, nonatomic) IBOutlet EAMiniAudioPlayerView *miniAudioPlayerView2;
@property (weak, nonatomic) IBOutlet EAMiniAudioPlayerView *miniAudioPlayerView3;
@property (strong ,nonatomic) EAMiniAudioPlayerStyleConfig *config;

@property (weak, nonatomic) NSTimer *playTimer;
@property (weak, nonatomic) NSTimer *downloadTimer;

@end

static NSInteger seconds = 1;
static NSInteger downloadProgress = 1;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.config = [EAMiniAudioPlayerStyleConfig defaultConfig];
    self.config.cornerRadius  = self.miniAudioPlayerView.bounds.size.height / 2;
    self.miniAudioPlayerView.styleConfig = self.config;
    self.miniAudioPlayerView.playButton.enabled = NO;
    self.miniAudioPlayerView.textLabel.text = @"38''";
    
    __weak typeof(self) weakSelf = self;
    
    self.miniAudioPlayerView.touchedPlayerView = ^(id sender)
    {
        if(weakSelf.miniAudioPlayerView.downloadProgress <= 0)
        {
            weakSelf.miniAudioPlayerView.textLabel.text = @"downloading";
            weakSelf.config.playerStyle |= EAMiniPlayerHideSoundIcon;
            weakSelf.downloadTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(download:) userInfo:nil repeats:YES];
        }
    };
    
    self.miniAudioPlayerView.doPlay = ^(id sender, bool isPlay) {
        if(isPlay)
        {
            weakSelf.miniAudioPlayerView.textLabel.text = @"playing";
            weakSelf.playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increaseSeconds:) userInfo:nil repeats:YES];
            weakSelf.config.playerStyle |= EAMiniPlayerHideSoundIcon;
        }
        else
        {
            if(weakSelf.playTimer)
            {
                [weakSelf.playTimer invalidate];
                weakSelf.playTimer = nil;
                weakSelf.miniAudioPlayerView.textLabel.text = @"38''";
               weakSelf.config.playerStyle = EAMiniPlayerNormal;
            }
            
        }
    };
    
    self.miniAudioPlayerView.downloadCompleted = ^{
        
        NSLog(@"miniAudioPlayerView download completed!");
        
        weakSelf.miniAudioPlayerView.textLabel.text = @"38''";
        weakSelf.config.playerStyle = EAMiniPlayerNormal;
        if([weakSelf.downloadTimer isValid])
        {
            [weakSelf.downloadTimer invalidate];
            weakSelf.downloadTimer = nil;
            downloadProgress = 0;
            weakSelf.miniAudioPlayerView.playButton.enabled = YES;
        }
    };
    
    self.miniAudioPlayerView.playCompleted = ^{
        NSLog(@"miniAudioPlayerView play completed!");
        seconds = 0;
        weakSelf.miniAudioPlayerView.playProgress = 0;
        
        if(weakSelf.playTimer)
        {
            [weakSelf.playTimer invalidate];
            weakSelf.playTimer = nil;
            weakSelf.miniAudioPlayerView.textLabel.text = @"38''";
            weakSelf.config.playerStyle = EAMiniPlayerNormal;
        }
        
    };
    
    EAMiniAudioPlayerStyleConfig *config2 = [EAMiniAudioPlayerStyleConfig defaultConfig];
    config2.contentInsets = UIEdgeInsetsMake(0, 0, 0, 25);
    config2.playerStyle |= EAMiniPlayerHidePlayButton;
    self.miniAudioPlayerView2.styleConfig = config2;
    self.miniAudioPlayerView2.textLabel.text = @"record";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)increaseSeconds:(id)userInfo
{
    NSInteger tempSeconds = seconds ++;
    self.miniAudioPlayerView.playProgress = (CGFloat)tempSeconds / 100.f;
}

- (void)download:(id)userInfo
{
    NSInteger tempDownloadProgress = downloadProgress ++ * 10;
    self.miniAudioPlayerView.downloadProgress = (CGFloat)tempDownloadProgress / 100.f;
}

@end
