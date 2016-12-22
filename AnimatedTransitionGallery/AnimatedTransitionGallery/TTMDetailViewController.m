//
//  TTMDetailViewController.m
//  AnimatedTransitionGallery
//
//  Created by shuichi on 3/10/14.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "TTMDetailViewController.h"


@interface TTMDetailViewController ()
@end


@implementation TTMDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    
    UIColor *startColor = [UIColor colorWithRed:1.
                                          green:149./255.
                                           blue:0.
                                          alpha:1.];
    UIColor *endColor   = [UIColor colorWithRed:1.
                                          green:94./255.
                                           blue:58./255.
                                          alpha:1.];

    gradient.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    [self.view.layer insertSublayer:gradient atIndex:0];


    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
