//
//  KWTransitionHelper.m
//  AnimatedTransitionGallery
//
//  Created by shuichi on 4/16/14.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "KWTransitionHelper.h"

NSString * const KWTransitionStyleNameRotateFromTop  = @"KWTransitionStyleRotateFromTop";
NSString * const KWTransitionStyleNameFadeBackOver   = @"KWTransitionStyleFadeBackOver";
NSString * const KWTransitionStyleNameBounceIn       = @"KWTransitionStyleBounceIn";
NSString * const KWTransitionStyleNameDropOut        = @"KWTransitionStyleDropOut";
NSString * const KWTransitionStyleNameStepBackScroll = @"KWTransitionStyleStepBackScroll";
NSString * const KWTransitionStyleNameStepBackSwipe  = @"KWTransitionStyleStepBackSwipe";
NSString * const KWTransitionStyleNameUp             = @"KWTransitionStyleUp";
NSString * const KWTransitionStyleNamePushUp         = @"KWTransitionStylePushUp";
NSString * const KWTransitionStyleNameFall           = @"KWTransitionStyleFall";
NSString * const KWTransitionStyleNameSink           = @"KWTransitionStyleSink";


@implementation KWTransitionHelper

+ (KWTransitionStyle)styleForTransitionName:(NSString *)transitionName {

    if ([transitionName isEqualToString:KWTransitionStyleNameRotateFromTop]) {
        
        return KWTransitionStyleRotateFromTop;
    }
    else if ([transitionName isEqualToString:KWTransitionStyleNameFadeBackOver]) {
        
        return KWTransitionStyleFadeBackOver;
    }
    else if ([transitionName isEqualToString:KWTransitionStyleNameBounceIn]) {
        
        return KWTransitionStyleBounceIn;
    }
    else if ([transitionName isEqualToString:KWTransitionStyleNameDropOut]) {
        
        return KWTransitionStyleDropOut;
    }
    else if ([transitionName isEqualToString:KWTransitionStyleNameStepBackScroll]) {
        
        return KWTransitionStyleStepBackScroll;
    }
    else if ([transitionName isEqualToString:KWTransitionStyleNameStepBackSwipe]) {
        
        return KWTransitionStyleStepBackSwipe;
    }
    else if ([transitionName isEqualToString:KWTransitionStyleNameUp]) {
        
        return KWTransitionStyleUp;
    }
    else if ([transitionName isEqualToString:KWTransitionStyleNamePushUp]) {
        
        return KWTransitionStylePushUp;
    }
    else if ([transitionName isEqualToString:KWTransitionStyleNameFall]) {
        
        return KWTransitionStyleFall;
    }
    else if ([transitionName isEqualToString:KWTransitionStyleNameSink]) {
        
        return KWTransitionStyleSink;
    }
    else {
        
        return 0;        // = KWTransitionStyleRotateFromTop
    }
}

@end
