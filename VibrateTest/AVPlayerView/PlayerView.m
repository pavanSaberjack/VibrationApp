//
//  PlayerView.m
//  AvCustomVideoPlayer
//
//  Created by Srinidhi Meera on 6/26/12.
//  Copyright (c) 2012 YMedia Labs. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (Class)layerClass {
    
    return [AVPlayerLayer class];
    
}

- (AVPlayer*)player {
    
    return [(AVPlayerLayer *)[self layer] player];
    
}

- (void)setPlayer:(AVPlayer *)player {
    
    [(AVPlayerLayer *)[self layer] setPlayer:player];
    
}

@end
