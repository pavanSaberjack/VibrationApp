//
//  PIViewController.m
//  VibrateTest
//
//  Created by pavan on 7/15/13.
//  Copyright (c) 2013 pavan_saberjack. All rights reserved.
//

#import "PIViewController.h"
#import "AVCamCaptureManager.h"

@interface PIViewController ()<AVCamCaptureManagerDelegate>
@property (nonatomic,retain) UIView *videoPreviewView;
@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@end

@implementation PIViewController
@synthesize captureManager, videoPreviewView;

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
    
    [self createThePage];
    
    
    UIButton *recordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [recordButton setFrame:CGRectMake(10, 10, 50, 50)];
    [recordButton addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordButton];
    
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [stopButton setFrame:CGRectMake(100, 10, 50, 50)];
    [stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
}

- (void)record
{
    [[self captureManager] startRecording];
}

- (void)stop
{
    [[[self captureManager] session] stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)createThePage
{    
    videoPreviewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    videoPreviewView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:videoPreviewView];
    
    
    if ([self captureManager] == nil)
    {
		AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
		[self setCaptureManager:manager];
		[manager release];
		
		[[self captureManager] setDelegate:self];
        
		if ([[self captureManager] setupSession])
        {
            // Create video preview layer and add it to the UI
			AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
			UIView *view = [self videoPreviewView];
			CALayer *viewLayer = [view layer];
			[viewLayer setMasksToBounds:YES];
			
			CGRect bounds = [view bounds];
			[newCaptureVideoPreviewLayer setFrame:bounds];
            [newCaptureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
			
			[newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
			
			[viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
			
			[self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
            [newCaptureVideoPreviewLayer release];
			
            // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
				[[[self captureManager] session] startRunning];
			});
			
		}
	}
    
}

#pragma mark - AVCamCaptureManagerDelegate methods
- (void)captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    });
}

- (void)captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
//        [recordButton setBackgroundImage:[UIImage imageNamed:@"recordEvent_stopBtn.png"] forState:UIControlStateNormal];
    });
}

- (void)captureManagerRecordingFinished:(AVCamCaptureManager *)captureManagerTemp
{
    //we have to copy video from path A to Path B for that : 1) first remove contents from path B if any. 2) then copy from path A to path B. 3) then remove contents from path A
    NSString *filePathCopy = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePathCopy = [filePathCopy stringByAppendingPathComponent:@"temp.mov"];
    NSError *errorRemove = nil;
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:filePathCopy] error:&errorRemove];
    
    NSError *errorCopy = nil;
    [[NSFileManager defaultManager] copyItemAtURL:captureManagerTemp.managetOutputFileURL toURL:[NSURL fileURLWithPath:filePathCopy] error:&errorCopy];
    
    errorRemove = nil;
    [[NSFileManager defaultManager] removeItemAtURL:captureManagerTemp.managetOutputFileURL error:&errorRemove];
    
    
}

- (void)captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager
{
    
}

- (void)captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager
{
    
}

@end
