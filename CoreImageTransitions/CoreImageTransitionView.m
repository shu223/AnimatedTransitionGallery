//
//  TransitionView.m
//  CITransitionSample
//
//  Created by shuichi on 13/03/10.
//  Copyright (c) 2013年 Shuichi Tsutsumi. All rights reserved.
//

#import "CoreImageTransitionView.h"
#import "CoreImageTransitionHelper.h"


@interface CoreImageTransitionView ()
<GLKViewDelegate>
{
    NSTimeInterval  base;
    CGRect imageRect;
}
@property (nonatomic, strong) CIImage *inputImage;
@property (nonatomic, strong) CIImage *inputTargetImage;
@property (nonatomic, strong) CIImage *maskImage;
@property (nonatomic, strong) CIImage *shadingImage;
@property (nonatomic, strong) CIVector *extent;
@property (nonatomic, strong) CIFilter *transition;
@property (nonatomic, strong) CIContext *myContext;
@end


@implementation CoreImageTransitionView

- (instancetype)initWithFrame:(CGRect)frame
                    fromImage:(UIImage *)fromImage
                      toImage:(UIImage *)toImage
{
    self = [super initWithFrame:frame];
    if (self) {

        // 遷移前後の画像とマスク画像を生成
        UIImage *uiMaskImage = [UIImage imageNamed:@"mask.jpg"];
        UIImage *uiShadingImage = [UIImage imageNamed:@"restrictedshine.tiff"];
        
        self.inputImage       = [CIImage imageWithCGImage:fromImage.CGImage];
        self.inputTargetImage = [CIImage imageWithCGImage:toImage.CGImage];
        self.maskImage = [CIImage imageWithCGImage:uiMaskImage.CGImage];
        self.shadingImage = [CIImage imageWithCGImage:uiShadingImage.CGImage];
        
        CGFloat width = fromImage.size.width * fromImage.scale;
        CGFloat height = fromImage.size.height * fromImage.scale;
        // 表示領域を示す矩形（CGRect型）
        imageRect = CGRectMake(0, 0, width, height);
        
        
        // 遷移アニメーションが起こる領域を示す矩形（CIVector型）
        self.extent = [CIVector vectorWithX:0 Y:0 Z:width W:height];
        
        // 遷移アニメーション制御の基準となる時刻
        base = [NSDate timeIntervalSinceReferenceDate];
        
        // 遷移アニメーションを制御するタイマー
        [NSTimer scheduledTimerWithTimeInterval:1.0/30.0
                                         target:self
                                       selector:@selector(onTimer:)
                                       userInfo:nil
                                        repeats:YES];
        
        // EAGLDelegateの設定
        self.delegate = self;
        
        // コンテキスト生成
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        self.myContext = [CIContext contextWithEAGLContext:self.context];
    }
    return self;
}


// =============================================================================
#pragma mark - Private

- (CIImage *)imageForTransitionAtTime:(float)time
{
    [self.transition setValue:self.inputImage forKey:kCIInputImageKey];
    [self.transition setValue:self.inputTargetImage forKey:kCIInputTargetImageKey];
    
    [self.transition setValue:@(time) forKey:kCIInputTimeKey];
    
    // フィルタ処理実行
    CIImage *transitionImage = [self.transition valueForKey:@"outputImage"];
    
    return transitionImage;
}


// =============================================================================
#pragma mark - Public

- (void)changeTransition:(CoreImageTransitionType)type {
    
    CIImage *optionImage;
    
    switch (type) {
            
        case CoreImageTransitionTypeDissolve:
        case CoreImageTransitionTypeCopyMachine:
        case CoreImageTransitionTypeFlash:
        case CoreImageTransitionTypeMod:
        case CoreImageTransitionTypeSwipe:
        case CoreImageTransitionTypePageCurlWithShadow:
        default:
            break;
            
        case CoreImageTransitionTypeDisintegrateWithMask:
            optionImage = self.maskImage;
            break;

        case CoreImageTransitionTypePageCurl:
            optionImage = self.shadingImage;
            break;


        case CoreImageTransitionTypeRipple:
            optionImage = self.shadingImage;
            break;
    }
    
    if (optionImage) {
        self.transition = [CoreImageTransitionHelper transitionWithType:type
                                                          extent:self.extent
                                                     optionImage:optionImage];
    }
    else {
        self.transition = [CoreImageTransitionHelper transitionWithType:type
                                                          extent:self.extent];
    }
}

- (NSString *)currentFilterName {
    
    return self.transition.name;
}


// =============================================================================
#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        float t = [NSDate timeIntervalSinceReferenceDate] - base;
        CIImage *image = [self imageForTransitionAtTime:t];

        // 描画領域を示す矩形
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGRect destRect = CGRectMake(0, self.bounds.size.height * scale - imageRect.size.height,
                                     imageRect.size.width,
                                     imageRect.size.height);

        dispatch_async(dispatch_get_main_queue(), ^{

            [self.myContext drawImage:image
                               inRect:destRect
                             fromRect:imageRect];
        });
    });
}


// =============================================================================
#pragma mark - Timer Handler

- (void)onTimer:(NSTimer *)timer {

    [self setNeedsDisplay];
}

@end
