//
//  TTMDetailViewController.h
//  AnimatedTransitionGallery
//
//  Created by shuichi on 3/10/14.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTMDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
