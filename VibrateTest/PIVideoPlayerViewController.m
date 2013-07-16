//
//  PIVideoPlayerViewController.m
//  VibrateTest
//
//  Created by pavan on 7/16/13.
//  Copyright (c) 2013 pavan_saberjack. All rights reserved.
//

#import "PIVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerView.h"

static const NSString *ItemStatusContext;

@interface PIVideoPlayerViewController ()
@property (nonatomic, retain) AVPlayer *player;
@property (retain) AVPlayerItem *playerItem;
@property (nonatomic, retain) PlayerView *playerView;
@end

@implementation PIVideoPlayerViewController
@synthesize playerView, player, playerItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeVideoPlayer];
    [self loadAssetFromFile];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeVideoPlayer
{
    CGFloat selfWidth = self.view.frame.size.width;
    CGFloat selfHeight = self.view.frame.size.height;
    playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0,0,selfWidth,selfHeight)];
    playerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:playerView];
}

- (void)loadAssetFromFile
{
    NSString *filePathCopy = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePathCopy = [filePathCopy stringByAppendingPathComponent:@"temp.mov"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePathCopy];
    //    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"novusport_landing_video" withExtension:@"mp4"];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    
    self.playerItem = nil;
    NSString *tracksKey = @"tracks";
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:tracksKey] completionHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            NSError *error = nil;
            AVKeyValueStatus status = [asset statusOfValueForKey:tracksKey error:&error];
            if (status == AVKeyValueStatusLoaded)
            {
                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                [playerItem addObserver:self forKeyPath:@"status" options:0 context:&ItemStatusContext];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
                
                self.player = [AVPlayer playerWithPlayerItem:playerItem];
                [playerView setPlayer:player];
                [player play];
            }
            else
            {
                NSLog(@"The asset's tracks were not loaded:\n%@", [error localizedDescription]);
            }
        });
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &ItemStatusContext)
    {

        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    return;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [player seekToTime:kCMTimeZero];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
