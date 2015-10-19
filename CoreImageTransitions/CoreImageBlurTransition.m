//
//  CoreImageBlurTransition.m
//
//  Created by Shuichi Tsutsumi on 10/7/15.
//  Copyright © 2015 Shuichi Tsutsumi. All rights reserved.
//

#import "CoreImageBlurTransition.h"
#import "CoreImageBlurTransitionView.h"


@interface CoreImageBlurTransition ()
@property (nonatomic, strong) CoreImageBlurTransitionView *transitionView;
@end


@implementation CoreImageBlurTransition

- (void)setTransitionTypeWithName:(NSString *)name {
    
    self.type = CoreImageTransitionTypeDissolve;
    
    if ([name isEqualToString:kCoreImageTransitionTypeNameGaussianBlur]) {
        self.type = CoreImageTransitionTypeGaussianBlur;
    }
    else if ([name isEqualToString:kCoreImageTransitionTypeNameBoxBlur]) {
        self.type = CoreImageTransitionTypeBoxBlur;
    }
    else if ([name isEqualToString:kCoreImageTransitionTypeNameDiscBlur]) {
        self.type = CoreImageTransitionTypeDiscBlur;
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    
    UIImage *fromSnapshot = [fromVC.view snapshot];
    UIImage *toSnapshot = [toVC.view snapshot];
    
    // Start animating using Core Image
    self.transitionView = [[CoreImageBlurTransitionView alloc] initWithFrame:containerView.bounds
                                                                   fromImage:fromSnapshot
                                                                     toImage:toSnapshot];
    [self.transitionView changeTransition:self.type];
    [self.transitionView setDuration:[self transitionDuration:transitionContext]];
    [[transitionContext containerView] addSubview:self.transitionView];
    [self.transitionView start];
    
    // Finish after the duration
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW,
                                         [self transitionDuration:transitionContext] * NSEC_PER_SEC);
    dispatch_after(when, dispatch_get_main_queue(), ^{
        [self.transitionView stop];
        [self.transitionView removeFromSuperview];
        [transitionContext completeTransition:YES];
    });
}

@end
