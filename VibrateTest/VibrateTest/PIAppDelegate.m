//
//  PIAppDelegate.m
//  VibrateTest
//
//  Created by pavan on 7/15/13.
//  Copyright (c) 2013 pavan_saberjack. All rights reserved.
//

#import "PIAppDelegate.h"
#import <AudioToolbox/AudioServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "PIViewController.h"

@implementation PIAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
        
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    //[[imagePicker view] setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setDelegate:self];
    [imagePicker setEditing:YES];
    [imagePicker setAllowsEditing:YES];
  //  imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
   
    [self.window setRootViewController:imagePicker];
    
    
//    NSThread * thr = [[NSThread alloc] initWithTarget:self selector:@selector(vibrate) object:nil];
//    [thr start];
//    
    NSTimer *t= [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(vibrate1) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:t forMode:NSDefaultRunLoopMode];

    
//    [NSThread detachNewThreadSelector:@selector(vibrate) toTarget:self withObject:nil];
    
    return YES;
}

- (void)vibrate1
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); 
}

- (void)vibrate
{
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); 
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
