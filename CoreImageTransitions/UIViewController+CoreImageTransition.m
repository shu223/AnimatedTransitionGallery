//
//  UIViewController+Transition.m
//
//  Created by Shuichi Tsutsumi on 10/13/15.
//  Copyright © 2015 Shuichi Tsutsumi. All rights reserved.
//

#import "UIViewController+CoreImageTransition.h"
#import "CoreImageBlurTransitionView.h"


@implementation UIViewController (CoreImageTransition)

- (void)transitionFromViewController:(UIViewController *)fromVC
                    toViewController:(UIViewController *)toVC
                          presenting:(BOOL)presenting
                            duration:(NSTimeInterval)duration
                          completion:(void (^)(void))completion
{
    [self addChildViewController:toVC];
    [self.view addSubview:toVC.view];

    // shouldn't be processed in background because it uses OpenGL.
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        [fromVC willMoveToParentViewController:nil];
        [fromVC.view removeFromSuperview];
        [fromVC removeFromParentViewController];
        [toVC didMoveToParentViewController:self];
        completion();
        return;
    }

    UIImage *fromSnapshot = [fromVC.view snapshot];
    UIImage *toSnapshot = [toVC.view snapshot];

    // Start animating using Core Image
    CoreImageBlurTransitionView *transitionView = [[CoreImageBlurTransitionView alloc] initWithFrame:self.view.bounds
                                                                                           fromImage:fromSnapshot
                                                                                             toImage:toSnapshot];
    
    [transitionView changeTransition:CoreImageTransitionTypeGaussianBlur];
    [transitionView setDuration:duration];
    [self.view addSubview:transitionView];
    [transitionView start];

    [fromVC willMoveToParentViewController:nil];
    [fromVC.view removeFromSuperview];
    [fromVC removeFromParentViewController];
    
    // Finish after the duration
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW,
                                         duration * NSEC_PER_SEC);
    dispatch_after(when, dispatch_get_main_queue(), ^{
        [transitionView stop];
        [transitionView removeFromSuperview];

        [toVC didMoveToParentViewController:self];

        completion();
    });
}

@end
