//
//  UIViewController+Transition.h
//
//  Created by Shuichi Tsutsumi on 10/13/15.
//  Copyright © 2015 Shuichi Tsutsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CoreImageTransition)

- (void)transitionFromViewController:(UIViewController *)fromVC
                    toViewController:(UIViewController *)toVC
                          presenting:(BOOL)presenting
                            duration:(NSTimeInterval)duration
                          completion:(void (^)(void))completion;

@end
