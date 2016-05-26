//
//  HFDynamicAnimator.m
//  CustomAnimations
//
//  Created by Gregory Klein on 11/13/13.
//  Copyright (c) 2013 HardFlip. All rights reserved.
//

#import "HFDynamicAnimator.h"

@interface HFDynamicAnimator()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation HFDynamicAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
   return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
   UIViewController *fromViewController =
   [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
   UIViewController *toViewController =
   [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

   _animator = [[UIDynamicAnimator alloc] initWithReferenceView:[transitionContext containerView]];

   if (_presenting)
   {
      fromViewController.view.userInteractionEnabled = NO;
      [[transitionContext containerView] addSubview:fromViewController.view];
      [[transitionContext containerView] addSubview:toViewController.view];

      CGRect startingFrame = toViewController.view.frame;
      startingFrame.origin.y = CGRectGetHeight(startingFrame);
      startingFrame.size.height = 150;
      toViewController.view.frame = startingFrame;

      UISnapBehavior *snapBehavior =
         [[UISnapBehavior alloc] initWithItem:toViewController.view
                                  snapToPoint:CGPointMake(startingFrame.size.width/2,
                                                          startingFrame.origin.y - 75)];
      snapBehavior.damping = 0.5f;
      [_animator addBehavior:snapBehavior];
   }
   else
   {
      toViewController.view.userInteractionEnabled = YES;

      [[transitionContext containerView] addSubview:toViewController.view];
      [[transitionContext containerView] addSubview:fromViewController.view];

      UIGravityBehavior *gravityBehaviour =
         [[UIGravityBehavior alloc] initWithItems:@[fromViewController.view]];

      gravityBehaviour.gravityDirection = CGVectorMake(0, 10);
      [_animator addBehavior:gravityBehaviour];

      UIDynamicItemBehavior *itemBehaviour =
         [[UIDynamicItemBehavior alloc] initWithItems:@[fromViewController.view]];

      [itemBehaviour addAngularVelocity:-M_PI_2
                                forItem:fromViewController.view];
      
      [_animator addBehavior:itemBehaviour];
   }

   [self completeAnimation:transitionContext];
}

- (void)completeAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
   double delayInSeconds = [self transitionDuration:transitionContext];
   dispatch_time_t popTime =
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));

   dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
      UIDynamicAnimator *blockAnimator = _animator;
      if (blockAnimator)
         [transitionContext completeTransition:YES];
   });
}

@end
