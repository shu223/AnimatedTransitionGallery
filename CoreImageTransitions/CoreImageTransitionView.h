//
//  TransitionView.h
//  CITransitionSample
//
//  Created by shuichi on 13/03/10.
//  Copyright (c) 2013年 Shuichi Tsutsumi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "CoreImageTransitionTypes.h"


@interface CoreImageTransitionView : GLKView

- (instancetype)initWithFrame:(CGRect)frame
                    fromImage:(UIImage *)fromImage
                      toImage:(UIImage *)toImage;

- (void)changeTransition:(CoreImageTransitionType)type;
- (NSString *)currentFilterName;

@end
