//
//  CoreImageMotionBlurTransition.m
//
//  Created by Shuichi Tsutsumi on 10/7/15.
//  Copyright © 2015 Shuichi Tsutsumi. All rights reserved.
//

#import "CoreImageMotionBlurTransition.h"
#import "CoreImageMotionBlurTransitionView.h"


@interface CoreImageMotionBlurTransition ()
@property (nonatomic, strong) CoreImageMotionBlurTransitionView *transitionView;
@end



@implementation CoreImageMotionBlurTransition

- (void)setTransitionTypeWithName:(NSString *)name {
    
    self.type = CoreImageTransitionTypeDissolve;
    
    if ([name isEqualToString:kCoreImageTransitionTypeNameMotionBlur]) {
        self.type = CoreImageTransitionTypeMotionBlur;
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
    
    
    UIImage *snapshot;
    CGRect initialFrame;
    CGRect targetFrame;

    // Animating view: toVC.view
    if (self.presenting) {

        snapshot = [toVC.view snapshot];
        targetFrame  = [transitionContext finalFrameForViewController:toVC];
        initialFrame = CGRectMake(targetFrame.size.width, 0, targetFrame.size.width, targetFrame.size.height);

        [containerView addSubview:fromVC.view];
    }
    // Animating view: fromVC.view
    else {

        snapshot = [fromVC.view snapshot];
        initialFrame = [transitionContext initialFrameForViewController:fromVC];
        targetFrame  = CGRectMake(initialFrame.size.width, 0, initialFrame.size.width, initialFrame.size.height);

        [containerView addSubview:toVC.view];
    }

    // Start animating using Core Image
    self.transitionView = [[CoreImageMotionBlurTransitionView alloc] initWithFrame:containerView.bounds
                                                                         fromImage:snapshot
                                                                           toImage:nil];
    [self.transitionView changeTransition:self.type];
    [self.transitionView setPresenting:self.presenting];
    [self.transitionView setDuration:[self transitionDuration:transitionContext]];
    self.transitionView.frame = initialFrame;
    [[transitionContext containerView] addSubview:self.transitionView];
    [self.transitionView start];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transitionView.frame = targetFrame;
                     } completion:^(BOOL finished) {
                         [self.transitionView stop];
                         [self.transitionView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

@end
