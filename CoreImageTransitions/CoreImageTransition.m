//
//  CoreImageTransition.m
//  TTMAnimatedTransitionGallery
//
//  Created by Shuichi Tsutsumi on 10/5/15.
//  Copyright © 2015 Shuichi Tsutsumi. All rights reserved.
//

#import "CoreImageTransition.h"
#import "CoreImageTransitionView.h"



@interface CoreImageTransition ()
@property (nonatomic, strong) CoreImageTransitionView *transitionView;
@end


@implementation CoreImageTransition

#pragma mark - Public

- (void)setTransitionTypeWithName:(NSString *)name {

    _type = CoreImageTransitionTypeDissolve;
    
    if ([name isEqualToString:kCoreImageTransitionTypeNameDissolve]) {
        _type = CoreImageTransitionTypeDissolve;
    }
    else if ([name isEqualToString:kCoreImageTransitionTypeNameCopyMachine]) {
        _type = CoreImageTransitionTypeCopyMachine;
    }
    else if ([name isEqualToString:kCoreImageTransitionTypeNameFlash]) {
        _type = CoreImageTransitionTypeFlash;
    }
    else if ([name isEqualToString:kCoreImageTransitionTypeNameMod]) {
        _type = CoreImageTransitionTypeMod;
    }
    else if ([name isEqualToString:kCoreImageTransitionTypeNameSwipe]) {
        _type = CoreImageTransitionTypeSwipe;
    }
    else if ([name isEqualToString:kCoreImageTransitionTypeNameDisintegrateWithMask]) {
        _type = CoreImageTransitionTypeDisintegrateWithMask;
    }
    else if ([name isEqualToString:kCoreImageTransitionTypeNamePageCurl]) {
        _type = CoreImageTransitionTypePageCurl;
    }
    else if ([name isEqualToString:kCoreImageTransitionTypeNamePageCurlWithShadow]) {
        _type = CoreImageTransitionTypePageCurlWithShadow;
    }
    else if ([name isEqualToString:kCoreImageTransitionTypeNameRipple]) {
        _type = CoreImageTransitionTypeRipple;
    }
}


// =============================================================================
#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toVC.view];
    
    // Create snapshots
    UIImage *fromSnapshot = [fromVC.view snapshot];
    UIImage *toSnapshot   = [toVC.view snapshot];
    
    // Start animating using Core Image
    self.transitionView = [[CoreImageTransitionView alloc] initWithFrame:containerView.bounds
                                                               fromImage:fromSnapshot
                                                                 toImage:toSnapshot];
    [self.transitionView changeTransition:_type];
    [[transitionContext containerView] addSubview:_transitionView];
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

- (void)animationEnded:(BOOL)transitionCompleted
{
}

@end



@implementation UIView (Snapshot)
- (UIImage *)snapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
    CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
    
    // http://stackoverflow.com/questions/6402393/screenshot-from-a-uitableview
    if ([self isKindOfClass:[UITableView class]]) {
        CGContextTranslateCTM(graphicsContext, 0,
                              -[(UITableView *)self contentOffset].y);
    }
    
    CGContextFillRect(graphicsContext, self.bounds);
    
    // good explanation of differences between drawViewHierarchyInRect:afterScreenUpdates: and renderInContext:
    // https://github.com/radi/LiveFrost/issues/10#issuecomment-28959525
    [self.layer renderInContext:graphicsContext];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}
@end
