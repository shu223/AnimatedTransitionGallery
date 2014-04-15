//
//  TTMMasterViewController.m
//  TTMAnimatedTransitionGallery
//
//  Created by shuichi on 3/10/14.
//  Copyright (c) 2014 Shuichi Tsutsumi. All rights reserved.
//

#import "TTMMasterViewController.h"
#import "TTMDetailViewController.h"
#import "HUTransitionAnimator.h"
#import "ATCAnimatedTransitioning.h"
#import "LCZoomTransition.h"
#import "CEReversibleAnimationController.h"


@interface TTMMasterViewController ()
<UINavigationControllerDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *transitionClassName;
@end


@implementation TTMMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.delegate = self;
    
    self.items = @[
                   @"HUTransitionVerticalLinesAnimator",
                   @"HUTransitionHorizontalLinesAnimator",
                   @"ZBFallenBricksAnimator",
                   @"ATCAnimatedTransitioningFade",
                   @"ATCAnimatedTransitioningBounce",
                   @"ATCAnimatedTransitioningSquish",
                   @"ATCAnimatedTransitioningFloat",
                   @"LCZoomTransition",
                   @"CECardsAnimationController",
                   @"CECrossfadeAnimationController",
                   @"CECubeAnimationController",
                   @"CEExplodeAnimationController",
                   @"CEFlipAnimationController",
                   @"CEFoldAnimationController",
                   @"CENatGeoAnimationController",
                   @"CEPortalAnimationController",
                   @"CETurnAnimationController",
                   ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


// =============================================================================
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.items[indexPath.row]];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        self.transitionClassName = self.items[indexPath.row];
        
        [[segue destinationViewController] setDetailItem:self.items[indexPath.row]];
    }
}


// =============================================================================
#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (NSClassFromString(self.transitionClassName)) {
        
        Class aClass = NSClassFromString(self.transitionClassName);
        id animator = [[aClass alloc] init];
     
        [self setupAnimator:animator
               forOperation:operation];
        
        return animator;
    }
    else {
        return nil;
    }
}


// =============================================================================
#pragma mark - Private

- (void)setupAnimator:(id)animator
         forOperation:(UINavigationControllerOperation)operation
{
    
    if ([animator isKindOfClass:[HUTransitionAnimator class]]) {
        
        if (operation == UINavigationControllerOperationPush) {
            
            [(HUTransitionAnimator *)animator setPresenting:YES];
        }
        else {
            [(HUTransitionAnimator *)animator setPresenting:NO];
        }
    }
    else if ([animator isKindOfClass:[ATCAnimatedTransitioning class]]) {
        
        [animator setIsPush:YES];
        [animator setDuration:1.0];
        
        if (operation == UINavigationControllerOperationPush) {
            
            [animator setDismissal:NO];
            [(ATCAnimatedTransitioning *)animator setDirection:ATCTransitionAnimationDirectionRight];
        }
        else {
            [animator setDismissal:YES];
            [(ATCAnimatedTransitioning *)animator setDirection:ATCTransitionAnimationDirectionLeft];
        }
    }
    else if ([animator isKindOfClass:[LCZoomTransition class]]) {
        
        [(LCZoomTransition *)animator setTransitionDuration:0.5];
        [(LCZoomTransition *)animator setOperation:operation];
    }
    else if ([animator isKindOfClass:[CEReversibleAnimationController class]]) {
        
        [(CEReversibleAnimationController *)animator setReverse:(operation == UINavigationControllerOperationPop)];
    }
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)pop:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
