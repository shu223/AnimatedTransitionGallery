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
    NSTimeInterval  startTime;
    CGRect imageRect;
}
@property (nonatomic, strong) CIImage *maskImage;
@property (nonatomic, strong) CIImage *shadingImage;
@property (nonatomic, strong) CIVector *extent;
@property (nonatomic, strong) CIContext *myContext;
@property (nonatomic, assign) NSTimer *timer;
@end


@implementation CoreImageTransitionView

- (instancetype)initWithFrame:(CGRect)frame
                    fromImage:(UIImage *)fromImage
                      toImage:(UIImage *)toImage
{
    self = [super initWithFrame:frame];
    if (self) {

        startTime = [NSDate timeIntervalSinceReferenceDate];

        // 遷移前後の画像とマスク画像を生成
        UIImage *uiMaskImage = [UIImage imageNamed:@"mask.jpg"];
        UIImage *uiShadingImage = [UIImage imageNamed:@"restrictedshine.tiff"];
        
        _inputImage       = [CIImage imageWithCGImage:fromImage.CGImage];
        _inputTargetImage = [CIImage imageWithCGImage:toImage.CGImage];
        self.maskImage = [CIImage imageWithCGImage:uiMaskImage.CGImage];
        self.shadingImage = [CIImage imageWithCGImage:uiShadingImage.CGImage];
        
        CGFloat width = fromImage.size.width * fromImage.scale;
        CGFloat height = fromImage.size.height * fromImage.scale;
        // 表示領域を示す矩形（CGRect型）
        imageRect = CGRectMake(0, 0, width, height);
        
        
        // 遷移アニメーションが起こる領域を示す矩形（CIVector型）
        self.extent = [CIVector vectorWithX:0 Y:0 Z:width W:height];
        
        // EAGLDelegateの設定
        self.delegate = self;
        
        // コンテキスト生成
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        self.myContext = [CIContext contextWithEAGLContext:self.context];        
    }
    return self;
}

- (void)dealloc {
    [self stop];
}


// =============================================================================
#pragma mark - Private

- (CIImage *)imageForTransitionAtTime:(float)time
{
    [self.transition setValue:self.inputImage forKey:kCIInputImageKey];
    [self.transition setValue:self.inputTargetImage forKey:kCIInputTargetImageKey];

    [self.transition setValue:@(time) forKey:kCIInputTimeKey];
        
    // フィルタ処理実行
    CIImage *transitionImage = [self.transition valueForKey:kCIOutputImageKey];
    
    return transitionImage;
}


// =============================================================================
#pragma mark - Public

- (void)start {
    
    startTime = [NSDate timeIntervalSinceReferenceDate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30.0
                                                  target:self
                                                selector:@selector(onTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer fire];
}

- (void)stop {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)changeTransition:(CoreImageTransitionType)type {
    
    CIImage *optionImage;
    
    switch (type) {
            
        case CoreImageTransitionTypeDisintegrateWithMask:
            optionImage = self.maskImage;
            break;

        case CoreImageTransitionTypePageCurl:
            optionImage = self.shadingImage;
            break;


        case CoreImageTransitionTypeRipple:
            optionImage = self.shadingImage;
            break;

        default:
            // no option image
            break;
            
    }
    
    if (optionImage) {
        _transition = [CoreImageTransitionHelper transitionWithType:type
                                                             extent:self.extent
                                                        optionImage:optionImage];
    }
    else {
        _transition = [CoreImageTransitionHelper transitionWithType:type
                                                             extent:self.extent];
    }
}

- (NSString *)currentFilterName {
    
    return self.transition.name;
}


// =============================================================================
#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    float t = [NSDate timeIntervalSinceReferenceDate] - startTime;
    CIImage *image = [self imageForTransitionAtTime:t];
    
    // 描画領域を示す矩形
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGRect destRect = CGRectMake(0, self.bounds.size.height * scale - imageRect.size.height,
                                 imageRect.size.width,
                                 imageRect.size.height);
    
    [self.myContext drawImage:image
                       inRect:destRect
                     fromRect:imageRect];
}


// =============================================================================
#pragma mark - Timer Handler

- (void)onTimer:(NSTimer *)timer {

    [self setNeedsDisplay];
}

@end
