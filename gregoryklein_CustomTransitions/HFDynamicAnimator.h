//
//  HFDynamicAnimator.h
//  CustomAnimations
//
//  Created by Gregory Klein on 11/13/13.
//  Copyright (c) 2013 HardFlip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFDynamicAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter = isPresented) BOOL presenting;

@end
