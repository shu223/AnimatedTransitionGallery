//
//  KWTransitionHelper.h
//  AnimatedTransitionGallery
//
//  Created by shuichi on 4/16/14.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWTransition.h"


extern NSString * const KWTransitionStyleNameRotateFromTop;
extern NSString * const KWTransitionStyleNameFadeBackOver;
extern NSString * const KWTransitionStyleNameBounceIn;
extern NSString * const KWTransitionStyleNameDropOut;
extern NSString * const KWTransitionStyleNameStepBackScroll;
extern NSString * const KWTransitionStyleNameStepBackSwipe;
extern NSString * const KWTransitionStyleNameUp;
extern NSString * const KWTransitionStyleNamePushUp;
extern NSString * const KWTransitionStyleNameFall;
extern NSString * const KWTransitionStyleNameSink;


@interface KWTransitionHelper : NSObject

+ (KWTransitionStyle)styleForTransitionName:(NSString *)transitionName;

@end
