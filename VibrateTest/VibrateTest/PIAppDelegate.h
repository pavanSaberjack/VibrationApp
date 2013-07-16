//
//  PIAppDelegate.h
//  VibrateTest
//
//  Created by pavan on 7/15/13.
//  Copyright (c) 2013 pavan_saberjack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIAppDelegate : UIResponder <UIApplicationDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NSTimer *timer;
@end
