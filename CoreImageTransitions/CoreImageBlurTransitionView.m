//
//  CoreImageBlurTransitionView.m
//
//  Created by Shuichi Tsutsumi on 10/7/15.
//  Copyright © 2015 Shuichi Tsutsumi. All rights reserved.
//

#import "CoreImageBlurTransitionView.h"


@implementation CoreImageBlurTransitionView

// time には 0.0 - 1.0 に正規化された値が来る
- (CIImage *)imageForTransitionAtTime:(float)time
{
    CGFloat radius = 0;
    if (time < 0.5) {
        [self.transition setValue:self.inputImage forKey:kCIInputImageKey];
        radius = time * 0.5 * 100;
    }
    else {
        [self.transition setValue:self.inputTargetImage forKey:kCIInputImageKey];
        radius = (1.0 - time) * 100;
    }
    
//    NSLog(@"radius:%f", radius);
    
    [self.transition setValue:@(radius) forKey:kCIInputRadiusKey];
    
    CIImage *transitionImage = [self.transition valueForKey:kCIOutputImageKey];
    
    
    return transitionImage;
}

@end
