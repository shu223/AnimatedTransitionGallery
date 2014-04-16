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
#import "ADTransitionController.h"
#import "KWTransitionHelper.h"


@interface TTMMasterViewController ()
<UINavigationControllerDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *transitionClassName;
@property (nonatomic, strong) id animator;
@end


@implementation TTMMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = backgroundView.bounds;
    UIColor *startColor = [UIColor colorWithRed: 90./255.
                                          green:200./255.
                                           blue:251./255.
                                          alpha:1.0];
    UIColor *endColor   = [UIColor colorWithRed: 82./255.
                                          green:237./255.
                                           blue:199./255.
                                          alpha:1.0];
    
    gradient.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
    [backgroundView.layer addSublayer:gradient];
    self.tableView.backgroundView = backgroundView;

    self.navigationController.delegate = self;
    
    self.items = @[
                   @"HUTransitionVerticalLinesAnimator",
                   @"HUTransitionHorizontalLinesAnimator",
                   @"HUTransitionGhostAnimator",
                   @"ZBFallenBricksAnimator",
                   @"ATCAnimatedTransitioningFade",
                   @"ATCAnimatedTransitioningBounce",
                   @"ATCAnimatedTransitioningSquish",
                   @"ATCAnimatedTransitioningFloat",
                   @"LCZoomTransition",
                   @"ADBackFadeTransition",
                   @"ADCarrouselTransition",
                   @"ADCrossTransition",
                   @"ADCubeTransition",
                   @"ADFadeTransition",
                   @"ADFlipTransition",
                   @"ADFoldTransition",
                   @"ADGhostTransition",
                   @"ADGlueTransition",
                   @"ADModernPushTransition",
                   @"ADPushRotateTransition",
                   @"ADScaleTransition",
                   @"ADSlideTransition",
                   @"ADSwapTransition",
                   @"ADSwipeFadeTransition",
                   @"ADSwipeTransition",
                   @"ADZoomTransition",
                   @"CECardsAnimationController",
                   @"CECrossfadeAnimationController",
                   @"CECubeAnimationController",
                   @"CEExplodeAnimationController",
                   @"CEFlipAnimationController",
                   @"CEFoldAnimationController",
                   @"CENatGeoAnimationController",
                   @"CEPortalAnimationController",
                   @"CETurnAnimationController",
                   KWTransitionStyleNameRotateFromTop,
                   KWTransitionStyleNameFadeBackOver,
                   KWTransitionStyleNameBounceIn,
                   KWTransitionStyleNameDropOut,
                   KWTransitionStyleNameStepBackScroll,
                   KWTransitionStyleNameStepBackSwipe,
                   KWTransitionStyleNameUp,
                   KWTransitionStyleNamePushUp,
                   KWTransitionStyleNameFall,
                   KWTransitionStyleNameSink,
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
    self.animator = nil;

    if (NSClassFromString(self.transitionClassName)) {
        
        Class aClass = NSClassFromString(self.transitionClassName);
        self.animator = [[aClass alloc] init];
    }
    // only for KWTransition
    else if ([self.transitionClassName hasPrefix:@"KWTransition"]) {
        
        KWTransition *transition = [[KWTransition alloc] init];
        transition.style = [KWTransitionHelper styleForTransitionName:self.transitionClassName];

        self.animator = transition;
    }
    
    if (self.animator) {

        [self setupAnimator:self.animator
               forOperation:operation];
    }
    
    return self.animator;
}


// =============================================================================
#pragma mark - Private

// setup for each OSS
- (void)setupAnimator:(id)animator
         forOperation:(UINavigationControllerOperation)operation
{
    // HUAnimator
    if ([animator isKindOfClass:[HUTransitionAnimator class]]) {
        
        if (operation == UINavigationControllerOperationPush) {
            
            [(HUTransitionAnimator *)animator setPresenting:YES];
        }
        else {
            [(HUTransitionAnimator *)animator setPresenting:NO];
        }
    }
    // Animated-Transition-Collection
    else if ([animator isKindOfClass:[ATCAnimatedTransitioning class]]) {
        
        [(ATCAnimatedTransitioning *)animator setIsPush:YES];
        [(ATCAnimatedTransitioning *)animator setDuration:1.0];
        
        if (operation == UINavigationControllerOperationPush) {
            
            [animator setDismissal:NO];
            [(ATCAnimatedTransitioning *)animator setDirection:ATCTransitionAnimationDirectionRight];
        }
        else {
            [animator setDismissal:YES];
            [(ATCAnimatedTransitioning *)animator setDirection:ATCTransitionAnimationDirectionLeft];
        }
    }
    // LCZoomTransition
    else if ([animator isKindOfClass:[LCZoomTransition class]]) {
        
        [(LCZoomTransition *)animator setTransitionDuration:0.5];
        [(LCZoomTransition *)animator setOperation:operation];
    }
    // VCTransitionsLibrary
    else if ([animator isKindOfClass:[CEReversibleAnimationController class]]) {
        
        [(CEReversibleAnimationController *)animator setReverse:(operation == UINavigationControllerOperationPop)];
    }
    // ADTransition
    else if ([self.animator isKindOfClass:[ADTransition class]]) {
        
        ADTransition *transition = self.animator;
        
        Class aClass = [transition class];
        
        if ([transition respondsToSelector:@selector(initWithDuration:orientation:sourceRect:)]) {
            
            transition = [[aClass alloc] initWithDuration:0.5f
                                              orientation:ADTransitionRightToLeft
                                               sourceRect:self.tableView.bounds];
        }
        else if ([transition respondsToSelector:@selector(initWithDuration:sourceRect:)]) {
            
            transition = [[aClass alloc] initWithDuration:0.5f
                                               sourceRect:self.tableView.bounds];
        }
        else {
            
            transition = [[aClass alloc] initWithDuration:0.5f];
        }
        
        self.animator = [[ADTransitioningDelegate alloc] initWithTransition:transition];
    }
    // KWTransition
    else if ([self.animator isKindOfClass:[KWTransition class]]) {
        
        if (operation == UINavigationControllerOperationPush) {
            
            [(KWTransition *)animator setAction:KWTransitionStepPresent];
        }
        else {
            [(KWTransition *)animator setAction:KWTransitionStepDismiss];
        }
        
        if ([(KWTransition *)self.animator style] == KWTransitionStyleSink) {
            [(KWTransition *)self.animator setSettings:KWTransitionSettingDirectionDown];
        }
    }
}


// =============================================================================
#pragma mark - IBAction

- (IBAction)pop:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
